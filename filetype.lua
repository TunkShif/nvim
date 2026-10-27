-- Helm charts: anything under a directory that has a Chart.yaml.
-- Templates get the helm tree-sitter grammar (gotmpl + injected yaml), which
-- copes with heavy {{ }} usage far better than the yaml grammar.
local function in_helm_chart(path)
    return vim.fs.root(path, "Chart.yaml") ~= nil
end

local function helm_template(path)
    if in_helm_chart(path) then
        return "helm"
    end
end

vim.filetype.add({
    pattern = {
        [".*/templates/.*%.ya?ml"] = helm_template,
        [".*/templates/.*%.tpl"] = helm_template,
        [".*/templates/NOTES%.txt"] = helm_template,
        [".*/values[^/]*%.ya?ml"] = function(path)
            if in_helm_chart(path) then
                return "yaml.helm-values"
            end
        end,
    },
})
