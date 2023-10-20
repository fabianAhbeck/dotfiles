local keymap = vim.api.nvim_set_keymap
local term_opts = { silent = true }
local opts = { noremap = true, silent = true }

keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

keymap("i", "jj", "<ESC>", opts)

-- Movment keys
keymap("n", "<leader>h", "<C-w>h", opts)
keymap("n", "<leader>l", "<C-w>l", opts)
keymap("n", "<leader>j", "<C-w>j", opts)
keymap("n", "<leader>k", "<C-w>k", opts)

keymap("n", "<leader>bd", ":Bdelete<CR>", opts)

-- Split
keymap("n", "<leader>vs", ":vsplit<CR>", opts)

-- Resize
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Edit Config
keymap("n", "<leader>nc", ":e $HOME/.config/nvim/lua/user/<CR>", opts)

-- Buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- No Highlight
keymap("n", "<leader>nh", ":nohlsearch<CR>", opts)

-- Indent
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Don't overwrite buffer on paste
keymap("v", "p", '"_dP', opts)

-- Terminal 
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)
keymap("n", "<leader>t", ":ToggleTerm<CR>", opts)

-- Telescope
keymap("n", "<leader>ff", "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", opts)
keymap("n", "<leader>fb", "<cmd>lua require'telescope.builtin'.buffers(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", opts)
keymap("n", "<leader>fg", "<cmd>lua require'telescope.builtin'.live_grep(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", opts)

-- Nvim Tree
keymap("n", "<leader>ne", ":NvimTreeToggle<cr>", opts)

-- Vimspector
keymap("n", "<leader>dd", ":call vimspector#Launch()<cr>", opts)
keymap("n", "<leader>de", ":call vimspector#Reset()<cr>", opts)
keymap("n", "<leader>c", ":call vimspector#Continue()<cr>", opts)

keymap("n", "<leader>dt", ":call vimspector#ToggleBreakpoint()<cr>", opts)
keymap("n", "<leader>dT", ":call vimspector#ClearBreakpoints()<cr>", opts)

keymap("n", "<leader>s", ":call vimspector#StepInto()<cr>", opts)
keymap("n", "<leader>o", ":call vimspector#StepOver()<cr>", opts)
keymap("n", "<leader>dw", ":VimspectorWatch ", opts)
keymap("n", "<leader>dp", "<Plug>VimspectorBalloonEval", opts)

