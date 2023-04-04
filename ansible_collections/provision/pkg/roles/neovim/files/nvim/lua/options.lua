local g = vim.g
local o = vim.o
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
-- characters will look dim. Use a guard to set termguicolors only for terminals support 256 colors.
if os.getenv("TERM_PROGRAM") ~= 'Apple_Terminal' then
  opt.termguicolors = true      -- Enable colors in terminal
end

opt.hlsearch = true           --Set highlight on search
opt.clipboard = "unnamedplus" -- Access system clipboard
opt.ignorecase = true         --Case insensitive searching unless /C or capital in search
opt.smartcase = true          -- Smart case


-- Custom statusline
opt.laststatus = 3 -- Global statusline
function statusline()
  local mode = "%-5{%v:lua.string.upper(v:lua.vim.fn.mode())%}"
  local filename = "%-.16t"
  local bufnr = " [b%n]"
  local winnr = " [w%{winnr()}]"
  local modified = " %-m"
  local filetype = " %y"
  local right_align = "%="
  --local context = "%{%v:lua.require'nvim-navic'.get_location()%}"
  local context = ""
  local line = "%10([%l/%L%)]"
  local percent = "%5p%%"

  return table.concat({mode, filename, bufnr, winnr, filetype, right_align, context, line, percent})
end
opt.statusline = statusline()
