require("mason").setup()

require("blink.cmp").build():pwait()
require("blink.cmp").setup({
    keymap = {
        preset = "super-tab",
    },
})

vim.api.nvim_create_autocmd("User", {
    pattern = "TSUpdate",
    callback = function()
        require("nvim-treesitter.parsers").crystal = {
            install_info = {
                url = "https://github.com/crystal-lang-tools/tree-sitter-crystal",
                generate = false,
                generate_from_json = false,
                queries = "queries/nvim",
            },
        }
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
        end
    end,
})

vim.lsp.config("lua_ls", {
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath("config") and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc")) then
                return
            end
        end

        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
                -- Tell the language server which version of Lua you're using (most
                -- likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
                -- Tell the language server how to find Lua modules same way as Neovim
                -- (see `:h lua-module-load`)
                path = {
                    "lua/?.lua",
                    "lua/?/init.lua",
                },
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    -- For LSP Settings Type Annotations: https://github.com/neovim/nvim-lspconfig#lsp-settings-type-annotations
                    vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
                },
                -- Or pull in all of 'runtimepath'.
                -- NOTE: this is a lot slower and will cause issues when working on
                -- your own configuration.
                -- See https://github.com/neovim/nvim-lspconfig/issues/3189
                -- library = vim.api.nvim_get_runtime_file('', true),
            },
        })
    end,
    settings = {
        Lua = {
            hint = {
                arrayIndex = "Disable",
            },
        },
    },
})

vim.lsp.config("vtsls", {
    settings = {
        complete_function_calls = true,
        vtsls = {
            enableMoveToFileCodeAction = true,
            autoUseWorkspaceTsdk = true,
            experimental = {
                maxInlayHintLength = 30,
                completion = {
                    enableServerSideFuzzyMatch = true,
                },
            },
        },
        javascript = {
            preferences = {
                importModulesSpecifier = "non-relative",
            },
        },
        typescript = {
            preferences = {
                importModulesSpecifier = "non-relative",
            },
            updateImportsOnFileMove = { enabled = "always" },
            suggest = {
                completeFunctionCalls = true,
            },
            inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
            },
        },
    },
})

vim.lsp.config("gopls", {
    settings = {
        gopls = {
            semanticTokens = true,
            hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                constantValues = true,
                functionTypeParameters = true,
                ignoredError = true,
                parameterNames = true,
                rangeVariableTypes = true,
            },
        },
    },
})

-- astro language server requires typescript sdk <= 6 to work
vim.lsp.config("astro", {
    before_init = function(_, config)
        local tsdk = os.getenv("HOME") .. "/.local/lib/astro/node_modules/typescript/lib"
        if vim.fn.isdirectory(tsdk) ~= 1 then
            vim.notify("astro language server requires typescript@~6 to be installed in $HOME/.local/lib/astro", vim.log.levels.ERROR)
            return
        end
        config.init_options = config.init_options or {}
        config.init_options.typescript = config.init_options.typescript or {}
        config.init_options.typescript.tsdk = tsdk
    end,
})

-- crystal
vim.lsp.enable("ameba-ls")
vim.lsp.enable("liger")

-- elixir
vim.lsp.enable("expert")

-- go
vim.lsp.enable("gopls")

-- lua
vim.lsp.enable("lua_ls")

-- web
vim.lsp.enable("astro")
vim.lsp.enable("svelte")
vim.lsp.enable("tailwindcss")
vim.lsp.enable("vtsls")
