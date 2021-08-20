-- lvim.lsp.diagnostics.virtual_text = false "gl" to show diagnostics

-- if you don't want all the parsers change this to a table of the ones you want

-- General
lvim.transparent_window = false
lvim.format_on_save = true
lvim.lint_on_save = true
lvim.leader = "space"
lvim.colorscheme = "tokyonight"

-- Default Options
vim.opt.relativenumber = true
vim.opt.timeoutlen = 200

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

local components = require "core.lualine.components"
lvim.builtin.lualine.sections.lualine_c = {
  components.diff,
  "filename",
}
-- lvim.builtin.lualine.sections.lualine_b = { "filename" }
-- lvim.builtin.lualine.on_config_done = function()
-- end

-- Additional Plugins
lvim.plugins = {
  { "lunarvim/colorschemes" },
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
      require("lsp_signature").on_attach()
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
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    setup = function()
      vim.g.indentLine_enabled = 1
      vim.g.indent_blankline_char = "▏"
      vim.g.indent_blankline_filetype_exclude = {
        "help",
        "terminal",
        "dashboard",
      }
      vim.g.indent_blankline_buftype_exclude = { "terminal" }
      vim.g.indent_blankline_show_trailing_blankline_indent = false
      vim.g.indent_blankline_show_first_indent_level = true
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
  {
    "windwp/nvim-spectre",
    event = "BufRead",
    config = function()
      require("user.spectre").config()
    end,
  },
  {
    "tamago324/lir.nvim",
    config = function()
      require "user.lir"
    end,
  },
}

require("user.keybindings").config()