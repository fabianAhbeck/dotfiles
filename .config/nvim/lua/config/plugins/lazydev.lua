return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load for lua files
    opts = {
      library = {
        -- Load luvit (vim.uv) type definitions when referenced.
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
}
