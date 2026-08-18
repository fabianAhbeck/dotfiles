local options = {
	undofile = true,
	number = true,
	relativenumber = true,
	expandtab = true,
	tabstop = 4,
	shiftwidth = 4,
	softtabstop = 4,
	wrap = false,
	termguicolors = true,
	signcolumn = "yes",
	ignorecase = true,
	smartcase = true,
	scrolloff = 8,
	winborder = "rounded", -- default rounded border for floats (LSP hover, etc.)
}


for k, v in pairs(options) do
	vim.opt[k] = v
end

-- Color the blink.cmp completion menu to match the gruvbox palette.
-- Registered as a ColorScheme autocmd so it re-applies if the theme reloads.
local function blink_highlights()
	local hl = vim.api.nvim_set_hl
	local bg = "#32302f" -- gruvbox bg0_soft, slightly lifted from the editor bg
	local sel = "#504945" -- bg2
	local blue = "#83a598"
	local yellow = "#fabd2f"
	local aqua = "#8ec07c"
	local gray = "#928374"

	hl(0, "BlinkCmpMenu", { fg = "#ebdbb2", bg = bg })
	hl(0, "BlinkCmpMenuBorder", { fg = blue, bg = bg })
	hl(0, "BlinkCmpMenuSelection", { bg = sel, bold = true })
	hl(0, "BlinkCmpScrollBarThumb", { bg = blue })
	hl(0, "BlinkCmpScrollBarGutter", { bg = "#3c3836" })
	hl(0, "BlinkCmpLabel", { fg = "#ebdbb2" })
	hl(0, "BlinkCmpLabelMatch", { fg = yellow, bold = true }) -- fuzzy-matched chars
	hl(0, "BlinkCmpLabelDescription", { fg = gray })
	hl(0, "BlinkCmpLabelDetail", { fg = gray })
	hl(0, "BlinkCmpSource", { fg = gray, italic = true })
	hl(0, "BlinkCmpKind", { fg = aqua })
	hl(0, "BlinkCmpGhostText", { fg = "#665c54", italic = true })
	hl(0, "BlinkCmpDoc", { fg = "#ebdbb2", bg = bg })
	hl(0, "BlinkCmpDocBorder", { fg = blue, bg = bg })
	hl(0, "BlinkCmpDocSeparator", { fg = sel, bg = bg })

	-- General floating windows (LSP hover / signature, diagnostics, etc.)
	-- so they match the completion menu.
	hl(0, "NormalFloat", { fg = "#ebdbb2", bg = bg })
	hl(0, "FloatBorder", { fg = blue, bg = bg })
	hl(0, "FloatTitle", { fg = yellow, bg = bg, bold = true })
end

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "gruvbox",
	callback = blink_highlights,
})

vim.cmd("colorscheme gruvbox")
