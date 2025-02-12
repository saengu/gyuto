local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later


--          ┌─────────────────────────────────────────────────────────┐
--
--                    ripgrep is required for live_grep
--
--                   To install ripgrep use shell command:
--                       sudo apt-get install ripgrep
--
--                     In case telescope not work properly,
--                 Use ':checkhealth telescope' to find problem
--          └─────────────────────────────────────────────────────────┘

-- Disable netrw
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1


-- Use later will not hijack netrw
now(function()
  add({
    source = "nvim-telescope/telescope.nvim",
    checkout = '0.1.8',
    depends = { "nvim-lua/plenary.nvim" },
  })

  require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = require("telescope.actions").close,  -- Quit on first single esc
            },
        },
    },
  })

  -- Replace netrw with telescope.nvim
  local find_files_hijack_netrw = vim.api.nvim_create_augroup("find_files_hijack_netrw", { clear = true })

  -- clear FileExplorer appropriately to prevent netrw from launching on folders
  -- netrw may or may not be loaded before telescope-find-files
  -- conceptual credits to nvim-tree and telescope-file-browser

  -- Took from https://stackoverflow.com/questions/76028722/how-can-i-temporarily-disable-netrw-so-i-can-have-telescope-at-startup
  vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    once = true,
    callback = function()
      local first_arg = vim.v.argv[3]
      if first_arg and vim.fn.isdirectory(first_arg) == 1 then
        -- Vim creates a buffer for folder. Close it.
        vim.cmd(":bd 1")
        require("telescope.builtin").find_files({ search_dirs = { first_arg } })
      end
    end,
  })
end)

