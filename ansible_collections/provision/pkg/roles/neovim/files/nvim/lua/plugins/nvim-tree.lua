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

  -- Open nvim-tree in current buffer when nvim open a directory
  -- Refer to https://github.com/nvim-tree/nvim-tree.lua/wiki/Open-At-Startup
  vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

  -- Close nvim-tree if it is the last buffer
  -- Refer to https://github.com/nvim-tree/nvim-tree.lua/wiki/Auto-Close#beauwilliams
  --vim.api.nvim_create_autocmd("BufEnter", {
  --  group = vim.api.nvim_create_augroup("NvimTreeClose", {clear = true}),
  --  pattern = "NvimTree_*",
  --  callback = function()
  --    local layout = vim.api.nvim_call_function("winlayout", {})
  --    if layout[1] == "leaf" and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree" and layout[3] == nil then vim.cmd("confirm quit") end
  --  end
  --})

  -- Show diagnostic icons
  tree.setup({
    diagnostics = {
      enable = true
    }
  })
end

return M
