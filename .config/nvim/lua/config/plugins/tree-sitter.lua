local parsers = {
  "lua", "vim", "vimdoc", "rust", "go", "gomod", "gowork",
  "terraform", "hcl", "bash", "json", "yaml", "markdown", "markdown_inline",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup()
      ts.install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if not lang then return end

          -- Install missing parsers on demand (replaces `auto_install`)
          if vim.list_contains(ts.get_available(), lang)
            and not vim.list_contains(ts.get_installed(), lang) then
            ts.install(lang)
            return
          end

          if pcall(vim.treesitter.start, args.buf, lang) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
