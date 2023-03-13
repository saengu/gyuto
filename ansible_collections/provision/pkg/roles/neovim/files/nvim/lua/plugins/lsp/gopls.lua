local Options = require("plugins.lsp.options")

local M = Options:new({
  build = 'command -v gopls >/dev/null || go install golang.org/x/tools/gopls@latest'
})

return M

