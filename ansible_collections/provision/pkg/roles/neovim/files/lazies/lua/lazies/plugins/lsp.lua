-- Stick with nvim-lspconfig which contains best-practice configuration for lots of language servers. 
-- To get better understanding of lsp, refer to
--   1. https://aliquote.org/post/neovim-lsp-easy/
--   2. https://zignar.net/2022/10/01/new-lsp-features-in-neovim-08/
--   3. https://vonheikemen.github.io/devlog/tools/neovim-lsp-client-guide/
return {
  "neovim/nvim-lspconfig",
  config = function () 
    local lspconfig = require("lspconfig")
    local languages = require("core.fs").load_submods("lazies.languages")


    -- Global mappings.

    -- 'lspconfig' does not map keybindings or enable completion by default.
    -- Manual, triggered completion can be provided by neovim's built-in omnifunc.
    -- For autocompletion, a general purpose autocompletion plugin is required.
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        -- Buffer local mappings. as the default mapping is reverted (https://github.com/neovim/neovim/pull/28649).
        local opts = { buffer = ev.buf }
        if vim.version.lt(vim.version(), '0.11') then
          vim.keymap.set('n', 'grr', vim.lsp.buf.references, opts)
        end

        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
        vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>f', function()
            vim.lsp.buf.format { async = true }
        end, opts)
        --vim.keymap.set(
        --  "n",
        --  "<Leader>a",
        --  vim.lsp.buf.code_action,
        --  { noremap = true, silent = true }
        --)
      end,
    })

    local opts = {}
    -- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers.
    local ok, cmp = pcall(require, "cmp_nvim_lsp")
    if ok then
      -- No brackets will be inserted for functions if not override with lsp capabilities.
      -- TODO: fix https://github.com/hrsh7th/cmp-nvim-lsp/issues/72
      local capabilities = vim.lsp.protocol.make_client_capabilities() -- override default capabilities of cmp
      opts["capabilities"] = cmp.default_capabilities(capabilities)
    end

    for name, cfg in pairs(languages) do
      if require("core.fn").iscallable(cfg.lspconfig.setup) then
        cfg.lspconfig.setup(lspconfig, opts)
      end
    end
  end
}
