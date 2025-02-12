local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Install LSP/formatting/linter executables ==================================
--later(function()
--  add('williamboman/mason.nvim')
--  require('mason').setup()
--end)


--          ┌─────────────────────────────────────────────────────────┐
--
--                Here we have to use 'now' to load 'lspconfig'.
--            The first opened buffer won't get a LSP client attached
--                if using 'later' due to two stages execution.
--
--                       For more details refer to
--              https://github.com/echasnovski/mini.nvim/issues/829
--
--          └─────────────────────────────────────────────────────────┘
now(function()
  add('neovim/nvim-lspconfig')

  local lspconfig = require('lspconfig')

  lspconfig.gopls.setup({})

  -- Took from LspAttach official help document
  vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client.server_capabilities.completionProvider then
          --vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
          -- Set up 'mini.completion' LSP part of completion
          vim.bo[bufnr].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
          --vim.bo[bufnr].completefunc = 'v:lua.MiniCompletion.completefunc_lsp'
          -- Mappings are created globally with `<Leader>l` prefix (for simplicity)
        end
        if client.server_capabilities.definitionProvider then
          vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
        end
      end,
  })
end)
