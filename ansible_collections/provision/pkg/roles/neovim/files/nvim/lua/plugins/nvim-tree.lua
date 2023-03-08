local M = {
  'nvim-tree/nvim-tree.lua', config=true,
}

function M.config()
     local tree = require('nvim-tree')
     local wk = require("which-key")

     tree.setup()

     local mappings = {
       e = {
         name = "+NvimTree",
         t = { ":NvimTreeToggle<CR>", "Toggle Tree" },
         f = { ":NvimTreeFocus<CR>", "Open and Focus on Tree" },
         s = { ":NvimTreeFindFile<CR>", "Find Current File" },
       }  
     }
     wk.register(mappings, {
       mode = "n", -- Normal mode
       prefix = "<leader>"
     })
end

return M
