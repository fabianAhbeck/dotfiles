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

-- Git (fugitive)
kmap("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Git status" })
kmap("n", "<leader>gc", "<cmd>Git commit<CR>", { desc = "Git commit" })
kmap("n", "<leader>ga", "<cmd>Git commit --amend<CR>", { desc = "Git commit --amend" })
kmap("n", "<leader>gp", "<cmd>Git push<CR>", { desc = "Git push" })
kmap("n", "<leader>gP", "<cmd>Git pull --rebase<CR>", { desc = "Git pull --rebase" })
kmap("n", "<leader>gb", "<cmd>Git blame<CR>", { desc = "Git blame" })
kmap("n", "<leader>gd", "<cmd>Gvdiffsplit<CR>", { desc = "Diff file against index" })
kmap("n", "<leader>gl", "<cmd>Git log --oneline --graph --decorate<CR>", { desc = "Git log" })
kmap("n", "<leader>gL", "<cmd>0Gclog<CR>", { desc = "History of current file" })
kmap("n", "<leader>gw", "<cmd>Gwrite<CR>", { desc = "Stage current file" })
kmap("n", "<leader>gB", "<cmd>Telescope git_branches<CR>", { desc = "Git branches" })
kmap("n", "<leader>gn", function()
  vim.ui.input({ prompt = "New branch: " }, function(name)
    if name and name ~= "" then
      vim.cmd("Git switch -c " .. vim.fn.fnameescape(name))
    end
  end)
end, { desc = "Create and switch to new branch" })

-- Push the current branch and open a PR form in the browser.
-- GitHub goes through `gh` (prefilled from commits); hosts listed in
-- `gitea_hosts` open Gitea's compare page. Any other host is left untouched.
local gitea_hosts = { "gitea.leafer.site" }

-- Split a remote URL (scp-style, ssh:// or https://) into host and repo path.
local function parse_remote(url)
  local host, path = url:match("^%a[%w+.-]*://([^/]+)/(.+)$")
  if host then
    host = host:gsub("^.*@", ""):gsub(":%d+$", "")
  else
    host, path = url:match("^[^@]+@([^:]+):(.+)$")
  end
  if host then
    return host, (path:gsub("%.git$", ""))
  end
end

local function open_pr()
  local cwd = vim.fn.FugitiveWorkTree()
  if cwd == "" then
    vim.notify("Not in a git repository", vim.log.levels.WARN)
    return
  end
  local function git(args)
    local out = vim.system(vim.list_extend({ "git" }, args), { cwd = cwd, text = true }):wait()
    return out.code == 0 and vim.trim(out.stdout) or nil
  end

  local remote = git({ "remote", "get-url", "origin" })
  if not remote then
    vim.notify("No 'origin' remote", vim.log.levels.WARN)
    return
  end
  local host, repo = parse_remote(remote)
  local is_github = host == "github.com"
  local is_gitea = vim.list_contains(gitea_hosts, host)
  if not (is_github or is_gitea) then
    vim.notify("PR shortcut doesn't support this remote: " .. remote, vim.log.levels.WARN)
    return
  end

  local branch = git({ "branch", "--show-current" })
  local default = (git({ "rev-parse", "--abbrev-ref", "origin/HEAD" }) or ""):gsub("^origin/", "")
  if not branch or branch == "" then
    vim.notify("Detached HEAD, switch to a branch first", vim.log.levels.WARN)
    return
  end
  if branch == default or (default == "" and (branch == "main" or branch == "master")) then
    vim.notify("On the default branch (" .. branch .. "), create a feature branch first", vim.log.levels.WARN)
    return
  end

  vim.notify("Pushing " .. branch .. "...")
  vim.system({ "git", "push", "-u", "origin", "HEAD" }, { cwd = cwd, text = true }, function(push)
    if push.code ~= 0 then
      vim.schedule(function() vim.notify("git push failed:\n" .. push.stderr, vim.log.levels.ERROR) end)
      return
    end
    if is_gitea then
      local base = default ~= "" and default or "main"
      vim.schedule(function()
        vim.ui.open(("https://%s/%s/compare/%s...%s"):format(host, repo, base, branch))
      end)
      return
    end
    vim.system({ "gh", "pr", "create", "--fill", "--web" }, { cwd = cwd, text = true }, function(pr)
      if pr.code ~= 0 then
        vim.schedule(function() vim.notify("gh pr create failed:\n" .. pr.stderr, vim.log.levels.ERROR) end)
      end
    end)
  end)
end
kmap("n", "<leader>gr", open_pr, { desc = "Push and open PR (GitHub/Gitea)" })
kmap({ "n", "v" }, "<leader>go", ":GBrowse<CR>", { desc = "Open file/selection on remote" })
-- Merge conflicts (inside :Gvdiffsplit!): take the left (ours) or right (theirs) side
kmap("n", "<leader>gh", "<cmd>diffget //2<CR>", { desc = "Take ours" })
kmap("n", "<leader>gt", "<cmd>diffget //3<CR>", { desc = "Take theirs" })

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
  end
  vim.cmd("startinsert")
end
kmap("n", "<leader>ac", claude_toggle, { desc = "Toggle Claude Code" })
