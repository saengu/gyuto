local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- ╔═══════════════════════╗
-- ║ Lsp                   ║
-- ╚═══════════════════════╝
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


-- ╔═══════════════════════╗
-- ║ Telescope             ║
-- ╚═══════════════════════╝

--          ┌─────────────────────────────────────────────────────────┐
--
--                    ripgrep is required for live_grep
--
--                   To install ripgrep use shell command:
--                       sudo apt-get install ripgrep
--
--                     In case telescope not work properly,
--                 Use ':checkhealth telescope' to find problem
--          └─────────────────────────────────────────────────────────┘

-- Use later will not hijack netrw
now(function()
  add({
    source = "nvim-telescope/telescope.nvim",
    checkout = '0.1.8',
    depends = { "nvim-lua/plenary.nvim" },
  })

  require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = require("telescope.actions").close,  -- Quit on first single esc
            },
        },
    },
  })

  -- Disable netrw
  vim.g.loaded_netrwPlugin = 1
  vim.g.loaded_netrw = 1

  -- Replace netrw with telescope.nvim
  local find_files_hijack_netrw = vim.api.nvim_create_augroup("find_files_hijack_netrw", { clear = true })

  -- clear FileExplorer appropriately to prevent netrw from launching on folders
  -- netrw may or may not be loaded before telescope-find-files
  -- conceptual credits to nvim-tree and telescope-file-browser

  -- Took from https://stackoverflow.com/questions/76028722/how-can-i-temporarily-disable-netrw-so-i-can-have-telescope-at-startup
  vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    once = true,
    callback = function()
      local first_arg = vim.v.argv[3]
      if first_arg and vim.fn.isdirectory(first_arg) == 1 then
        -- Vim creates a buffer for folder. Close it.
        vim.cmd(":bd 1")
        require("telescope.builtin").find_files({ search_dirs = { first_arg } })
      end
    end,
  })
end)


-- ╔═══════════════════════╗
-- ║ Themes                ║
-- ╚═══════════════════════╝

now(function()
  add('folke/tokyonight.nvim')
  add('sainnhe/gruvbox-material')
  add({ source = 'catppuccin/nvim', name = 'catppuccin-nvim' })
--   add('rebelot/kanagawa.nvim')
--   add('sainnhe/everforest')
--   add({ source = 'rose-pine/neovim', name = 'rose-pine' })
--   add('bluz71/vim-moonfly-colors')
  add('ellisonleao/gruvbox.nvim')
--   add('craftzdog/solarized-osaka.nvim')
--   add('navarasu/onedark.nvim')
--   add('projekt0n/github-nvim-theme')
--   add('marko-cerovac/material.nvim')
--   require('material').setup({ plugins = { 'mini' } })
--   add('EdenEast/nightfox.nvim')
--   add('scottmckendry/cyberdream.nvim')
--   add('Shatur/neovim-ayu')

--   Set color scheme
--   vim.cmd('colorscheme catppuccin')
end)


-- ╔═══════════════════════╗
-- ║ Treesitter            ║
-- ╚═══════════════════════╝

-- Tree-sitter (advanced syntax parsing, highlighting, textobjects) ===========
later(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'master',
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
  })
  add('nvim-treesitter/nvim-treesitter-textobjects')

  --stylua: ignore
  local ensure_installed = {
    'bash',       'c',    'cpp',  'css',      'go',              'html',
    'javascript', 'json', 'lua',  'markdown', 'markdown_inline', 'python',
    'regex',      'rust', 'toml', 'tsx',      'yaml',
  }

  require('nvim-treesitter.configs').setup({
    --ensure_installed = ensure_installed,
    highlight = { enable = true },
    textobjects = { enable = false },
    --indent = { enable = false },
    --incremental_selection = { enable = false },

    -- Took from https://evantravers.com/articles/2024/09/17/making-my-nvim-act-more-like-helix-with-mini-nvim/
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<M-o>",
        scope_incremental = "<M-O>",
        node_incremental = "<M-o>",
        node_decremental = "<M-i>",
      },
    },
  })
end)
