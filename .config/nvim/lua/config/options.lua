local options = {
 	undofile = true,
	number = true,
	expandtab = true,
	tabstop = 4,
    wrap = false,
}


for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.cmd("colorscheme gruvbox")
