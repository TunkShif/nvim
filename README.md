# Neovim Config

A minimal, modular Neovim configuration using Neovim native package manager.

# Plugins

<details>
  <summary>plugin list</summary>

| Plugin                                                                                | Description                          |
| :------------------------------------------------------------------------------------ | :----------------------------------- |
| [catppuccin/nvim](https://github.com/catppuccin/nvim)                                 | colorscheme                          |
| [nvim-mini/mini.nvim](https://github.com/nvim-mini/mini.nvim)                         | modular plugin suite                 |
| [folke/flash.nvim](https://github.com/folke/flash.nvim)                               | enhanced navigation                  |
| [folke/snacks.nvim](https://github.com/folke/snacks.nvim)                             | floating terminal and LazyGit integration |
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

The following external tools provide optional TUI commands:

- [`lazygit`](https://github.com/jesseduffield/lazygit) for `:LazyGit`
- [`leaf`](https://github.com/RivoLink/leaf) for `:Leaf` and `:Leaf!`

# Keymapping

Leader key: `SPC` | Local leader: `\`

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
| `gl`         | Flash jump                |
| `gL`         | Select a Tree-sitter node |
| `<C-]>`      | Go to definition (built-in LSP `tagfunc`) |
| `<C-w>]`     | Go to definition in a split |
| `<C-t>`      | Jump back (pop tag stack) |
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

## Git (mini.git + mini.diff)

| Mapping      | Description                                                        |
| :----------- | :----------------------------------------------------------------- |
| `<leader>gb` | Blame current line in a popup (works with unsaved edits)           |
| `<leader>gl` | Show history of current line / visual range (`git log -L`); on a commit hash shows the commit, on a diff line shows the file at that commit |
| `<leader>gd` | Diff current file against index (`:Git diff -- %`)                 |
| `<leader>go` | Toggle mini.diff inline overlay                                    |

Inside the blame popup (press `<leader>gb` again to focus it):

| Key    | Description                                    |
| :----- | :--------------------------------------------- |
| `<CR>` | Show the commit (`git show --stat --patch`)    |
| `<BS>` | Show the parent of the blamed commit           |
| `q`    | Close the popup                                |

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
| mini.git         | Git integration (`:Git` command, history) |
| mini.diff        | Diff hunks in sign column and overlay |

## Other

| Mapping       | Description            |
| :------------ | :--------------------- |
| `:Format`         | Format buffer (or visual range) |
| `:Autoformat [enable\|disable\|toggle]` | Control format-on-save (default: toggle) |
| `<leader>uf`      | Toggle format-on-save |
| `:LazyGit`        | Open LazyGit in a floating terminal |
| `:Leaf`           | Open Leaf in a floating terminal |
| `:Leaf!`          | Open the current saved file in Leaf |

# Structure

```
init.lua                 -- leader, options, plugin specs
lua/plugins/
  editor.lua             -- editor UI, navigation, and terminal tools
  refer.lua              -- fuzzy picker and diagnostics
  coding.lua             -- LSP, treesitter, completion
  formatting.lua         -- conform.nvim setup
  git.lua                -- git blame popup and git keymaps
lsp/
  ameba-ls.lua           -- Crystal linter config
  liger.lua              -- custom LSP config
```
