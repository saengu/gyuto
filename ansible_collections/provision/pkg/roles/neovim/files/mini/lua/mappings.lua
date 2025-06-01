--          ┌─────────────────────────────────────────────────────────┐
--                          Borrowed options from
--                    https://gitlab.com/domsch1988/mvim
--                    https://github.com/echasnovski/nvim
--          └─────────────────────────────────────────────────────────┘


-- NOTE: Most basic mappings come from 'mini.basics'

local keymap = vim.keymap.set
local telescope = require('telescope.builtin')

-- ╔═══════════════════════╗
-- ║    General Keymaps    ║
-- ╚═══════════════════════╝
keymap("n", "<Leader>mu", require('mini.deps').update, { desc = 'Update Plugins' })
keymap('n', '<Leader>mr', telescope.reloader,    {noremap = true, silent = true, desc = "Reload Lua modules"})
keymap("n", "<Leader>q",  "<cmd>wqa<cr>", { desc = 'Quit' })
keymap("n", "<Leader>Q",  "<cmd>qa!<cr>", { desc = 'Force Quit' })
keymap('n', '<Leader>T', telescope.builtin, {noremap = true, silent = true, desc = "Show Telescope builtin pickers"})
keymap('n', '<Leader>t', telescope.treesitter, {noremap = true, silent = true, desc = "Open tree-sitter picker"})
keymap("i", "<C-S-v>",    "<C-r><C-o>*",  { desc = 'Paste from system in insert mode' })


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
end, { desc = 'Load Session' })

-- ╔══════════════════════╗
-- ║    Buffer Keymaps    ║
-- ╚══════════════════════╝
keymap("n", "<Leader>ba", "<cmd>b#<cr>", { desc = 'Alternate buffer' })
keymap("n", "<Leader>bd", "<cmd>bd<cr>", { desc = 'Close buffer' })
keymap("n", "<Leader>bd", "<cmd>bd<cr>", { desc = 'Close buffer' })
keymap("n", "<Leader>bw", "<cmd>bw<cr>", { desc = 'Wipeout buffer' })
keymap("n", "<S-l>", "<cmd>bnext<cr>", { desc = 'Next buffer' })
keymap("n", "<S-h>", "<cmd>bprevious<cr>", { desc = 'Previous buffer' })
keymap("n", "<TAB>", "<C-^>", { desc = "Alternate buffers" })
keymap("n", "<S-Tab>", "<cmd>bw<cr>", { desc = 'Wipeout buffer' })

-- Format Buffer with and without LSP
keymap("n", "<Leader>bf", function()
  if vim.tbl_isempty(vim.lsp.buf_get_clients()) then
    --vim.fn.feedkeys(vim.api.nvim_replace_termcodes("gg=G<C-o>", true, true, true), "")
    vim.fn.feedkeys("gg=G<C-o>", "")
  else
    vim.lsp.buf.format()
  end
end, { desc = "Format buffer" })


-- ╔══════════════════════╗
-- ║  Telescope Keymaps   ║
-- ╚══════════════════════╝
--keymap('n', '<Leader>ff', ":lua require('telescope.builtin').find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>", {noremap = true, silent = true, desc = "Find files"})
--keymap('n', '<Leader>fb', ":lua require('telescope.builtin').buffers()<cr>", {noremap = true, silent = true, desc = "Buffers"})
--keymap('n', '<Leader>fg',  ":lua require('telescope.builtin').live_grep()<cr>", {noremap = true, silent = true, desc = "Live Grep"})
--keymap('n', '<Leader>fh', ":lua require('telescope.builtin').help_tags()<cr>", {noremap = true, silent = true, desc = "Help Tags"})

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
--vim.keymap.set('n', '<space>d', vim.diagnostic.setloclist, {desc = "Add buffer diagnostics to the location list."})

-- ╔══════════════════════╗
-- ║  Helix Keymaps       ║
-- ╚══════════════════════╝

--- Space Mode
--- Most often used keymap and only one level
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
--keymap('n', '<Space>k', vim.lsp.buf.signature_help, {noremap = true, silent = true, desc = "Show signature help"})
keymap('n', '<Space>k', vim.lsp.buf.hover,    {noremap = true, silent = true, desc = "Show documentation for item under cursor"})
keymap('n', '<Space>l', telescope.loclist,    {noremap = true, silent = true, desc = "Open current window's location list picker"})
keymap('n', '<Space>p', telescope.builtin,    {noremap = true, silent = true, desc = "Open current window's location list picker"})
keymap('n', '<Space>q', telescope.quickfix,   {noremap = true, silent = true, desc = "Open quickfix picker"})
keymap('n', '<Space>Q', telescope.quickfixhistory, {noremap = true, silent = true, desc = "Open quickfix history picker"})
keymap('n', '<Space>r', vim.lsp.buf.rename, {noremap = true, silent = true, desc = "Rename symbol"})
keymap('n', '<Space>s', telescope.lsp_document_symbols,  {noremap = true, silent = true, desc = "Open symbol picker"})
keymap('n', '<Space>S', telescope.lsp_workspace_symbols, {noremap = true, silent = true, desc = "Open symbol picker for workspace"})
keymap('n', '<Space>w', "<C-w>", {remap = true, desc = "Window"})

--keymap({'i', 'n'}, '<C-k>', vim.lsp.buf.signature_help, {noremap = true, silent = true, desc = "Show signature help"})
keymap({'i', 'n'}, '<C-k>', vim.lsp.buf.hover,    {noremap = true, silent = true, desc = "Show documentation for item under cursor"})

-- ╔══════════════════════╗
-- ║  Git Keymaps         ║
-- ╚══════════════════════╝

keymap('n', '<Leader>gc', telescope.git_commits,    {noremap = true, silent = true, desc = "Open commits picker"})
keymap('n', '<Leader>gb', telescope.git_bcommits,   {noremap = true, silent = true, desc = "Show buffer commits and checkout"})
keymap({'n','v'}, '<Leader>gB', telescope.git_branches,   {noremap = true, silent = true, desc = "Open branches picker"})
keymap('n', '<Leader>gs', telescope.git_status,   {noremap = true, silent = true, desc = "Show current changes by file"})
keymap('n', '<Leader>gS', telescope.git_stash,   {noremap = true, silent = true, desc = "Stash items in current repository"})

-- ╔═══════════════════════════╗
-- ║  Language Server Keymaps  ║
-- ╚═══════════════════════════╝
keymap('n', '<Leader>lc', telescope.lsp_incoming_calls, { desc = "Open incoming calls picker" })
keymap('n', '<Leader>lC', telescope.lsp_incoming_calls, { desc = "Open outgoing calls picker" })
keymap('n', '<Leader>ld', telescope.diagnostics, {noremap = true, silent = true, desc = "Open diagnostic picker"})
keymap('n', '<Leader>lr', telescope.lsp_references, { desc = "Open references picker" })
keymap('n', '<Leader>ls', telescope.lsp_document_symbols,  {noremap = true, silent = true, desc = "Open symbol picker"})
keymap('n', '<Leader>lS', telescope.lsp_workspace_symbols, {noremap = true, silent = true, desc = "Open symbol picker for workspace"})
keymap('n', '<Leader>lD', telescope.lsp_definitions, { desc = "Go to definition" })
keymap('n', '<Leader>li', telescope.lsp_implementations, { desc = "Go to implementation"})
keymap('n', '<Leader>lt', telescope.lsp_type_definitions, { desc = "Go to type definition"})

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

