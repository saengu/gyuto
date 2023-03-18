local diagnostic = require("core.diagnostic")

-- Change floating box of telescope from purple to black backgroud
vim.cmd("hi NormalFloat ctermfg=LightGrey")


-- Change the color of nvim-cmp prompt box
vim.cmd("hi Pmenu guifg=#FBF3D5 ctermfg=223 guibg=#3c3836 ctermbg=237 gui=NONE cterm=NONE")
vim.cmd("hi PmenuSel guifg=#000000 ctermfg=black guibg=#FFFFFF ctermbg=255 gui=NONE cterm=NONE")
vim.cmd("hi PmenuSbar guifg=NONE ctermfg=NONE guibg=#665c54 ctermbg=59 gui=NONE cterm=NONE")
vim.cmd("hi PmenuThumb guifg=NONE ctermfg=NONE guibg=#ebdbb2 ctermbg=223 gui=NONE cterm=NONE")


-- Custom diagnostics icons and style of other UI elements
diagnostic:setup()
