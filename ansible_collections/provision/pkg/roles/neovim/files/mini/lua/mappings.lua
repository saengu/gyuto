--          ┌─────────────────────────────────────────────────────────┐
--                          Borrowed options from
--                    https://gitlab.com/domsch1988/mvim
--                    https://github.com/echasnovski/nvim
--          └─────────────────────────────────────────────────────────┘


-- NOTE: Most basic mappings come from 'mini.basics'

local keymap = vim.keymap.set

-- ╔═══════════════════════╗
-- ║    General Keymaps    ║
-- ╚═══════════════════════╝
keymap("n", "<leader>q", "<cmd>wqa<cr>", { desc = 'Quit' })
keymap("n", "<leader>Q", "<cmd>qa!<cr>", { desc = 'Force Quit' })
keymap("n", "<leader>mu", function() require('mini.deps').update() end, { desc = 'Update Plugins' })
keymap("i", "<C-S-v>", "<C-r><C-o>*", { desc = 'Paste from System in Insertmode' })


-- ╔═══════════════════════╗
-- ║    Session Keymaps    ║
-- ╚═══════════════════════╝
keymap("n", "<leader>ss", function()
    vim.cmd('wa')
    require('mini.sessions').write()
    require('mini.sessions').select()
end, { desc = 'Switch Session' })

keymap("n", "<leader>sw", function()
    local cwd = vim.fn.getcwd()
    local last_folder = cwd:match("([^/]+)$")
    require('mini.sessions').write(last_folder)
end, { desc = 'Save Session' })

keymap("n", "<leader>sf", function()
        vim.cmd('wa')
        require('mini.sessions').select()
    end,
    { desc = 'Load Session' })

-- ╔══════════════════════╗
-- ║    Buffer Keymaps    ║
-- ╚══════════════════════╝
keymap("n", "<Leader>ba", "<cmd>b#<cr>", { desc = 'Alternate' })
keymap("n", "<Leader>bd", "<cmd>bd<cr>", { desc = 'Close Buffer' })
keymap("n", "<Leader>bq", "<cmd>%bd|e#<cr>", { desc = 'Close other Buffers' })
keymap("n", "<S-l>", "<cmd>bnext<cr>", { desc = 'Next Buffer' })
keymap("n", "<S-h>", "<cmd>bprevious<cr>", { desc = 'Previous Buffer' })
keymap("n", "<TAB>", "<C-^>", { desc = "Alternate buffers" })

-- Format Buffer
-- With and without LSP
if vim.tbl_isempty(vim.lsp.buf_get_clients()) then
    keymap("n", "<leader>bf", function() vim.lsp.buf.format() end,
        { desc = 'Format Buffer' })
else
    keymap("n", "<leader>bf", "gg=G<C-o>", { desc = 'Format Buffer' })
end

-- ╔══════════════════════╗
-- ║  Telescope Keymaps   ║
-- ╚══════════════════════╝
keymap('n', '<Leader>ff', ":lua require('telescope.builtin').find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>", {noremap = true, silent = true, desc = "Find files"})
keymap('n', '<Leader>fb', ":lua require('telescope.builtin').buffers()<cr>", {noremap = true, silent = true, desc = "Buffers"})
keymap('n', '<Leader>fg',  ":lua require('telescope.builtin').live_grep()<cr>", {noremap = true, silent = true, desc = "Live Grep"})
keymap('n', '<Leader>fh', ":lua require('telescope.builtin').help_tags()<cr>", {noremap = true, silent = true, desc = "Help Tags"})

