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
keymap('n', '<leader>ff', ":lua require('telescope.builtin').find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>", {noremap = true, silent = true, desc = "Find files"})
keymap('n', '<leader>fb', ":lua require('telescope.builtin').buffers()<cr>", {noremap = true, silent = true, desc = "Buffers"})
keymap('n', '<leader>fg',  ":lua require('telescope.builtin').live_grep()<cr>", {noremap = true, silent = true, desc = "Live Grep"})
keymap('n', '<leader>fh', ":lua require('telescope.builtin').help_tags()<cr>", {noremap = true, silent = true, desc = "Help Tags"})

-- Make <Tab> work for snippets
-- Move inside completion list with <TAB>
vim.keymap.set('i', '<Tab>', [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true })
vim.keymap.set('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })
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
keymap('n', '<space>/', "<cmd>lua require('telescope.builtin').live_grep()<cr>", {noremap = true, silent = true, desc = "Live Grep"})
keymap('n', '<space>b', ":lua require('telescope.builtin').buffers()<cr>", {noremap = true, silent = true, desc = "Buffers"})
keymap('n', '<space>f', ":lua require('telescope.builtin').find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>", {noremap = true, silent = true, desc = "Find Files"})

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

