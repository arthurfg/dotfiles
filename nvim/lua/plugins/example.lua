-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
if true then return {} end

-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  -- add gruvbox
  { "ellisonleao/gruvbox.nvim" },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },

  -- change trouble config
  {
    "folke/trouble.nvim",
    -- opts will be merged with the parent spec
    opts = { use_diagnostic_signs = true },
  },

  -- disable trouble
  { "folke/trouble.nvim", enabled = false },
  {
  "neovim/nvim-lspconfig",
  config = function()
    local lspconfig = require("lspconfig")
    -- Configuração para o Pyright
    lspconfig.pyright.setup{
      on_attach = function(client, bufnr)
        -- Aqui você pode adicionar configurações de keymaps ou outras configurações de LSP
        print("Pyright LSP attached")
      end,
      flags = {
        debounce_text_changes = 150,
      },
    }
  end,
},
  -- override nvim-cmp and add cmp-emoji
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",  -- Para usar LSP no autocompletion
      "hrsh7th/cmp-emoji",      -- Complemento para emoji
      "saadparwaiz1/cmp_luasnip", -- Para usar luasnip no autocompletion
      "hrsh7th/cmp-buffer",     -- Para usar buffer como fonte de autocompletion
      "hrsh7th/cmp-path",       -- Para sugerir caminhos de arquivos
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "buffer" },        -- Sugestões baseadas no conteúdo do buffer
        { name = "path" },          -- Sugestões baseadas em caminhos de arquivos
        { name = "emoji" },         -- Sugestões de emoji
      })
      -- Ajuste o comportamento do autocomplete (exemplo: configurar para exibir sugestões automaticamente)
      opts.window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      }
    end,
  },  -- change some telescope options and a keymap to browse plugin files
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>fp",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
    },
    -- change some options
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },

  -- for typescript, LazyVim also includes extra specs to properly setup lspconfig,
  -- treesitter, mason and typescript.nvim. So instead of the above, you can use:
  { import = "lazyvim.plugins.extras.lang.typescript" },

  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
    },
  },

  -- since `vim.tbl_deep_extend`, can only merge tables and not lists, the code above
  -- would overwrite `ensure_installed` with the new value.
  -- If you'd rather extend the default config, use the code below instead:
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "tsx",
        "typescript",
        "python",
        "py"
      })
    end,
  },

  -- the opts function can also be used to change the default opts:
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, {
        function()
          return "😄"
        end,
      })
    end,
  },

  -- or you can return new options to override all the defaults
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        --[[add your custom lualine config here]]
      }
    end,
  },

  -- use mini.starter instead of alpha
  { import = "lazyvim.plugins.extras.ui.mini-starter" },

  -- add jsonls and schemastore packages, and setup treesitter for json, json5 and jsonc
  { import = "lazyvim.plugins.extras.lang.json" },

  -- add any tools you want to have installed below
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "pyright",
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
      },
    },
  },
}
