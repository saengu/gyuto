--------------------------------------------------------------------------
-- Shortcuts for plugins should be registered via which-key.nvim plugin
-- in config function of plugins submodule
--   config = function()
--     require(pluginname).setup()
--     local wk = require("which-key")
--     local mappings = ...
--     wk.register(mappings)
--------------------------------------------------------------------------

-- TODO: add more help functions for other modules to register key binding
local M = { "folke/which-key.nvim" }

function M.register_multi_mode(mappings, modes)
  wk = require("which-key")

  for _,m in pairs(modes) do
    wk.register(mappings, {mode = m})
  end
end

function M.config()
  wk = require("which-key")

  -- Time in milliseconds to wait for a mapped sequence to complete.
  vim.o.timeout = true
  vim.o.timeoutlen = 300

  local cfg = {
    window = {
    border = "single", -- none, single, double, shadow
      position = "bottom", -- bottom, top
    },
  }
  wk.setup(cfg)

  wk.register({
    ['J'] = { '3jzz', 'Move 3 lines down and center' },
    ['K'] = { '3kzz', 'Move 3 lines up and center' },
  }, { mode = 'n', noremap = true, })

  wk.register({
    ['<C-h>'] = { '<C-o>h', 'Left' },
    ['<C-j>'] = { '<C-o>j', 'Down' },
    ['<C-k>'] = { '<C-o>k', 'Up' },
    ['<C-l>'] = { '<C-o>l', 'Right' },
  }, { mode = 'i' })


  -- Shortcuts start with Leader key
  wk.register({
    ["w"] = { ":update!<CR>", "Save" },
    ["q"] = { ":q!<CR>", "Quit without save" },
    ["Q"] = { ":waq<CR>", "Save all & quit" },

    b = {
      name = "Buffer",
      c = { "<Cmd>bd!<Cr>", "Close current buffer" },
      D = { "<Cmd>%bd|e#|bd#<Cr>", "Delete all buffers" },
    },

    z = {
      name = "Lazy",
      h = { ":Lazy health<cr>", "Health" },
      i = { ":Lazy install<cr>", "Install" },
      u = { ":Lazy update<cr>", "Update" },
    },

    g = {
      name = "Git",
      s = { "<cmd>Neogit<CR>", "Status" },
    },
  }, {
    mode = "n", -- Normal mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
  })

end

return M
