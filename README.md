# 💤 LazyVim

A customized [LazyVim](https://github.com/LazyVim/LazyVim) config with Go, TypeScript, and Python LSP support, IntelliJ-style panels, and a TokyoNight colorscheme.

Refer to the [LazyVim documentation](https://lazyvim.github.io/installation) to get started.

---

## Keybindings

### Buffers
| Key | Action |
|-----|--------|
| `tk` | Last buffer |
| `tj` | First buffer |
| `th` | Previous buffer |
| `tl` | Next buffer |
| `td` | Delete buffer |

### Files
| Key | Action |
|-----|--------|
| `WW` | Force write |
| `QQ` | Force quit |
| `E` | Jump to end of line |
| `B` | Jump to start of line |
| `TT` | Toggle transparent background |
| `st` | Search TODOs (Telescope) |
| `ss` | Clear search highlight |
| `jk` | Exit insert mode |

### Splits
| Key | Action |
|-----|--------|
| `<C-W>,` | Vertical resize -10 |
| `<C-W>.` | Vertical resize +10 |

### Terminal
| Key | Action |
|-----|--------|
| `<leader>th` | Open horizontal terminal split |
| `<leader>tv` | Open vertical terminal split |

### Git
| Key | Action |
|-----|--------|
| `<leader>gg` | Open Neogit panel (git status) |
| `<leader>gc` | Open Neogit commit |
| `<leader>gP` | Git push |
| `<leader>gp` | Git pull |
| `<leader>gD` | Open Diffview (repo diff) |
| `<leader>gh` | File git history |

### Panels (Edgy — IntelliJ-style tool windows)
| Key | Action |
|-----|--------|
| `<leader>e` | Toggle file explorer (left) |
| `<leader>gg` | Toggle git panel (left) |
| `<leader>cs` | Toggle code outline / aerial (right) |
| `<leader>ue` | Toggle all sidebars |
| `<leader>uE` | Pick between open panels |

### Go
| Key | Action |
|-----|--------|
| `<leader>ee` | Insert `if err != nil` block |

---

## Languages

Configured via LazyVim extras + `lua/plugins/lang.lua`:

| Language | LSP | Formatter | Linter |
|----------|-----|-----------|--------|
| Go | gopls | gofumpt + goimports | staticcheck |
| TypeScript / JS | vtsls | prettier | eslint |
| Python | pyright | ruff | ruff |
| SQL | — | sql-formatter | — |
| Tailwind | tailwindcss | — | — |

---

## Plugins

Key additions on top of LazyVim defaults:

| Plugin | Purpose |
|--------|---------|
| `neogit` + `diffview` | Git commit panel + side-by-side diffs |
| `edgy.nvim` | Persistent sidebar panels |
| `barbecue.nvim` | Breadcrumb winbar (file › class › method) |
| `aerial.nvim` | Code outline / symbol tree |
| `gitsigns.nvim` | Inline git blame + gutter markers |
| `tokyonight.nvim` | Colorscheme (night variant) |
