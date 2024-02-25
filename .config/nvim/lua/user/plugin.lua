local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
		PACKER_BOOTSTRAP = fn.system {
				"git",
				"clone",
				"--depth",
				"1",
				"https://github.com/wbthomason/packer.nvim",
				install_path,
		}
		print "Installing packer close and reopen Neovim..."
		vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
augroup packer_user_config
autocmd!
autocmd BufWritePost plugin.lua source <afile> | PackerSync
augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
		return
end

-- Have packer use a popup window
packer.init {
		display = {
				open_fn = function()
						return require("packer.util").float { border = "rounded" }
				end,
		},
}

-- Install your plugins here
return packer.startup(function(use)
		-- My plugins here
		use "wbthomason/packer.nvim" -- Have packer manage itself
		use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
		use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins
		-- use "ellisonleao/gruvbox.nvim"
    use "morhetz/gruvbox"
		use "williamboman/mason.nvim"
    use "tpope/vim-fugitive"
    use "moll/vim-bbye"
    use "akinsho/toggleterm.nvim"
    use "ahmedkhalf/project.nvim"
    use "lewis6991/impatient.nvim"
    use "puremourning/vimspector"
    use "github/copilot.vim"

		-- cmp plugins
		use "hrsh7th/nvim-cmp" -- The completion plugin
		use "hrsh7th/cmp-buffer" -- buffer completions
		use "hrsh7th/cmp-path" -- path completions
		use "hrsh7th/cmp-cmdline" -- cmdline completions
		use "hrsh7th/cmp-nvim-lsp" -- The completion plugin
		use "saadparwaiz1/cmp_luasnip" -- snippet completions

		-- snippets
		use "L3MON4D3/LuaSnip" --snippet engine
		use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

		-- LSP
		use "neovim/nvim-lspconfig" -- enable LSP
		use "jose-elias-alvarez/null-ls.nvim"
    use "williamboman/nvim-lsp-installer"

    -- CoPilot
    use "https://github.com/github/copilot.vim.git"

		use {
				'nvim-telescope/telescope.nvim', tag = '0.1.0',
				-- or                            , branch = '0.1.x',
				requires = { {'nvim-lua/plenary.nvim'} }
		}

		use {
				"nvim-treesitter/nvim-treesitter",
				run = ":TSUpdate",
		}

		use {
				'lewis6991/gitsigns.nvim',
		}

		use {
				'kyazdani42/nvim-tree.lua',
				requires = {
						'kyazdani42/nvim-web-devicons', -- optional, for file icons
				},
		}

    use {
      'akinsho/bufferline.nvim',
      tag = "v2.*",
      requires = 'kyazdani42/nvim-web-devicons'
    }

    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    use {
      'mfussenegger/nvim-dap',
      requires = {
        "Pocco81/DAPInstall.nvim",
        "theHamsta/nvim-dap-virtual-text",
        "rcarriga/nvim-dap-ui",
        "mfussenegger/nvim-dap-python",
        "nvim-telescope/telescope-dap.nvim",
        { "jbyuki/one-small-step-for-vimkind", module = "osv" },
      },
    }
--    -- Vimspector
--    use {
--      "puremourning/vimspector",
--      cmd = { "VimspectorInstall", "VimspectorUpdate" },
--      fn = { "vimspector#Launch()", "vimspector#ToggleBreakpoint", "vimspector#Continue" },
--      config = function()
--        require("user.vimspector").setup()
--      end,
--    }

    use {
    "lewis6991/hover.nvim",
    config = function()
        require("hover").setup {
            init = function()
                -- Require providers
                require("hover.providers.lsp")
                -- require('hover.providers.gh')
                -- require('hover.providers.man')
                -- require('hover.providers.dictionary')
            end,
            preview_opts = {
                border = nil
            },
            title = true
        }

        -- Setup keymaps
        vim.keymap.set("n", "K", require("hover").hover, {desc = "hover.nvim"})
        vim.keymap.set("n", "gK", require("hover").hover_select, {desc = "hover.nvim (select)"})
    end
  }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
		if PACKER_BOOTSTRAP then
				require("packer").sync()
		end
end)
