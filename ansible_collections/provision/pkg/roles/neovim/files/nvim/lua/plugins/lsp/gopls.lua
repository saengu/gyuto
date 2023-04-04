local Options = require("plugins.lsp.options")

local M = Options:new({
  build = 'command -v gopls >/dev/null || go install golang.org/x/tools/gopls@latest'
})


function lsp_organize_imports()
  local params = vim.lsp.util.make_range_params(nil, vim.lsp.util._get_offset_encoding())
  params.context = {only = {"source.organizeImports"}}

  local timeout = 1000 -- ms
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, vim.lsp.util._get_offset_encoding())
      else
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end
end

function M.on_attach(client, bufnr)
  Options.on_attach(client, bufnr)

  -- Organize imports
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = lsp_organize_imports,
    --  callback = function( )
    --    vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
    --  end
    --  command = [[ :silent! lua vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true }) ]],
    -- FROM: https://github.com/neovim/nvim-lspconfig/issues/115
  })
end

return M

