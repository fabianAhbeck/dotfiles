return {
  {
     "nvim-treesitter/nvim-treesitter",
     branch = 'master',
     lazy = false,
     build = ":TSUpdate",
     config = function()
       require("nvim-treesitter.configs").setup({
         ensure_installed = {
           "lua", "vim", "vimdoc", "rust", "go", "gomod", "gowork",
           "terraform", "hcl", "bash", "json", "yaml", "markdown",
         },
         auto_install = true,
         highlight = { enable = true },
         indent = { enable = true },
       })
     end,
  }
}
