# dotfiles

Personal configuration files, kept in one repo and symlinked into `~/.config`.

| Path | What it is |
| ---- | ---------- |
| `.config/nvim` | Neovim config (lazy.nvim, LSP, treesitter, Telescope, fugitive). The one in daily use. |
| `.config/i3` | i3 window manager config. |
| `.config/yabar` | yabar status bar config. |
| `.config/lazyvim/nvim` | An older LazyVim-based Neovim setup, kept for reference. Not linked by default. |
| `map.sh` | Creates the symlinks into `~/.config`. |
| `requirements.txt` | Extra packages the i3 setup expects (compositor, wallpaper, bar). |

## Install

```sh
git clone git@github.com:fabianAhbeck/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
./map.sh
```

`map.sh` links `.config/nvim` and `.config/i3` into `~/.config`. Move any existing
`~/.config/nvim` or `~/.config/i3` out of the way first, otherwise `ln` nests the
link inside the existing directory. To use the LazyVim setup instead, swap the
commented line in `map.sh`.

## Neovim

Requires Neovim 0.12+. Plugins are managed by [lazy.nvim](https://github.com/folke/lazy.nvim),
which bootstraps itself on first start; versions are pinned in `lazy-lock.json`.

```
.config/nvim
├── init.lua               loads the modules below
└── lua/config
    ├── lazy.lua           lazy.nvim bootstrap, leader keys
    ├── options.lua        editor options, gruvbox + completion menu colours
    ├── keybinds.lua       all keymaps
    ├── lsp-config.lua     language server settings
    └── plugins/           one file per plugin spec
```

### External tools

| Tool | Needed for |
| ---- | ---------- |
| `git`, a C compiler, `curl`, `tar` | lazy.nvim, building treesitter parsers |
| `tree-sitter` CLI | nvim-treesitter (`main` branch) compiles parsers with it |
| `gh` (logged in with `gh auth login`) | `<leader>gr` on GitHub repos |
| A [Nerd Font](https://www.nerdfonts.com/) | icons in the file tree, bufferline, completion and markdown rendering |

Language servers (`lua_ls`, `rust_analyzer`, `gopls`, `terraformls`, `tflint`) are
installed by Mason on first start. Anything else installed through `:Mason` is
enabled automatically. Treesitter parsers for the configured languages are
installed on first start; parsers for other filetypes install when such a file
is first opened.

### Plugins

- **UI:** gruvbox, bufferline, nvim-tree, nvim-web-devicons
- **Editing:** blink.cmp (with friendly-snippets, lspkind), lazydev
- **Code:** nvim-lspconfig, mason + mason-lspconfig, nvim-treesitter
- **Navigation:** Telescope, which-key (popup of available keys after a pause on `<leader>` or any other prefix)
- **Git:** vim-fugitive, vim-rhubarb (`:GBrowse` for GitHub)
- **Markdown:** render-markdown, styled in grayscale with a separator line between table rows

### Keybindings

Leader is `Space`.

**Files and buffers**

| Key | Action |
| --- | ------ |
| `<leader>ff` / `<leader>fg` / `<leader>fb` | Find files / live grep / open buffers (Telescope) |
| `<leader>e` | Toggle file tree |
| `H` / `L` | Previous / next buffer |
| `<leader>bd` | Close buffer |
| `<leader>W` / `<leader>q` | Save / quit |
| `<leader>cc` | Open the Neovim config |

**Windows and terminals**

| Key | Action |
| --- | ------ |
| `<leader>vs` / `<leader>s` | Vertical / horizontal split |
| `<leader>h` `j` `k` `l` | Move between splits |
| `<leader>t` | Toggle floating terminal |
| `<leader>ac` | Toggle a Claude Code pane on the right |
| `Esc` (terminal mode) | Back to normal mode |

**LSP**

| Key | Action |
| --- | ------ |
| `gd` | Go to definition |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename symbol |
| `<leader>lf` | Format buffer |
| `<leader>df` | Show diagnostic under cursor |
| `<C-j>` / `<C-k>` | Scroll the hover popup |

Neovim's built-in defaults also apply: `K` (hover), `grr` (references),
`gri` (implementation), `[d` / `]d` (diagnostics).

**Git**

| Key | Action |
| --- | ------ |
| `<leader>gs` | Status window (`s` stage, `u` unstage, `=` inline diff, `cc` commit, `g?` help) |
| `<leader>gc` / `<leader>ga` | Commit / amend |
| `<leader>gp` / `<leader>gP` | Push / pull with rebase |
| `<leader>gb` | Blame |
| `<leader>gd` | Diff file against the index |
| `<leader>gl` / `<leader>gL` | Log graph / history of current file |
| `<leader>gw` | Stage current file |
| `<leader>gB` | Branch picker (`<CR>` checkout, `<C-a>` create) |
| `<leader>gn` | Create and switch to a new branch |
| `<leader>gr` | Push branch and open a pull request |
| `<leader>go` | Open file or selection on the remote |
| `<leader>gh` / `<leader>gt` | Take ours / theirs in a merge conflict (`:Gvdiffsplit!`) |

`<leader>gr` uses `gh` for GitHub remotes. For Gitea it opens the web compare
page; add the server's hostname to `gitea_hosts` in `keybinds.lua`. It does
nothing on the default branch or on other hosts.

**Other**

| Key | Action |
| --- | ------ |
| `<leader>?` | Show keymaps for the current buffer (which-key) |
| `<leader>mr` | Toggle markdown rendering |
| `<leader>nh` | Clear search highlight |
| `<leader>%` | Source current file |
| `<leader>x` | Run current line / selection as Lua |
