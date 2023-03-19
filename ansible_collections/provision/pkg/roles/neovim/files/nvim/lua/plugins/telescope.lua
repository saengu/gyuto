local M = {
  'nvim-telescope/telescope.nvim', tag = '0.1.1',
  dependencies = {
    'nvim-lua/plenary.nvim',
  }
}

function M.config()
  local icons = require("core.icons")
  local telescope = require('telescope')
  local actions = require("telescope.actions")

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
    extensions = {
    }
  })
end

return M
