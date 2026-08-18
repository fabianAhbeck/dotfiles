return {
  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.7',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      keymap = {
              preset = 'default',

              ['<C-k>']  = { 'select_prev', 'fallback' },
              ['<C-j>']  = { 'select_next', 'fallback' },
              ['<Tab>']  = { 'select_and_accept', 'fallback'},
              ['<CR>']  = { 'accept', 'fallback'},
              ['<ESC>']  = { 'cancel', 'fallback'},


      },

      appearance = {
        nerd_font_variant = 'mono'
      },

      -- (Default) Only show the documentation popup when manually triggered
      --completion = { documentation = { auto_show = false } },
      completion = {
        ghost_text = { enabled = true },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 250,
          window = { border = 'rounded' },
        },
        list = {
          selection = { preselect = false, auto_insert = false },
        },
        menu = {
          border = 'rounded',
          draw = {
            -- Left column: icon + label + inline description.
            -- Right column: item kind (Function, Variable, ...) + source.
            columns = {
              { 'kind_icon', 'label', 'label_description', gap = 1 },
              { 'kind', 'source_name', gap = 1 },
            },
            -- Syntax-highlight the completion labels with treesitter (LSP items).
            treesitter = { 'lsp' },
            components = {
              kind_icon = {
                text = function(ctx)
                  local icon = ctx.kind_icon
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                      local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                      if dev_icon then
                          icon = dev_icon
                      end
                  else
                      icon = require("lspkind").symbolic(ctx.kind, {
                          mode = "symbol",
                      })
                  end
  
                  return icon .. ctx.icon_gap
                end,
  
                -- Optionally, use the highlight groups from nvim-web-devicons
                -- You can also add the same function for `kind.highlight` if you want to
                -- keep the highlight groups in sync with the icons.
                highlight = function(ctx)
                  local hl = ctx.kind_hl
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      hl = dev_hl
                    end
                  end
                  return hl
                end,
              }
            }
          }
        }
      },
      sources = {
        default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
          -- Completion for the Neovim Lua API and required plugin modules.
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100, -- rank lazydev items above LSP
          },
        },
      },

      fuzzy = { implementation = "prefer_rust" },
    },
    opts_extend = { "sources.default" },
  },
  {
    "onsails/lspkind.nvim",
    opts = {
          mode = 'symbol_text',
          preset = 'codicons',
          symbol_map = {
            Text = "󰉿",
            Method = "󰆧",
            Function = "󰊕",
            Constructor = "",
            Field = "󰜢",
            Variable = "󰀫",
            Class = "󰠱",
            Interface = "",
            Module = "",
            Property = "󰜢",
            Unit = "󰑭",
            Value = "󰎠",
            Enum = "",
            Keyword = "󰌋",
            Snippet = "",
            Color = "󰏘",
            File = "󰈙",
            Reference = "󰈇",
            Folder = "󰉋",
            EnumMember = "",
            Constant = "󰏿",
            Struct = "󰙅",
            Event = "",
            Operator = "󰆕",
            TypeParameter = "",
          },
      }
  }
}
