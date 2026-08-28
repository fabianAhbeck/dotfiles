local kmap = vim.keymap.set

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
-- Note: Neovim 0.11 provides defaults: grn (rename), gra (code action),
-- grr (references), gri (implementation), K (hover), [d/]d (diagnostics).
kmap("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
kmap("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
kmap("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
kmap("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, { desc = "Format buffer" })
kmap("n", "<leader>df", vim.diagnostic.open_float, { desc = "Show diagnostic" })

-- Scroll the LSP hover / preview popup (if one is open) with Ctrl-j / Ctrl-k.
-- When no popup is open, fall back to the key's default behaviour.
local function scroll_float(motion, fallback)
  return function()
    local win = vim.b.lsp_floating_preview
    if win and vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_call(win, function()
        vim.cmd("normal! " .. motion)
      end)
    else
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes(fallback, true, false, true), "n", false)
    end
  end
end
kmap("n", "<C-j>", scroll_float("3j", "<C-j>"), { desc = "Scroll hover down" })
kmap("n", "<C-k>", scroll_float("3k", "<C-k>"), { desc = "Scroll hover up" })

-- Terminal: toggle a centered floating popup shell (reuses the session).
local fterm = { buf = nil, win = nil }
local function float_term()
  if fterm.win and vim.api.nvim_win_is_valid(fterm.win) then
    vim.api.nvim_win_hide(fterm.win)
    fterm.win = nil
    return
  end
  local width = math.floor(vim.o.columns * 0.85)
  local height = math.floor(vim.o.lines * 0.8)
  if not (fterm.buf and vim.api.nvim_buf_is_valid(fterm.buf)) then
    fterm.buf = vim.api.nvim_create_buf(false, true)
  end
  fterm.win = vim.api.nvim_open_win(fterm.buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " terminal ",
    title_pos = "center",
  })
  if vim.bo[fterm.buf].buftype ~= "terminal" then
    vim.fn.jobstart({ vim.o.shell }, { term = true })
  end
  vim.cmd("startinsert")
end
kmap("n", "<leader>t", float_term, { desc = "Toggle floating terminal" })
kmap("t",  '<Esc>', [[<C-\><C-n>]], {noremap = true})

-- Claude Code: toggle a right-hand split running `claude` in the project root.
-- Pressing again hides the pane but keeps the session alive; pressing once
-- more re-opens the same session.
local claude = { buf = nil, win = nil }
local function claude_toggle()
  if claude.win and vim.api.nvim_win_is_valid(claude.win) then
    vim.api.nvim_win_hide(claude.win)
    claude.win = nil
    return
  end
  vim.cmd("botright vsplit")
  claude.win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_width(claude.win, math.floor(vim.o.columns * 0.4))
  if claude.buf and vim.api.nvim_buf_is_valid(claude.buf) then
    vim.api.nvim_win_set_buf(claude.win, claude.buf)
  else
    vim.cmd("terminal claude")
    claude.buf = vim.api.nvim_get_current_buf()
    -- Claude Code owns <Esc> (cancel a turn, double-tap to clear the input), so
    -- let it through here instead of using it to leave terminal mode. Use the
    -- built-in <C-\><C-n> to get to normal mode in this buffer.
    vim.keymap.set("t", "<Esc>", "<Esc>", { buffer = claude.buf })
  end
  vim.cmd("startinsert")
end
kmap("n", "<leader>ac", claude_toggle, { desc = "Toggle Claude Code" })
