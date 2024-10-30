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
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
    --vim.diagnostic.config({
    --   float = { border = "rounded" },
    --})

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
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
        --vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<space>f', function()
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

    for name, cfg in pairs(languages) do
      local opts = {}
      if require("core.fn").iscallable(cfg.lspconfig.setup) then
        cfg.lspconfig.setup(lspconfig, opts)
      end
    end
  end
}
