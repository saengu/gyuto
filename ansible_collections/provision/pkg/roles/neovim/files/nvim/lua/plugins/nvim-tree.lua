local M = {
  'nvim-tree/nvim-tree.lua', config=true,
}


-- Open nvim-tree if nvim open directory as netrw do
local function open_nvim_tree(data)
  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not directory then
    return
  end

  -- change to the directory
  vim.cmd.cd(data.file)

  -- open the tree
  require("nvim-tree.api").tree.open()
end

function M.config()
  local tree = require('nvim-tree')
  local wk = require("which-key")

  -- Open nvim-tree in current buffer when nvim open a directory
  -- Refer to https://github.com/nvim-tree/nvim-tree.lua/wiki/Open-At-Startup
  vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

  -- Close nvim-tree if it is the last buffer
  --vim.api.nvim_create_autocmd("BufEnter", {
  --  nested = true,
  --  callback = function()
  --    if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
  --      vim.cmd "quit"
  --    end
  --  end
  --})

  tree.setup({
    diagnostics = {
      enable = true
    }
  })

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
