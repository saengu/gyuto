local Options = require("plugins.lsp.options")

local M = Options:new({
  build = 'command -v gopls >/dev/null || go install golang.org/x/tools/gopls@latest'
})

function M.on_attach(client, bufnr)
  Options.on_attach(client, bufnr)

  -- Organize imports
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
      vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
    end
  })
end

return M

