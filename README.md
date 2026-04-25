# dotneovim

jsnuggle's Neovim configuration. Successor to [dotvim](https://github.com/jsnuggle/dotvim).

Modular Lua config built on [lazy.nvim](https://github.com/folke/lazy.nvim) with
LSP, Treesitter, Telescope, and modern plugins for Python, TypeScript/React, and Git.

## Requirements

- Neovim **0.11+** (tested on 0.12.2)
- `git`, `make`, a C compiler (for `telescope-fzf-native`)
- `ripgrep` (for `:Telescope live_grep`)
- `fd` (faster file discovery)
- A Nerd Font in your terminal (for icons)

On macOS:

```sh
brew install neovim ripgrep fd
brew install --cask font-jetbrains-mono-nerd-font
```

## Bootstrap on a new machine

```sh
git clone https://github.com/jsnuggle/dotneovim.git ~/.config/nvim
nvim --headless "+Lazy! sync" +qa
nvim --headless "+MasonToolsInstallSync" +qa   # installs LSPs / formatters
```

Then launch `nvim` and run `:checkhealth` to verify.

## Layout

```
~/.config/nvim/
├── init.lua                # entrypoint: leader, requires modules, bootstraps lazy
├── lua/
│   ├── options.lua         # vim.opt.* — editor settings ported from .vimrc
│   ├── keymaps.lua         # core keymaps (jj→Esc, ;→:, leader macros)
│   ├── autocmds.lua        # auto-mkdir on save, filetype indent, prose wrap
│   └── plugins/
│       ├── ui.lua          # tokyonight, lualine, which-key, indent-blankline, noice
│       ├── editor.lua      # telescope, neo-tree, treesitter, surround, comment, autopairs
│       ├── lsp.lua         # mason, lspconfig, blink.cmp, conform, nvim-lint
│       ├── git.lua         # fugitive, gitsigns, diffview
│       ├── snippets.lua    # luasnip + friendly-snippets
│       └── extras.lua      # undotree, yanky, harpoon, trouble, spectre, aerial, snacks
├── lazy-lock.json          # plugin version lockfile (commit this!)
├── .stylua.toml            # lua formatter config
└── README.md
```

## Keymaps cheat sheet

Leader is `,`.

### Files / search (Telescope)
| keys | action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fr` | Recent (MRU) |
| `<leader>fs` / `<leader>fS` | LSP symbols (file / workspace) |
| `<leader>fd` | Diagnostics |
| `<leader>fw` | Find word under cursor |
| `<leader>a`  | Ack-style grep prompt |

### File tree
| keys | action |
|---|---|
| `<leader>n` | Toggle neo-tree |
| `<leader>N` | Reveal current file |

### LSP
| keys | action |
|---|---|
| `gd` / `gD` / `gr` / `gI` / `gy` | Definition / Declaration / References / Implementation / Type |
| `K` | Hover docs |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>cf` | Format buffer |
| `<leader>ch` | Toggle inlay hints |
| `[d` / `]d` | Prev / next diagnostic |

### Git
| keys | action |
|---|---|
| `<leader>gs` / `<leader>gd` / `<leader>gb` | Status / Diff / Blame (fugitive) |
| `<leader>gv` / `<leader>gh` | Diffview / File history |
| `]c` / `[c` | Next / prev hunk |
| `<leader>hs` / `<leader>hr` / `<leader>hp` | Stage / Reset / Preview hunk |

### Bookmarks (Harpoon)
| keys | action |
|---|---|
| `<leader>ka` | Add file |
| `<leader>kl` | List menu |
| `<leader>k1`..`<leader>k4` | Jump to pinned file 1–4 |

### Misc (carried over from vim)
| keys | action |
|---|---|
| `jj` | Exit insert mode |
| `;` | Enter command mode |
| `Y` | Yank to end of line |
| `<leader><space>` | Clear search highlight |
| `<leader>W` | Strip trailing whitespace |
| `<leader>l` | Toggle invisible chars |
| `<leader>vv` | Edit init.lua |
| `<leader>u` | Toggle undotree |
| `<leader>o` | Toggle outline (aerial) |
| `<leader>sr` | Project-wide search & replace (Spectre) |
| `<leader>xx` | Diagnostics list (Trouble) |
| `\` | Toggle quickfix |

## Commands

- `:Lazy` — plugin manager UI (install / update / clean)
- `:Mason` — LSP / formatter / linter installer
- `:checkhealth` — diagnose config
- `:FormatDisable` / `:FormatEnable` — toggle format-on-save (use `:FormatDisable!` for buffer-only)
