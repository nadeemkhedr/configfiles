O.format_on_save = true
O.lint_on_save = true
O.completion.autocomplete = true
O.colorscheme = "spacegray"
O.default_options.wrap = true
O.default_options.timeoutlen = 100
-- keymappings
O.keys.leader_key = "space"

O.plugin.dashboard.active = true
O.plugin.terminal.active = true

-- if you don't want all the parsers change this to a table of the ones you want
O.treesitter.ensure_installed = "maintained"
O.treesitter.ignore_install = { "haskell" }
O.treesitter.highlight.enabled = true


-- python
O.lang.python.diagnostics.virtual_text = true
O.lang.python.analysis.use_library_code_types = true

-- javascript
O.lang.tsserver.linter = "eslint"


-- Custom

-- telescope
O.plugin.telescope.defaults.path_display = {}
O.plugin.telescope.defaults.mappings = {
	i = {
		["<esc>"] = require('telescope.actions').close,
	},
}

O.user_plugins = {
	{
		"ruifm/gitlinker.nvim",
		event = "BufRead",
		config = function()
			require("gitlinker").setup({
				opts = {
					-- remote = 'github', -- force the use of a specific remote
					-- adds current line nr in the url for normal mode
					add_current_line_on_normal_mode = true,
					-- callback for what to do with the url
					action_callback = require("gitlinker.actions").open_in_browser,
					-- print the url after performing the action
					print_url = false,
					-- mapping to call url generation
					mappings = "<leader>gy",
				},
			})
		end,
		requires = "nvim-lua/plenary.nvim",
	},
}
O.plugin.which_key.mappings["gy"] = "Gitlinker"

O.default_options.relativenumber = true
O.default_options.hlsearch = true

-- Easy colon, shift not needed
vim.api.nvim_set_keymap("n", ";", ":", { noremap = true })
vim.api.nvim_set_keymap("v", ";", ":", { noremap = true })
vim.api.nvim_set_keymap("n", ":", ";", { noremap = true })
vim.api.nvim_set_keymap("v", ":", ";", { noremap = true })

O.user_which_key = {
	v = { "<cmd>vsplit<CR>", "split right" },
	x = { "<cmd>close<CR>", "close pane" },
  o = {
    name = "+Open",
    z = { "<cmd>e ~/.config/zsh/zshrc<cr>", "open zshrc" },
    v = { "<cmd>e ~/.config/nvim/lv-config.lua<cr>", "open lv-config" },
  },
}