--- Move <Tab> mapping to plugin.cmp handled by nvim-cmp
---
-- Make <Tab> work for snippets
-- Move inside completion list with <TAB>
--vim.keymap.set('i', '<Tab>', [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true })
--vim.keymap.set('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })

--[[
-- Took from offical vim.snippt function help document
vim.keymap.set({ 'i', 's' }, '<Tab>', function()
  vim.print("print tab")
  if vim.snippet.active({ direction = 1 }) then
    --vim.print("print snipe")
    return ':lua vim.snippet.jump(1)<cr>'
  else
    --vim.print("print nosnipe")
    return '<Tab>'
  end
end, { expr = true })
-]]
vim.keymap.set('n', '<space>d', vim.diagnostic.setloclist, {desc = "Add buffer diagnostics to the location list."})

-- ╔══════════════════════╗
-- ║  Helix Keymaps       ║
-- ╚══════════════════════╝

--- Space Mode
local telescope = require('telescope.builtin')
keymap('n', '<Space>/', telescope.live_grep, {noremap = true, silent = true, desc = "Global search in workspace folder"})
keymap('n', "<Space>'", telescope.resume,    {noremap = true, silent = true, desc = "Open last fuzzy picker"})
keymap('n', '<Space>a', vim.lsp.buf.code_action, {noremap = true, silent = true, desc = "Apply code action[TODO]"})
keymap('n', '<Space>b', telescope.buffers, {noremap = true, silent = true, desc = "Open buffer picker"})
keymap('n', '<Space>c', telescope.buffers, {noremap = true, silent = true, desc = "Comment/uncomment selections[TODO]"})
keymap('n', '<Space>C', telescope.buffers, {noremap = true, silent = true, desc = "Block comment/uncomment selections[TODO]"})
keymap('n', '<Space>d', telescope.diagnostics, {noremap = true, silent = true, desc = "Open diagnostic picker"})
keymap('n', '<Space>f', function()
  telescope.find_files({ find_command = {'rg', '--files', '--hidden', '--iglob', '!.git' }})
end, {noremap = true, silent = true, desc = "Open file picker"})
keymap('n', '<Space>g', telescope.git_status, {noremap = true, silent = true, desc = "Open changed files picker"})
keymap('n', '<Space>h', telescope.git_status, {noremap = true, silent = true, desc = "Highlight symbol reference[TODO]"})
keymap('n', '<Space>j', telescope.jumplist,   {noremap = true, silent = true, desc = "Open jumplist picker"})
keymap('n', '<Space>k', telescope.jumplist,   {noremap = true, silent = true, desc = "Show documentation for item under cursor[TODO]"})
keymap('n', '<Space>q', telescope.quickfix, {noremap = true, silent = true, desc = "Open quickfix picker"})
keymap('n', '<Space>r', vim.lsp.buf.rename, {noremap = true, silent = true, desc = "Rename symbol"})
keymap('n', '<Space>s', telescope.lsp_document_symbols,  {noremap = true, silent = true, desc = "Open symbol picker"})
keymap('n', '<Space>S', telescope.lsp_workspace_symbols, {noremap = true, silent = true, desc = "Open symbol picker for workspace"})
keymap('n', '<Space>w', "<C-w>", {remap = true, desc = "Window"})

keymap('n', 'gD', vim.lsp.buf.declaration, { desc = "Go to Declaration" })
keymap('n', 'gd', vim.lsp.buf.definition, { desc = "Go to Definition" })
keymap('n', 'gi', vim.lsp.buf.implementation, { desc = "Go to Implementation"})

--[[
keymap('n', '<M-k>', vim.lsp.buf.signature_help, { desc = "Signature Help" })
keymap('i', '<M-k>', vim.lsp.buf.signature_help, { desc = "Signature Help" })
keymap('n', '<space>wa', vim.lsp.buf.add_workspace_folder, { desc = "Add Workspace Folder"})
keymap('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, { desc = "Remove Workspace Folder"})
keymap('n', '<space>wl', function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, { desc = "List Workspace Folders"})
keymap('n', '<space>D', vim.lsp.buf.type_definition, { desc  = "Type Definition"})
keymap('n', '<space>r', vim.lsp.buf.rename, { desc = "Rename Symbol"})
keymap({ 'n', 'v' }, '<space>a', vim.lsp.buf.code_action, { desc = "Code Action"})
keymap('n', 'gr', vim.lsp.buf.references, { desc = "Buffer References"})
keymap('n', '<localleader>f', function()
  vim.lsp.buf.format { async = true }
end, { desc = "Format Buffer"})
--]]

