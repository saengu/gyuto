local g = vim.g
local opt = vim.opt

g.mapleader = " "
g.maplocalleader = " "

--opt.cmdheight = 0             -- hide command line unless needed
opt.encoding = "utf-8"
opt.expandtab = true          -- Enable the use of space in tab
opt.mouse = "a"               --Enable mouse mode
opt.number = true             --Make line numbers default
opt.relativenumber = true     --Make relative number default
opt.shiftwidth = 2
opt.tabstop = 2

-- Since Terminal.app on MacOS only supports 256 colors, which is not the 24-bit color that truecolors uses,
-- characters will look dim. Either change to iTerm.app or disable this feature.
--opt.termguicolors = true      -- Enable colors in terminal

opt.hlsearch = true           --Set highlight on search
opt.clipboard = "unnamedplus" -- Access system clipboard
opt.ignorecase = true         --Case insensitive searching unless /C or capital in search
opt.smartcase = true          -- Smart case


-- Change floating box of telescope from purple to black backgroud
vim.cmd("hi NormalFloat ctermfg=LightGrey")

-- Change the color of nvim-cmp prompt box
vim.cmd("hi Pmenu guifg=#FBF3D5 ctermfg=223 guibg=#3c3836 ctermbg=237 gui=NONE cterm=NONE")
vim.cmd("hi PmenuSel guifg=#000000 ctermfg=black guibg=#FFFFFF ctermbg=255 gui=NONE cterm=NONE")
vim.cmd("hi PmenuSel guifg=#000000 ctermfg=black guibg=#FFFFFF ctermbg=255 gui=NONE cterm=NONE")
vim.cmd("hi PmenuSbar guifg=NONE ctermfg=NONE guibg=#665c54 ctermbg=59 gui=NONE cterm=NONE")
vim.cmd("hi PmenuThumb guifg=NONE ctermfg=NONE guibg=#ebdbb2 ctermbg=223 gui=NONE cterm=NONE")
