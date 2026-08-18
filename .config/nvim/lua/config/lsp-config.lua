vim.lsp.config('*', {
  root_markers = { '.git' },
})

local servers = {
  rust_analyzer = {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_markers = { 'Cargo.toml', '.git' },
    single_file_support = true,
    settings = {
      ['rust-analyzer'] = {
        diagnostics = {
          enable = false,
        },
      },
    },
    before_init = function(init_params, config)
      -- See https://github.com/rust-lang/rust-analyzer/blob/eb5da56d839ae0a9e9f50774fa3eb78eb0964550/docs/dev/lsp-extensions.md?plain=1#L26
      if config.settings and config.settings['rust-analyzer'] then
        init_params.initializationOptions = config.settings['rust-analyzer']
      end
    end,
  },
  lua_ls = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'vim' },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files and plugins
          library = { vim.env.VIMRUNTIME },
          checkThirdParty = false,
        },
      },
    },
  },
  gopls = {
    cmd = { 'gopls' },
    filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
    root_markers = { 'go.work', 'go.mod', '.git' },
    settings = {
      gopls = {
        completeUnimported = true,
        usePlaceholders = true,
        analyses = {
          unusedparams = true,
        },
      },
    },
  },
  terraformls = {
    cmd = { 'terraform-ls', 'serve' },
    filetypes = { 'terraform', 'terraform-vars' },
    root_markers = { '.terraform', '.git' },
  },
  tflint = {
    cmd = { 'tflint', '--langserver' },
    filetypes = { 'terraform' },
    root_markers = { '.tflint.hcl', '.terraform', '.git' },
  },
}

for name, config in pairs(servers) do
  vim.lsp.config[name] = config
  vim.lsp.enable(name)
end

-- Nudge: when opening a filetype that has no LSP client attached, suggest
-- installing one via :Mason. Any server installed through Mason is enabled
-- automatically (mason-lspconfig `automatic_enable`), so no config edit needed.
local notified = {}
local ignore = {
  [''] = true, ['text'] = true, ['markdown'] = true, ['gitcommit'] = true,
  ['help'] = true, ['man'] = true, ['qf'] = true, ['NvimTree'] = true,
  ['lazy'] = true, ['mason'] = true, ['checkhealth'] = true, ['TelescopePrompt'] = true,
}

vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    if ignore[ft] or notified[ft] then
      return
    end
    -- Wait a beat so any matching server has a chance to attach first.
    vim.defer_fn(function()
      if not vim.api.nvim_buf_is_valid(args.buf) then
        return
      end
      if vim.bo[args.buf].buftype ~= '' then
        return
      end
      if #vim.lsp.get_clients({ bufnr = args.buf }) == 0 then
        notified[ft] = true
        vim.notify(
          ("No LSP for '%s'. Run :Mason to install one (auto-enables, no restart)."):format(ft),
          vim.log.levels.INFO,
          { title = 'LSP' }
        )
      end
    end, 750)
  end,
})
