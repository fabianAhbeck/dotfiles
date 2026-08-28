-- nvim-treesitter `main` branch: the plugin only installs parsers and ships
-- queries. Highlighting/indentation are Neovim features we opt into per buffer,
-- so there is no `configs.setup` and no `auto_install` any more.
local ensure_installed = {
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
      ts.install(ensure_installed)

      local function enable(buf, lang)
        if not vim.api.nvim_buf_is_valid(buf) then
          return
        end
        if not pcall(vim.treesitter.start, buf, lang) then
          return
        end
        -- Only take over indenting where there is an indents query to drive it,
        -- otherwise `indentexpr` would flatten the buffer to column 0.
        if vim.treesitter.query.get(lang, "indents") then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end

      vim.api.nvim_create_autocmd("FileType", {
        desc = "Enable treesitter highlighting and indentation",
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
          if not lang then
            return
          end

          if vim.list_contains(ts.get_installed(), lang) then
            enable(args.buf, lang)
          elseif vim.list_contains(ts.get_available(), lang) then
            -- Stand-in for master's `auto_install`.
            ts.install({ lang }):await(function()
              vim.schedule(function()
                enable(args.buf, lang)
              end)
            end)
          end
        end,
      })
    end,
  },
}
