local kmap = vim.keymap.set
vim.g.mapleader = " "

-- Run lua commands
kmap("n", "<leader>%", "<cmd>source %<CR>")
kmap("n", "<leader>x", ":.lua<CR>")
kmap("v", "<leader>x", ":lua<CR>")

-- Edit Config
kmap("n", "<leader>cc", ":e ~/.config/nvim/init.lua<CR>")

-- Telescope
kmap("n", "<leader>ff", ":Telescope find_files<CR>")
kmap("n", "<leader>fg", ":Telescope live_grep<CR>")
kmap("n", "<leader>fb", ":Telescope buffers<CR>")

-- Pane management
kmap("n", "<leader>vs", ":vsplit<CR>")
kmap("n", "<leader>s", ":split<CR>")
kmap("n", "<leader>h", "<C-w>h")
kmap("n", "<leader>j", "<C-w>j")
kmap("n", "<leader>k", "<C-w>k")
kmap("n", "<leader>l", "<C-w>l")
kmap("n", "<leader>q", ":q<CR>")
kmap("n", "<leader>W", ":w<CR>")

-- Buffer Management
kmap("n", "H", ":bprevious<CR>")
kmap("n", "L", ":bnext<CR>")
kmap("n", "<leader>bd", ":bdelete<CR>")

-- Nvim-tree
kmap("n", "<leader>e", ":NvimTreeToggle<CR>")

-- Search
kmap("n", "<leader>nh", ":nohlsearch<CR>")

-- LSP

-- Terminal
kmap("n", "<leader>t", ":term<CR>A")
kmap("t",  '<Esc>', [[<C-\><C-n>]], {noremap = true})
