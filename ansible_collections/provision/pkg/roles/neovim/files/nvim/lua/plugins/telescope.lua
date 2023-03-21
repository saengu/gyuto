local highlight = require("core.util").highlight

local M = {
  'nvim-telescope/telescope.nvim', tag = '0.1.1',
  dependencies = {
    'nvim-lua/plenary.nvim',
  }
}


-- Custom Telescope styles, can NOT work if move blow code into plugins.telescope.config
-- Refer to https://github.com/nvim-telescope/telescope.nvim/blob/master/plugin/telescope.lua#L18-L22
highlight('TelescopeNormal', { bg='#3C3836', fg='White', ctermbg=237, ctermfg='White' })
highlight('TelescopeSelection', { bg='DarkGrey', fg='White', ctermbg='DarkGrey', ctermfg='White' })
highlight('TelescopePromptPrefix', { fg='White', ctermfg='White' })
highlight('TelescopePromptCounter', { fg='White', ctermfg='White' })
highlight('TelescopeMatching', { fg='Yellow', ctermfg='Yellow' })


function M.config()
  local icons = require('core.icons')
  local highlight = require('core.util').highlight
  local telescope = require('telescope')
  local actions = require('telescope.actions')

  telescope.setup({
    defaults = {
      prompt_prefix = icons.ui.Telescope .. " ",
      selection_caret = " ",
      borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
      mappings = {
        -- Close float box by pressing ESC once, otherwise need to press twice,
        -- first to quit INSERT mode, second to close float box
        i = {
          ["<ESC>"] = actions.close,
        }
      }
    },
    extensions = {},
  })

end


return M
