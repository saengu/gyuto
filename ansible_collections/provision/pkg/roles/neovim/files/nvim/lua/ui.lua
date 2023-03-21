local diagnostic = require("core.diagnostic")
local highlight = require("core.util").highlight


-- Change floating box from purple to black backgroud
--highlight('NormalFloat', { bg='#3C3836', fg='White', ctermbg=237, ctermfg='White' })


-- Change the color of nvim-cmp prompt box
highlight('Pmenu',  { bg='#3C3836', fg='#FBF3D5', ctermbg=237, ctermfg=223, default=false })
highlight('PmenuSel', { bg='White', fg='Black', ctermbg='White', ctermfg='Black', default=false })
--highlight('PmenuSbar', { bg='#665C54', ctermbg=59 })
--highlight('PmenuThumb', { bg='#EBDBB2', ctermbg=223 })


-- Make comments italic
highlight('Comment', { italic=true, default=true })


-- Custom diagnostics icons and style of other UI elements
diagnostic:setup()
