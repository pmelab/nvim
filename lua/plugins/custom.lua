local util = require("lspconfig/util")

local function silverback_drupal_root(cwd)
  local root = util.root_pattern({ "pnpm-lock.yaml" })(cwd)
  if root and vim.fn.filereadable(root .. "/apps/silverback-drupal/composer.json") then
    return root .. "/apps/silverback-drupal"
  end
  if root and vim.fn.filereadable(root .. "/apps/website/composer.json") then
    return root .. "/apps/website"
  end
  return "/Users/pmelab/Code/silverback-mono/apps/silverback-drupal"
end

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      integrations = {
        alpha = true,
        cmp = true,
        flash = true,
        gitsigns = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        lsp_trouble = true,
        mason = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        noice = true,
        notify = true,
        neotree = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        which_key = true,
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "graphql-language-service-cli",
        "php-debug-adapter",
      },
    },
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "marilari88/neotest-vitest",
      "olimorris/neotest-phpunit",
    },
    keys = {
      {
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Run last test",
      },
    },
    opts = {
      adapters = {
        "neotest-vitest",
        ["neotest-phpunit"] = {
          root_files = { ".git" },
          phpunit_cmd = function()
            return {
              silverback_drupal_root(vim.loop.cwd()) .. "/vendor/bin/phpunit",
              "-c",
              silverback_drupal_root(vim.loop.cwd()) .. "/phpunit.xml.dist",
            }
          end,
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "http",
        "graphql",
        "php",
      },
    },
  },
  {
    "rest-nvim/rest.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>tc", "<Plug>RestNvim", desc = "Run request under cursor" },
    },
    init = function()
      require("rest-nvim").setup({
        -- Open request results in a horizontal split
        result_split_horizontal = false,
        -- Keep the http file buffer above|left when split horizontal|vertical
        result_split_in_place = false,
        -- Skip SSL verification, useful for unknown certificates
        skip_ssl_verification = false,
        -- Encode URL before making request
        encode_url = true,
        -- Highlight request on run
        highlight = {
          enabled = true,
          timeout = 150,
        },
        result = {
          -- toggle showing URL, HTTP info, headers at top the of result window
          show_url = true,
          -- show the generated curl command in case you want to launch
          -- the same request via the terminal (can be verbose)
          show_curl_command = false,
          show_http_info = true,
          show_headers = true,
          -- executables or functions for formatting response body [optional]
          -- set them to false if you want to disable them
          formatters = {
            json = "jq",
            html = function(body)
              return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
            end,
          },
        },
        -- Jump to request line on run
        jump_to_request = false,
        env_file = ".env",
        custom_dynamic_variables = {},
        yank_dry_run = true,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        phpactor = {
          root_dir = function(cwd)
            return silverback_drupal_root(cwd)
          end,
        },
      },
    },
  },
}
