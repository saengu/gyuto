-- Set global keymaps. keymap for plugins should put in plugins folder
-- Shortcuts for plugins should be registered via which-key.nvim plugin in config function on plugins submodule
--   config = function()
--     require(pluginname).setup()
--     local wk = require("which-key")
--     local mappings = ...
--     wk.register(mappings)

local map = vim.keymap.set

local default_opts = { noremap = true, silent = true }


-- Better escape using jk in insert and terminal mode
--map("i", "jk", "<ESC>", default_opts)
--map("t", "jk", "<C-\\><C-n>", default_opts)


-- Center search results
map("n", "n", "nzz", default_opts)
map("n", "N", "Nzz", default_opts)


-- Better indent
map("v", "<", "<gv", default_opts)
map("v", ">", ">gv", default_opts)


-- Paste over currently selected text without yanking it
map("v", "p", '"_dP', default_opts)


-- Switch buffer
map("n", "<S-h>", ":bprevious<CR>", default_opts)
map("n", "<S-l>", ":bnext<CR>", default_opts)


-- Cancel search highlighting with ESC
map("n", "<ESC>", ":nohlsearch<Bar>:echo<CR>", default_opts)

-- Move selected line / block of text in visual mode
map("x", "K", ":move '<-2<CR>gv-gv", default_opts)
map("x", "J", ":move '>+1<CR>gv-gv", default_opts)


-- Resizing panes
--map("n", "<Left>", ":vertical resize +1<CR>", default_opts)
--map("n", "<Right>", ":vertical resize -1<CR>", default_opts)
--map("n", "<Up>", ":resize -1<CR>", default_opts)
--map("n", "<Down>", ":resize +1<CR>", default_opts)

