-- Crystal indentexpr, ported to Lua from vim-crystal
-- (https://github.com/vim-crystal/vim-crystal, indent/crystal.vim +
-- autoload/crystal/indent.vim @ dc21188). MIT, (c) 2014 vim-crystal developers.
--
-- Differences from upstream:
--   * string/comment detection uses the tree-sitter "crystal" parser instead
--     of vim-crystal's syntax groups (synID), since highlighting is done by
--     tree-sitter here;
--   * all regexes are matched case-sensitively (\C), independent of 'ignorecase'.
--
-- Options (same as upstream):
--   vim.g.crystal_indent_assignment_style = "hanging" | "variable"
--   vim.g.crystal_indent_block_style      = "expression" | "do"

local fn = vim.fn
local M = {}

-- Regexes {{{1

local sol = [=[\%(\_^\|;\)\s*\zs]=]
local eol = [=[\ze\s*\%(#.*\)\=\%(\_$\|;\)]=]

local link_attribute_regex = sol .. [=[@\[.*]]=]

local type_declaration_regex = sol .. [=[\%(\<\%(private\|protected\)\s\+\)\=]=] .. [=[\%(\<\%(getter\|setter\|property\)?\=\s\+\)\=]=] .. [=[@\=\h\k*\s\+:\s\+\S.*]=]

local operator_regex = [=[\$\@1<!]=]
    .. [=[\%(]=]
    .. [=[[.,:/+*\-=~<&^\\]]=]
    .. [=[\|]=]
    .. [=[\%(\%(\<do\>\|%\@1<!{\)\s*|[^|]*\)\@<!|]=]
    .. [=[\|]=]
    .. [=[{\@1<!%]=]
    .. [=[\|]=]
    .. [=[\%(\k\|]\)\@1<!\!]=]
    .. [=[\|]=]
    .. [=[\%(\k\|]\)\@1<!?]=]
    .. [=[\|]=]
    .. [=[-\@1<!>]=]
    .. [=[\)]=]

local block_regex = [=[\%(]=] .. [=[\%(]=] .. operator_regex .. [=[\s*\)\@<!{\@1<!{]=] .. [=[\|]=] .. [=[\<do\>]=] .. [=[\)]=] .. [=[\s*\%(|[^|]*|\)\=]=] .. eol

local hanging_assignment_regex = [=[\%(]=] .. operator_regex .. [=[\s*\)\@<=]=] .. [=[\.\@1<!\<\%(if\||unless\|case\|begin\|select\)\>]=]

local end_start_regex = [=[\%(]=]
    .. sol
    .. [=[\%(]=]
    .. [=[\%(\<\%(private\|protected\)\s\+\)\=]=]
    .. [=[\%(\<\%(abstract\s\+\)\=\%(class\|struct\)\>\|\<\%(def\|module\|macro\|lib\|enum\|annotation\)\>\)]=]
    .. [=[\|]=]
    .. [=[\<\%(if\|unless\|while\|until\|case\|begin\|union\|select\)\>]=]
    .. [=[\)]=]
    .. [=[\|]=]
    .. hanging_assignment_regex
    .. [=[\|]=]
    .. block_regex
    .. [=[\)]=]

local end_middle_regex = sol .. [=[\<\%(else\|elsif\|when\|in\|rescue\|ensure\)\>]=]
local end_end_regex = sol .. [=[\%(\<end\>\|%\@1<!}\@1<!}}\@!\)]=]

local indent_keywords = end_start_regex .. [=[\|]=] .. end_middle_regex
local deindent_keywords = end_middle_regex .. [=[\|]=] .. end_end_regex

local macro_hanging_assignment_regex = [=[\%(]=] .. operator_regex .. [=[\s*\)\@<=]=] .. [=[\\\=\zs{%\s*\%(if\|unless\|begin\)\>.*%}]=]

local macro_end_start_regex = [=[\%(]=]
    .. sol
    .. [=[\%(]=]
    .. [=[\\\=\zs{%\s*\%(if\|unless\|for\|begin\)\>.*%}]=]
    .. [=[\|]=]
    .. [=[\\\=\zs{%.*\<do\s*%}]=]
    .. [=[\)]=]
    .. [=[\|]=]
    .. macro_hanging_assignment_regex
    .. [=[\)]=]

local macro_end_middle_regex = sol .. [=[\\\=\zs{%\s*\%(else\|elsif\)\>.*%}]=]
local macro_end_end_regex = sol .. [=[\\\=\zs{%\s*end\s*%}]=]

local macro_indent_keywords = macro_end_start_regex .. [=[\|]=] .. macro_end_middle_regex
local macro_deindent_keywords = macro_end_middle_regex .. [=[\|]=] .. macro_end_end_regex

local bracket_continuation_regex = [=[%\@1<![({[]]=] .. eol

local non_bracket_continuation_regex = [=[\%(]=] .. operator_regex .. [=[\|]=] .. [=[\<\%(if\|unless\|then\)\>]=] .. [=[\)]=] .. eol

local continuation_regex = bracket_continuation_regex .. [=[\|]=] .. non_bracket_continuation_regex

local bracket_switch_continuation_regex = [=[^\%([^(]\+\zs).\+\)\+\%(]=] .. continuation_regex .. [=[\)]=]

local block_continuation_regex = [=[^\s*[^])}\t ].*]=] .. block_regex

local leading_operator_regex = sol .. [=[\.]=]

-- Helpers {{{1

local function assignment_style()
    return vim.g.crystal_indent_assignment_style or "hanging"
end

local function block_style()
    return vim.g.crystal_indent_block_style or "expression"
end

--- 0-based byte index of the first match, or -1 (case-sensitive).
local function match(str, pat, start)
    if start then
        return fn.match(str, [[\C]] .. pat, start)
    end
    return fn.match(str, [[\C]] .. pat)
end

local function test(str, pat)
    return match(str, pat) >= 0
end

local indent = fn.indent
local getline = fn.getline

-- String/comment detection via tree-sitter {{{1

local string_types = { string = true, chained_string = true, heredoc_body = true, command = true }
local other_types = { char = true, symbol = true, regex = true, comment = true }

local parser -- tree-sitter parser for the current indentexpr evaluation

local function get_parser()
    local ok, p = pcall(vim.treesitter.get_parser, 0, "crystal", { error = false })
    if not ok or not p then
        return nil
    end
    -- Parse injections too: code inside macro blocks ({% if %} ... {% end %})
    -- is only parsed as an injected crystal tree.
    p:parse(true)
    return p
end

--- Classify a node found at (row, col).
--- Returns "string", "other", "delim", "macro" (opaque macro body: look
--- into injections), or nil (code).
local function classify(node, row, col)
    -- Whitespace not covered by any child (e.g. indentation before `#{` in a
    -- heredoc) resolves to the next token; classify by its container instead.
    local function contains(n)
        local sr, sc, er, ec = n:range()
        return (row > sr or (row == sr and col >= sc)) and (row < er or (row == er and col < ec))
    end
    while node and not contains(node) do
        node = node:parent()
    end
    if not node then
        return nil
    end

    local t = node:type()
    if t == "heredoc_start" or t == "heredoc_end" then
        return "delim"
    end
    if not node:named() then
        local parent = node:parent()
        local pt = parent and parent:type()
        if pt == "interpolation" and t == "#{" then
            -- The `#{` token's range includes preceding heredoc indentation;
            -- that whitespace is string content, not the delimiter.
            local _, _, er, ec = node:range()
            if row ~= er or col < ec - 2 then
                return "string"
            end
        end
        if pt and (string_types[pt] or other_types[pt] or pt == "interpolation") then
            return "delim"
        end
    end

    while node do
        t = node:type()
        if t == "interpolation" then
            return nil
        elseif t == "macro_content" then
            return "macro"
        elseif string_types[t] then
            return "string"
        elseif other_types[t] then
            return "other"
        end
        node = node:parent()
    end
    return nil
end

--- Classify the character at lnum:col (1-based, bytes).
--- Returns "string", "other" (char/symbol/regex/comment), "delim", or nil (code).
---
--- Trees are checked outer to inner. An outer string/comment wins (heredocs
--- like <<-CRYSTAL get injected as crystal); only opaque macro bodies
--- ({% if %} ... {% end %}) defer to the injected crystal tree.
local function syn_kind(lnum, col)
    if not parser or lnum < 1 then
        return nil
    end
    local line = getline(lnum)
    if col < 1 or col > #line then
        return nil
    end
    local row, c = lnum - 1, col - 1

    local function visit(ltree)
        if ltree:lang() ~= "crystal" then
            return nil, false
        end
        for _, tree in ipairs(ltree:trees()) do
            local root = tree:root()
            if vim.treesitter.is_in_node_range(root, row, c) then
                local node = root:descendant_for_range(row, c, row, c + 1)
                local kind = node and classify(node, row, c)
                if kind ~= "macro" then
                    return kind, true
                end
                for _, child in pairs(ltree:children()) do
                    local k, found = visit(child)
                    if found then
                        return k, true
                    end
                end
                return nil, true
            end
        end
        return nil, false
    end

    return (visit(parser))
end

local function is_in_string(lnum, col)
    return syn_kind(lnum, col) == "string"
end

local function is_in_string_or_comment(lnum, col)
    local k = syn_kind(lnum, col)
    return k == "string" or k == "other"
end

local function is_in_string_or_comment_or_delimiter(lnum, col)
    return syn_kind(lnum, col) ~= nil
end

local function skip()
    return is_in_string_or_comment(fn.line("."), fn.col(".")) and 1 or 0
end

local function searchpair(start, middle, stop, flags)
    return fn.searchpair([[\C]] .. start, middle ~= "" and [[\C]] .. middle or "", [[\C]] .. stop, flags, skip)
end

--- Like match(), but skips matches inside strings/comments/delimiters.
--- Returns the 1-based column of the match, or 0.
local function match_code(lnum, regex)
    local line = getline(lnum)
    local offset = match(line, regex)
    local col = offset + 1
    while col ~= 0 and is_in_string_or_comment_or_delimiter(lnum, col) do
        offset = match(line, regex, offset + 1)
        col = offset + 1
    end
    return col
end

local function relative_macro_depth(a, b)
    local diff = 0
    for i = a + 1, b - 1 do
        if match_code(i, macro_end_start_regex) ~= 0 then
            diff = diff + 1
        elseif match_code(i, macro_end_end_regex) ~= 0 then
            diff = diff - 1
        end
    end
    return diff
end

--- prevnonblank() that skips line comments and lines inside multiline strings.
local function prev_non_blank(lnum)
    lnum = fn.prevnonblank(lnum)
    while lnum > 0 do
        local start = match(getline(lnum), [[\S]]) + 1
        if not is_in_string_or_comment(lnum, start) then
            break
        end
        lnum = fn.prevnonblank(lnum - 1)
    end
    return lnum
end

--- Find the line above lnum that started the continuation lnum may be part of.
local function get_msl(lnum)
    local mslnum = lnum
    lnum = prev_non_blank(lnum - 1)

    while lnum > 0 do
        local msl = getline(mslnum)
        local line = getline(lnum)

        if test(msl, leading_operator_regex) then
            mslnum = lnum
        elseif test(line, type_declaration_regex) and not test(line, "," .. eol) and not test(line, block_regex) then
            return mslnum
        elseif test(line, non_bracket_continuation_regex) and test(msl, non_bracket_continuation_regex) then
            mslnum = lnum
        elseif test(line, non_bracket_continuation_regex) and (test(msl, bracket_continuation_regex) or test(msl, block_continuation_regex)) then
            mslnum = lnum
        elseif test(line, bracket_continuation_regex) and (test(msl, bracket_continuation_regex) or test(msl, block_continuation_regex)) then
            return mslnum
        elseif test(line, block_regex) and not test(msl, continuation_regex) then
            return mslnum
        elseif test(line, continuation_regex) then
            mslnum = lnum
        else
            break
        end

        lnum = prev_non_blank(lnum - 1)
    end

    return mslnum
end

--- Rightmost unmatched opening and closing brackets on line lnum.
local function extra_brackets(lnum)
    local pairs_ = { [")"] = "(", ["}"] = "{", ["]"] = "[" }
    local opening = { ["("] = {}, ["{"] = {}, ["["] = {} }
    local closing = {}

    local line = getline(lnum)
    local pos = match(line, "[][(){}]")
    while pos ~= -1 do
        if not is_in_string_or_comment(lnum, pos + 1) then
            local ch = line:sub(pos + 1, pos + 1)
            if opening[ch] then
                table.insert(opening[ch], { type = ch, pos = pos })
            else
                local stack = opening[pairs_[ch]]
                if #stack == 0 then
                    table.insert(closing, { type = ch, pos = pos })
                else
                    table.remove(stack)
                end
            end
        end
        pos = match(line, "[][(){}]", pos + 1)
    end

    local rightmost_opening = { type = "(", pos = -1 }
    local rightmost_closing = { type = ")", pos = -1 }
    for _, stack in pairs(opening) do
        for _, o in ipairs(stack) do
            if o.pos > rightmost_opening.pos then
                rightmost_opening = o
            end
        end
    end
    for _, c in ipairs(closing) do
        if c.pos > rightmost_closing.pos then
            rightmost_closing = c
        end
    end
    return rightmost_opening, rightmost_closing
end

local open_pattern = { [")"] = "(", ["]"] = [[\[]], ["}"] = "{" }

-- Callbacks: current line {{{1

local function multiline_string(info)
    if is_in_string(info.clnum, 1) then
        return indent(".")
    end
    return -1
end

local function closing_bracket_on_empty_line(info)
    local idx = match(info.cline, sol .. "[]})]")
    if idx >= 0 then
        local closing_bracket = info.cline:sub(idx + 1, idx + 1)
        searchpair(open_pattern[closing_bracket], "", closing_bracket, "bW")

        if fn.line(".") == info.clnum then
            return indent(".")
        end

        if block_style() == "do" and test(getline("."), block_regex) then
            return fn.col(".") - 1
        else
            return indent(get_msl(fn.line(".")))
        end
    end
    return -1
end

local function deindenting_macro_tag(info)
    local idx = match(info.cline, macro_deindent_keywords)
    if idx >= 0 then
        fn.cursor(0, idx + 1)
        searchpair(macro_end_start_regex, macro_end_middle_regex, macro_end_end_regex, "bW")

        -- If this tag was preceded by a \, keep searching until we find a
        -- tag that also has a \.
        if idx > 0 and info.cline:sub(idx, idx) == "\\" then
            while getline("."):sub(fn.col(".") - 1, fn.col(".") - 1) ~= "\\" do
                if searchpair(macro_end_start_regex, macro_end_middle_regex, macro_end_end_regex, "bW") <= 0 then
                    break
                end
            end
            fn.cursor(0, fn.col(".") - 1)
        end

        if fn.line(".") == info.clnum then
            return indent(".")
        end

        if assignment_style() == "hanging" and test(getline("."), macro_hanging_assignment_regex) then
            return fn.col(".") - 1
        else
            return indent(".")
        end
    end
    return -1
end

local function deindenting_keyword(info)
    local idx = match(info.cline, deindent_keywords)
    if idx >= 0 then
        fn.cursor(0, idx + 1)
        searchpair(end_start_regex, end_middle_regex, end_end_regex, "bW")

        local lnum = fn.line(".")
        if lnum == info.clnum then
            return indent(".")
        end

        local diff = relative_macro_depth(lnum, info.clnum)
        if diff > 0 then
            return indent(lnum) + info.sw * (diff + 1)
        elseif diff < 0 then
            return indent(lnum) + info.sw * (diff - 1)
        end

        local line = getline(lnum)
        if block_style() == "do" and test(line, block_regex) then
            return fn.col(".") - 1
        elseif assignment_style() == "hanging" and test(line, hanging_assignment_regex) then
            return fn.col(".") - 1
        else
            return indent(get_msl(lnum))
        end
    end
    return -1
end

local function leading_operator(info)
    if test(info.cline, leading_operator_regex) then
        return indent(get_msl(info.clnum)) + info.sw
    end
    return -1
end

-- Callbacks: previous line {{{1

local function empty_inside_string(info)
    local plnum = fn.prevnonblank(info.clnum - 1)
    local pline = getline(plnum)
    if test(info.cline, [[^\s*$]]) and is_in_string(plnum, 1) and is_in_string(plnum, #pline) then
        return indent(plnum)
    end
    return -1
end

local function start_of_file(info)
    if info.plnum == 0 then
        return 0
    end
    return -1
end

local function after_type_declaration(info)
    if test(info.pline, type_declaration_regex) then
        if test(info.pline, "," .. eol) then
            return indent(info.plnum)
        end
        local idx = match(info.pline, block_regex)
        if idx >= 0 then
            if block_style() == "do" then
                return idx + info.sw
            else
                return indent(info.plnum)
            end
        end
        return indent(get_msl(info.plnum))
    end
    return -1
end

local function after_link_attribute(info)
    if test(info.pline, link_attribute_regex) then
        return indent(info.plnum)
    end
    return -1
end

local function continued_line(info)
    local idx = match(info.pline, end_start_regex)
    if idx >= 0 and test(info.pline, non_bracket_continuation_regex) then
        local ind
        if test(info.pline, hanging_assignment_regex) then
            if assignment_style() == "hanging" then
                ind = idx
            else
                ind = indent(info.plnum)
            end
        else
            ind = indent(get_msl(info.plnum))
        end
        return ind + info.sw * 2
    end
    return -1
end

local function after_block_opening(info)
    local idx = match(info.pline, block_regex)
    if idx >= 0 then
        if block_style() == "do" then
            return idx + info.sw
        end
        local plnum_msl = get_msl(info.plnum)
        if test(getline(plnum_msl), "=" .. eol) then
            return indent(info.plnum) + info.sw
        else
            return indent(plnum_msl) + info.sw
        end
    end
    return -1
end

local function after_unbalanced_bracket(info)
    if test(info.pline, [=[[[({]\|[])}]]=] .. eol) then
        local opening, closing = extra_brackets(info.plnum)
        if opening.pos ~= -1 then
            if test(info.pline:sub(opening.pos + 2), "^" .. eol) then
                return indent(get_msl(info.plnum)) + info.sw
            else
                return opening.pos + 1
            end
        elseif closing.pos ~= -1 then
            fn.cursor(info.plnum, closing.pos + 1)
            searchpair(open_pattern[closing.type], "", closing.type, "bW")
            return indent(get_msl(fn.line(".")))
        end
    end
    return -1
end

local function after_leading_operator(info)
    if test(info.pline, leading_operator_regex) then
        return indent(get_msl(info.plnum))
    end
    return -1
end

local function after_end_macro_tag(info)
    local idx = match(info.pline, macro_end_end_regex)
    if idx >= 0 then
        fn.cursor(info.plnum, idx + 1)
        local lnum
        if assignment_style() == "hanging" then
            lnum = searchpair(macro_end_start_regex, "", macro_end_end_regex, "bW")
        else
            lnum = searchpair(macro_end_start_regex, macro_end_middle_regex, macro_end_end_regex, "bW")
        end
        return indent(lnum)
    end
    return -1
end

local function after_end_keyword(info)
    local idx = match(info.pline, end_end_regex)
    if idx >= 0 then
        if assignment_style() == "variable" and block_style() == "expression" then
            return idx
        end
        fn.cursor(info.plnum, idx + 1)
        local lnum = searchpair(end_start_regex, "", end_end_regex, "bW")
        return indent(get_msl(lnum))
    end
    return -1
end

local function after_indent_macro_tag(info)
    local idx = match(info.pline, macro_indent_keywords)
    if idx >= 0 then
        if assignment_style() == "hanging" and test(info.pline, macro_hanging_assignment_regex) then
            local shift = (idx > 0 and info.pline:sub(idx, idx) == "\\") and 1 or 0
            return idx + info.sw - shift
        else
            return indent(info.plnum) + info.sw
        end
    end
    return -1
end

local function after_indent_keyword(info)
    local idx = match(info.pline, indent_keywords)
    if idx >= 0 then
        -- An "end" after the indenting keyword on the same line: do nothing.
        if match(info.pline, end_end_regex) > idx then
            return indent(".")
        end
        if assignment_style() == "hanging" and test(info.pline, hanging_assignment_regex) then
            return idx + info.sw
        else
            return indent(info.plnum) + info.sw
        end
    end
    return -1
end

-- Callbacks: MSL {{{1

local function previous_not_msl(info)
    if info.plnum ~= info.plnum_msl then
        if test(info.pline, bracket_switch_continuation_regex) then
            return indent(info.plnum) - 1
        elseif test(info.pline, non_bracket_continuation_regex) then
            return indent(info.plnum)
        end
    end
    return -1
end

local function indenting_keyword_in_msl(info)
    local idx = match(info.pline_msl, indent_keywords)
    if idx >= 0 then
        local ind = indent(info.plnum_msl) + info.sw
        if test(info.pline_msl, end_end_regex) then
            ind = ind - info.sw
        elseif test(info.pline, hanging_assignment_regex) then
            if assignment_style() == "hanging" then
                ind = idx + info.sw
            else
                ind = indent(info.plnum_msl) + info.sw
            end
        end
        return ind
    end
    return -1
end

local function continued_hanging_operator(info)
    if match_code(info.plnum_msl, non_bracket_continuation_regex) ~= 0 and not test(info.pline_msl, sol .. [=[\%([\])}]\|\<end\>\)]=]) then
        if info.plnum_msl == info.plnum then
            return indent(info.plnum_msl) + info.sw
        else
            return indent(info.plnum_msl)
        end
    end
    return -1
end

-- Main {{{1

local curr_line_callbacks = {
    multiline_string,
    closing_bracket_on_empty_line,
    deindenting_macro_tag,
    deindenting_keyword,
    leading_operator,
}

local prev_line_callbacks = {
    start_of_file,
    after_type_declaration,
    after_link_attribute,
    continued_line,
    after_block_opening,
    after_unbalanced_bracket,
    after_leading_operator,
    after_end_macro_tag,
    after_end_keyword,
    after_indent_macro_tag,
    after_indent_keyword,
}

local msl_callbacks = {
    previous_not_msl,
    indenting_keyword_in_msl,
    continued_hanging_operator,
}

local function run(callbacks, info)
    for _, cb in ipairs(callbacks) do
        local ind = cb(info)
        if ind >= 0 then
            return ind
        end
    end
end

local function compute(lnum)
    local info = { sw = fn.shiftwidth(), clnum = lnum }
    info.cline = getline(lnum)

    local ind = run(curr_line_callbacks, info)
    if ind then
        return ind
    end

    -- Special case: avoid the expensive prev_non_blank for an empty line
    -- inside a string.
    ind = empty_inside_string(info)
    if ind >= 0 then
        return ind
    end

    info.plnum = prev_non_blank(lnum - 1)
    info.pline = getline(info.plnum)
    ind = run(prev_line_callbacks, info)
    if ind then
        return ind
    end

    info.plnum_msl = get_msl(info.plnum)
    info.pline_msl = getline(info.plnum_msl)
    ind = run(msl_callbacks, info)
    if ind then
        return ind
    end

    return indent(info.plnum)
end

--- indentexpr entry point. The cursor may be moved; Vim restores it.
function M.get(lnum)
    lnum = lnum or vim.v.lnum
    parser = get_parser()
    local ok, result = pcall(compute, lnum)
    parser = nil
    if not ok then
        return -1 -- keep current indent on error
    end
    return result
end

return M

-- vim: foldmethod=marker
