vim.g.mapleader = ","

vim.opt.encoding = "utf-8"

vim.opt.mousemoveevent = true


vim.opt.ignorecase = true
vim.opt.smartcase = true

--vim.opt.number = true
-- only use two digits for relative line number as it will not greater than 100,  two make statuscolumn condense.
vim.opt.numberwidth = 2
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"    -- always show signcolumn to avoid left most line jump when error occurs
-- make current line show line number instead of 0 as relative line number
--vim.opt.statuscolumn = "%=%{v:relnum?v:relnum:v:lnum}"

vim.opt.scrolloff = 10

vim.opt.compatible = false
vim.opt.hlsearch = true
vim.opt.laststatus = 2
vim.opt.vb = true
vim.opt.ruler = true
vim.opt.spell = true
vim.opt.spelllang = "en_us"
vim.opt.autoindent = true
vim.opt.colorcolumn = "120"
vim.opt.textwidth = 120
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamed,unnamedplus"
vim.opt.scrollbind = false
vim.opt.wildmenu = true

vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

vim.opt.autoindent = true
vim.opt.smartindent = true

-- highlight the line number of the cursor
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
