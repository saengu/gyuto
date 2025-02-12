local add, later = MiniDeps.add, MiniDeps.later

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
