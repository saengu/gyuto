local M = {
  'nvim-telescope/telescope.nvim', tag = '0.1.1',
  dependencies = { 'nvim-lua/plenary.nvim' }
}

function M.config()
     local wk = require("which-key")
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
end

return M
