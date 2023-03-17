local M = {
  'nvim-telescope/telescope.nvim', tag = '0.1.1',
  dependencies = {
    'nvim-lua/plenary.nvim',
  }
}

function M.config()
  local icons = require("core.icons")
  local wk = require("which-key")
  local telescope = require('telescope')
  local actions = require("telescope.actions")
  local builtin = require('telescope.builtin')

  local mappings = {
    f = {
      name = "+Telescope",
      f = { builtin.find_files, "Find files" },
      g = { builtin.live_grep, "Live grep" },
      b = { builtin.buffers, "Buffers" },
      h = { builtin.help_tags, "Help tags" },
    }
  }
  wk.register(mappings, {
    mode = "n", -- Normal mode
    prefix = "<leader>"
  })
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
