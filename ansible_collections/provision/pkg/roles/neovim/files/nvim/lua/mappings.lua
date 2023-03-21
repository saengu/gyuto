-- Set global keymaps. keymap for plugins should put in plugins folder
-- Shortcuts for plugins should be registered via which-key.nvim plugin in config function on plugins submodule
--   config = function()
--     require(pluginname).setup()
--     local wk = require("which-key")
--     local mappings = ...
--     wk.register(mappings)
--   end

local key = require("core.key")


-----------------------------------------------------------
--
-- Setup Key Bindings from SpaceVim
--
-----------------------------------------------------------

---------------------------------------
-- Buffers manipulation key bindings
---------------------------------------
key.native = false
key.set({
  b = {
    name = "Buffer",
    b = { "<cmd>bnext<cr>", "Switch to next buffer" },
    f = { "<cmd>Telescope buffers<cr>", "Find buffer" },
    n = { "<cmd>bnext<cr>", "Switch to next buffer" },
    p = { "<cmd>bprevious<cr>", "Switch to previous buffer" },
  },

  f = {
    name = "Files",
    b = { "<cmd>Telescope buffers<cr>", "Find buffers" },
    c = { "<cmd>Telescope commands<cr>", "Find commands" },
    f = { "<cmd>Telescope find_files<cr>", "Find files" },
    g = { "<cmd>Telescope live_grep<cr>", "Grep files" },

    e = {
      name = "File Explorer",
      e = { "<cmd>NvimTreeToggle<cr>", "Toggle file explorer" },
      f = { "<cmd>NvimTreeFocus<cr>", "Open and focus on file explorer" },
      l = { "<cmd>NvimTreeFindFile<cr>", "Locate file in tree" },
    }
  },

  w = {
    name = "Windows",
    ['<Tab>'] = { "<cmd>wincmd w<cr>", "Go to next window" },
    ['<S-Tab>'] = { "<cmd>wincmd p<cr>", "Go to prevous window" },
    h = { ":wincmd h<cr>", "Go to left window" }, -- The default behavior of : is to place the count before the command.
    j = { ":wincmd j<cr>", "Go to below window" },
    k = { ":wincmd k<cr>", "Go to above window" },
    l = { ":wincmd l<cr>", "Go to right window" },
    p = { ":wincmd p<cr>", "Go to previous visited window" },
    -- You can obtain that number from the v:count or v:count1 variable. See :help v:count
    -- Why <C-U>, because if you use a count before running into command line, vim will insert a range automatically. 
    -- <C-U> is used to clear that range so that we do not run into error when running a command that does not take a range.
    -- Refer to https://superuser.com/questions/410847/how-do-you-create-a-vim-key-mapping-that-requires-numbers-before-the-hotkey-lik
    --w = { ":<C-U>exe v:count.'wincmd w'<cr>", "Go to window of given number" },
    -- Go to next window if no window number provide otherwise go to window of the specific number
    w = {
      function()
        local cnt = vim.v.count
        if cnt == 0 then
          vim.cmd(':wincmd w')
        else
          vim.cmd(':' .. cnt .. 'wincmd w')
        end
      end,
      "Go to next or specific window"
    },
  },
}, { mode = 'n', prefix = '<leader>' })



-----------------------------------------------------------
--
-- Old Key Bindings
--
-- TODO: rewrite below bindings with new core.key api
-----------------------------------------------------------
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

