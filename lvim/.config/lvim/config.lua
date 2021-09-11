-- General
lvim.transparent_window = false
lvim.format_on_save = true
lvim.lint_on_save = true
lvim.leader = "space"
lvim.colorscheme = "onedarker"

-- Default Options
vim.opt.clipboard = ""
vim.opt.relativenumber = true
vim.opt.timeoutlen = 200
vim.o.inccommand = "split"

-- LSP
lvim.lsp.diagnostics.virtual_text = false -- "gl" to show diagnostics for each error
require("user.json_schemas").setup()

-- Treesitter
lvim.builtin.treesitter.ensure_installed = "maintained"
lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true
lvim.builtin.treesitter.autotag.enable = true

-- Builtin
lvim.builtin.nvimtree.hide_dotfiles = 0
lvim.builtin.dashboard.active = true
lvim.builtin.terminal.active = true
lvim.builtin.dap.active = true
lvim.builtin.telescope.defaults.path_display = {}
lvim.builtin.telescope.defaults.mappings = {
  i = {
    ["<esc>"] = require("telescope.actions").close,
  },
}

-- Additional Plugins
lvim.plugins = {
  { "lunarvim/colorschemes" },
  { "tpope/vim-surround" },
  {
    "folke/tokyonight.nvim",
    config = function()
      vim.g.tokyonight_style = "night"
    end,
  },
  -- Show method signature when entering text
  {
    "ray-x/lsp_signature.nvim",
    config = function()
      require("user/lsp_signature").config()
    end,
    event = "InsertEnter",
  },
  -- Match text with % like if/else
  {
    "andymass/vim-matchup",
    event = "CursorMoved",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  {
    "bkad/CamelCaseMotion",
    config = function()
      vim.g.camelcasemotion_key = ","
    end,
  },
  -- Add sneak like motion and extends f to show next occurrence
  {
    "ggandor/lightspeed.nvim",
    event = "BufRead",
  },
  -- auto close/rename html tags
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
  },
  -- really nice quickfix with preview
  {
    "kevinhwang91/nvim-bqf",
    event = "BufRead",
  },
  {
    "sindrets/diffview.nvim",
    cmd = "DiffviewOpen",
  },
  -- run diagnostics summary
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  -- Show outline of all the symbols in the sidebar
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    setup = function()
      require "user.indent_blankline"
    end,
  },
  {
    "dhruvasagar/vim-zoom",
  },
  {
    "kevinhwang91/rnvimr",
    config = function()
      -- Make Ranger replace netrw and be the file explorer
      -- vim.g.rnvimr_ex_enable = 1
      vim.g.rnvimr_draw_border = 1
      vim.g.rnvimr_pick_enable = 1
      vim.g.rnvimr_bw_enable = 1
      vim.api.nvim_set_keymap("n", "-", ":RnvimrToggle<CR>", { noremap = true, silent = true })
    end,
  },
  -- Search/replace panel
  {
    "windwp/nvim-spectre",
    event = "BufRead",
    config = function()
      require("user.spectre").config()
    end,
  },
  -- file exporer
  {
    "tamago324/lir.nvim",
    config = function()
      require "user.lir"
    end,
  },
  -- todo comments styles
  {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup()
    end,
    event = "BufRead",
  },

  -- colorize colors
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      local status_ok, colorizer = pcall(require, "colorizer")
      if not status_ok then
        return
      end

      colorizer.setup({ "*" }, {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
      })
    end,
  },

  -- Running unit tests
  {
    "vim-test/vim-test",
    cmd = { "TestNearest", "TestFile", "TestSuite", "TestLast", "TestVisit" },
    config = function()
      vim.cmd [[
          function! ToggleTermStrategy(cmd) abort
            call luaeval("require('toggleterm').exec(_A[1])", [a:cmd])
          endfunction
          let g:test#custom_strategies = {'toggleterm': function('ToggleTermStrategy')}
        ]]
      vim.g["test#strategy"] = "toggleterm"
    end,
  },

  -- package.json packages info
  {
    "vuki656/package-info.nvim",
    config = function()
      require("package-info").setup {
        {
          colors = {
            up_to_date = "#3C4048", -- Text color for up to date package virtual text
            outdated = "#6ec0fa", -- Text color for outdated package virtual text
          },
          icons = {
            enable = true, -- Whether to display icons
            style = {
              up_to_date = "|  ", -- Icon for up to date packages
              outdated = "|  ", -- Icon for outdated packages
            },
          },
          autostart = true, -- Whether to autostart when `package.json` is opened
        },
      }
    end,
    ft = "json",
  },
}

require("user.keybindings").config()
