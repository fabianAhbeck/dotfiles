local keymap = vim.api.nvim_set_keymap
local term_opts = { silent = true }
local opts = { noremap = true, silent = true }

keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

keymap("i", "jj", "<ESC>", opts)

keymap("n", "<leader>h", "<C-w>h", opts)
keymap("n", "<leader>l", "<C-w>l", opts)
keymap("n", "<leader>j", "<C-w>j", opts)
keymap("n", "<leader>k", "<C-w>k", opts)

keymap("n", "<leader>bd", ":bdelete<CR>", opts)

keymap("n", "<leader>vs", ":vsplit<CR>", opts)
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

keymap("n", "<leader>c", ":e $HOME/.config/nvim/init.lua<CR>", opts)

keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
keymap("n", "<leader>nh", ":nohlsearch<CR>", opts)

-- indent
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- don't overwrite buffer on paste
keymap("v", "p", '"_dP', opts)

-- terminal --
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- telescope
keymap("n", "<leader>ff", "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", opts)
keymap("n", "<leader>fb", "<cmd>lua require'telescope.builtin'.buffers(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", opts)
keymap("n", "fg", "<cmd>Telescope live_grep<cr>", opts)
