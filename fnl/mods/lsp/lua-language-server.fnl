(module mods.lsp.lua-language-server
  {autoload {lsp mods.lsp.lsp}})

(let [runtime_path (vim.split package.path ";")
      libraries (vim.api.nvim_get_runtime_file "" true)]
  (table.insert runtime_path "lua/?.lua")
  (table.insert runtime_path "lua/?/init.lua")
  (table.insert runtime_path "lib/?.lua")
  (table.insert runtime_path "lib/?/init.lua")
  (lsp.use :sumneko_lua
           {:opts {:settings {:Lua {:runtime {:version "LuaJIT"
                                              :path runtime_path}
                                    :diagnostics {:globals ["vim"]}
                                    :workspace {:library libraries}
                                    :telemetry {:enable false}}}}}))
