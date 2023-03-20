local g = vim.g
local o = vim.opt

g.mapleader = " "
g.maplocalleader = " "

--o.cmdheight = 0             -- hide command line unless needed
o.encoding = "utf-8"
o.expandtab = true          -- Enable the use of space in tab
o.mouse = "a"               --Enable mouse mode
o.number = true             --Make line numbers default
o.relativenumber = true     --Make relative number default
o.shiftwidth = 2
o.tabstop = 2


-- Since Terminal.app on MacOS only supports 256 colors, which is not the 24-bit color that truecolors uses,
-- characters will look dim. Use a guard to set termguicolors only for terminals support 256 colors.
if os.getenv("TERM_PROGRAM") ~= 'Apple_Terminal' then
  o.termguicolors = true      -- Enable colors in terminal
end

o.hlsearch = true           --Set highlight on search
o.clipboard = "unnamedplus" -- Access system clipboard
o.ignorecase = true         --Case insensitive searching unless /C or capital in search
o.smartcase = true          -- Smart case

