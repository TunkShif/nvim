# Neovim Config

A *simple*, *fast* and *modular* neovim configuration powered by [Fennel][0] for Elixir/React/Rust programmers.

![20220731-12-52-08](https://user-images.githubusercontent.com/10807119/182010763-d23a2baa-c979-4c0b-bb0e-81b469512379.png)
![20220731-12-52-54](https://user-images.githubusercontent.com/10807119/182010765-3b6b9f02-f028-4352-a868-2cfd34f94616.png)
![20220731-12-55-40](https://user-images.githubusercontent.com/10807119/182010766-457fb0b8-e866-46e9-a18b-3af7d627f9a4.png)

# Featured Plugins

<details>
  <summary>plugin list</summary>

| Plugin                                                                                                        | Description                                 |
| :------------------------------------------------------------------------------------------------------------ | :------------------------------------------ |
| [wbthomason/packer.nvim](https://github.com/wbthomason/packer.nvim)                                           | plugin manager                              |
| [Olical/aniseed](https://github.com/Olical/aniseed)                                                           | fennel support for neovim                   |
| [lewis6991/impatient.nvim](https://github.com/lewis6991/impatient.nvim)                                       | speed up loading modules                    |
| [navarasu/onedark.nvim](https://github.com/navarasu/onedark.nvim)                                             | one dark colorscheme                        |
| [lukas-reineke/indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim)                 | indent line                                 |
| [kyazdani42/nvim-tree.lua](https://github.com/kyazdani42/nvim-tree.lua)                                       | file tree                                   |
| [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)                                     | status line                                 |
| [akinsho/bufferline.nvim](https://github.com/akinsho/bufferline.nvim)                                         | buffer tab line                             |
| [goolord/alpha-nvim](https://github.com/goolord/alpha-nvim)                                                   | startup dashboard                           |
| [folke/which-key.nvim](https://github.com/folke/which-key.nvim)                                               | key mapping cheatsheet                      |
| [norcalli/nvim-colorizer.lua](https://github.com/norcalli/nvim-colorizer.lua)                                 | color hex values                            |
| [stevearc/dressing.nvim](https://github.com/stevearc/dressing.nvim)                                           | better ui                                   |
| [SmiteshP/nvim-gps](https://github.com/SmiteshP/nvim-gps)                                                     | context info for lualine                    |
| [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)                             | the ultimate fuzzy finder                   |
| [ahmedkhalf/project.nvim](https://github.com/ahmedkhalf/project.nvim)                                         | shortcut to your recently opened project    |
| [numToStr/FTerm.nvim](https://github.com/numToStr/FTerm.nvim)                                                 | floating terminal                           |
| [ggandor/lightspeed.nvim](https://github.com/ggandor/lightspeed.nvim)                                         | easymotion/vim-sneak alternative            |
| [windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs)                                             | brackets/parenthesis/braces auto pair       |
| [windwp/nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag)                                           | html tags auto pair                         |
| [numToStr/Comment.nvim](https://github.com/numToStr/Comment.nvim)                                             | comment operator                            |
| [nvim-treesitter/nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) | custom text objects                         |
| [tpope/vim-surround](https://github.com/tpope/vim-surround)                                                   | surround operator                           |
| [tpope/vim-repeat](https://github.com/tpope/vim-repeat)                                                       | dot repeat                                  |
| [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)                                             | lsp configuration                           |
| [jose-elias-alvarez/null-ls.nvim](https://github.com/jose-elias-alvarez/null-ls.nvim)                         | general usage lang server                   |
| [ray-x/lsp_signature.nvim](https://github.com/ray-x/lsp_signature.nvim)                                       | show function signature popup               |
| [hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp)                                                       | completion framework                        |
| [hrsh7th/cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp)                                               | lsp completion source                       |
| [hrsh7th/cmp-buffer](https://github.com/hrsh7th/cmp-buffer)                                                   | buffer completion source                    |
| [hrsh7th/cmp-path](https://github.com/hrsh7th/cmp-path)                                                       | path completion source                      |
| [hrsh7th/cmp-cmdline](https://github.com/hrsh7th/cmp-cmdline)                                                 | cmdline completions ource                   |
| [hrsh7th/cmp-vsnip](https://github.com/hrsh7th/cmp-vsnip)                                                     | vsnip completion source                     |
| [hrsh7th/vim-vsnip](https://github.com/hrsh7th/vim-vsnip)                                                     | vscode format snippet support               |
| [rafamadriz/friendly-snippets](https://github.com/rafamadriz/friendly-snippets)                               | a collection of snippets                    |
| [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)                         | treesitter for syntax highlighting and more |
| [jose-elias-alvarez/nvim-lsp-ts-utils](https://github.com/jose-elias-alvarez/nvim-lsp-ts-utils)               | typescript    plugin                        |
| [simrat39/rust-tools.nvim](https://github.com/simrat39/rust-tools.nvim)                                       | rust pluging                                |
| [elixir-editors/vim-elixir](https://github.com/elixir-editors/vim-elixir)                                     | elixir plugin                               |

</details>

# Installation

```sh
# if you already have a configured neovim, please make a backup first
cp -r ~/.config/nvim ~/.config/nvim.bak
git clone https://github.com/TunkShif/neovim ~/.config/nvim
```

You'll have to mannually install missing language servers.

# Keymapping Preset

Almost all user-defined key mappings are set in `fnl/mapping.fnl` using `which-key`. The default leader key is `SPC` i.e. the space key, and the default local leader key is `,`. Most mappings are grouped, following `<prefix> <group> <function>` format.

<details>
  <summary>mappings</summary>

|     Mapping     | Description                     |
| :-------------: | :------------------------------ |
|    `SPC f f`    | find files                      |
|    `SPC f b`    | find buffers                    |
|    `SPC f h`    | find history                    |
|    `SPC f g`    | find by grep                    |
|    `SPC f p`    | find projects                   |
|    `SPC F w`    | save file                       |
| `SPC w h/j/k/l` | goto window                     |
| `SPC w H/J/K/L` | move window                     |
|    `SPC w s`    | split window horizontally       |
|    `SPC w v`    | split window vertically         |
|    `SPC w x`    | swap window                     |
|    `SPC w q`    | quit window                     |
|    `SPC w w`    | switch window                   |
|    `SPC b n`    | next buffer                     |
|    `SPC b p`    | previous buffer                 |
|    `SPC b b`    | pick buffer                     |
|    `SPC b x`    | pick to close buffer            |
|    `SPC b h`    | close left buffers              |
|    `SPC b l`    | close right buffers             |
|    `SPC p i`    | install plugins                 |
|    `SPC p u`    | update plugins                  |
|    `SPC p c`    | compile plugin file             |
|    `SPC p C`    | clean plugins                   |
|    `SPC c r`    | lsp symbol rename               |
|    `SPC c a`    | lsp code action                 |
|    `SPC c f`    | lsp code format                 |
|    `SPC c k`    | lsp signature help              |
|    `SPC c d`    | lsp diagnostics list            |
|     `SPC e`     | toggle file tree                |
|   `SPC <Esc>`   | clear search highlight          |
|      `,,`       | using system clipboard register |
|     `<A-t>`     | toggle floating terminal        |
|      `gd`       | lsp goto definition             |
|      `gD`       | lsp goto declaration            |
|      `gi`       | lsp goto implementation         |
|      `gr`       | lsp goto references             |
|      `go`       | lsp open floating diafnostic    |
|       `K`       | lsp hover documentation         |
|      `[d`       | previous diagnostic             |
|      `]d`       | next diagnostic                 |
|      `[b`       | previous buffer                 |
|      `]b`       | next buffer                     |

</details>

And there're some customized text objects

| Mapping | Descriptiont        |
| :-----: | :------------------ |
|  `af`   | function body outer |
|  `if`   | function body inner |
|  `ac`   | class outer         |
|  `ic`   | class inner         |
|  `ab`   | block outer         |
|  `ib`   | block inner         |

# Customization

## Add a new plugin

Open `fnl/packs.fnl`, and add new plugins following the format `:<repo>/<name> {}` in the last `(use)` form.

You can pass addtional settings from available for `packer`'s `use` callback, like `requires`, `branch`, etc.

Besides you can optionally pass a `:mod <module>` option for plugin configuration setup.

## Add a new module

It's recommended to put your new module under `fnl/mods/<category>/<module>.fnl`, then use the module/autoload system from [aniseed][1] to define the new module.

### Example

If we want to add a new plugin from `foobar/baz.nvim`, and corresponding module for plugin configuration.

```fennel
;; fnl/packs.fnl
(use
  ;; other plugins
  :foobar/baz.nvim {:mod :util.baz})

;; fnl/mods/util/baz.fnl
(module mods.util.baz)

(let [baz (require :baz)]
  (baz.setup {}))
```

## Add a new language server

Use `use` function provided by `mods.lsp.lsp` module to add a new langauge server support.

```fennel
(module mods.lsp.elixir-ls
  {autoload {lsp mods.lsp.lsp}})

(lsp.use :tailwindcss {})

;; you can also pass additional settings

;; example from `mods.lsp.elixir-ls`
(lsp.use :elixirls
         {:opts {:cmd ["elixir-ls"] }})
;; example from `mods.lsp.lua-language-server`
(let [runtime_path (vim.split package.path ";")]
  (table.insert runtime_path "lua/?.lua")
  (table.insert runtime_path "lua/?/init.lua")
  (lsp.use :sumneko_lua
           {:opts {:settings {:Lua {:runtime {:version "LuaJIT"
                                              :path runtime_path}
                                    :diagnostics {:globals ["vim"]}
                                    :workspace {:library (vim.api.nvim_get_runtime_file "" true)}
                                    :telemetry {:enable false}} }}}))

;; if you want to add some additional logic in `on_attach` callback
;; you can pass an optional `:hook` option

;; example from `mods.lsp.tsserver`
(lsp.use :tsserver
         {:hook (fn [client buffer]
                  ;; disable tsserver formatting, using formatting via null-ls instead
                  (set client.resolved_capabilities.document_formatting false)
                  (set client.resolved_capabilities.document_range_formatting false)
                  (ts-utils.setup {:enable_formatting true})
                  (ts-utils.setup_client client))
          :opts {:init_options ts-utils.init_options}})
```

[0]: https://fennel-lang.org/
[1]: https://github.com/Olical/aniseed
