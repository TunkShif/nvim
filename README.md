# Neovim Config

A minimal, modular Neovim configuration using Neovim native package manager.

# Plugins

<details>
  <summary>plugin list</summary>

| Plugin                                                                                | Description                          |
| :------------------------------------------------------------------------------------ | :----------------------------------- |
| [catppuccin/nvim](https://github.com/catppuccin/nvim)                                 | colorscheme                          |
| [nvim-mini/mini.nvim](https://github.com/nvim-mini/mini.nvim)                         | modular plugin suite                 |
| [juniorsundar/refer.nvim](https://github.com/juniorsundar/refer.nvim)                 | minimal fuzzy picker                 |
| [folke/which-key.nvim](https://github.com/folke/which-key.nvim)                       | key binding hints                    |
| [mason-org/mason.nvim](https://github.com/mason-org/mason.nvim)                       | LSP/tool installer                  |
| [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)                     | LSP configuration                   |
| [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | syntax highlighting and code insight |
| [nvim-treesitter/nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) | custom text objects |
| [saghen/blink.cmp](https://github.com/saghen/blink.cmp)                               | completion framework                |
| [stevearc/conform.nvim](https://github.com/stevearc/conform.nvim)                     | formatting                           |

</details>

# Installation

```sh
# back up existing config if needed
cp -r ~/.config/nvim ~/.config/nvim.bak
git clone https://github.com/TunkShif/neovim ~/.config/nvim
```

Language servers are managed via Mason. Run `:Mason` to install missing servers.

# Keymapping

Leader key: `SPC` | Local leader: `,`

## Finder (refer.nvim)

| Mapping      | Description               |
| :----------- | :------------------------ |
| `<leader>ff` | Find files                |
| `<leader>fF` | File explorer (FindFile)  |
| `<leader>fg` | Grep                      |
| `<leader>fb` | Buffers                   |
| `<leader>fS` | LSP document symbols      |
| `<leader>fx` | Buffer diagnostics        |
| `<leader>fX` | Workspace diagnostics     |

## Navigation

| Mapping      | Description            |
| :----------- | :--------------------- |
| `<leader>e`  | File explorer (mini.files) |
| `grd`        | Go to definition       |
| `grD`        | Go to declaration      |
| `gri`        | Go to implementation   |
| `grr`        | Go to references       |
| `gra`        | Code action            |
| `grn`        | Rename symbol          |
| `K`          | Hover documentation    |
| `<C-w>d`     | Show diagnostic detail |
| `[d`         | Previous diagnostic    |
| `]d`         | Next diagnostic        |

## Mini.nvim Modules

| Module           | Description                    |
| :--------------- | :----------------------------- |
| mini.basics      | Default settings               |
| mini.icons       | File type icons                |
| mini.surround    | Surround operator              |
| mini.cursorword  | Highlight word under cursor    |
| mini.pairs       | Auto-close brackets            |
| mini.files       | File explorer                  |
| mini.ai          | Text objects (function, class) |

## Other

| Mapping       | Description            |
| :------------ | :--------------------- |
| `:Format enable`  | Enable autoformat   |
| `:Format disable` | Disable autoformat  |

# Structure

```
init.lua                 -- leader, options, plugin specs
lua/plugins/
  mini.lua               -- mini.nvim modules and config
  refer.lua              -- fuzzy picker and diagnostics
  coding.lua             -- LSP, treesitter, completion
  formatting.lua         -- conform.nvim setup
lsp/
  ameba-ls.lua           -- Crystal linter config
  liger.lua              -- custom LSP config
```
