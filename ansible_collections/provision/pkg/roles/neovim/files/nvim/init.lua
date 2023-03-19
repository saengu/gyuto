-- Set vim options
require("options")

-- Set style of global UI components
require("ui")

-- Load lazy.nvim plugin manager and setup plugins
require("core.lazy")

-- Set global key mappings
-- load mappings module after lazy plugin loaded as it maybe rely on
-- third-party plugin which-key
require("mappings")

