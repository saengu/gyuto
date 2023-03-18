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

