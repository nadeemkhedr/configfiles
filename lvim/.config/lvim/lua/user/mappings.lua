local M = {}

M.config = function()
  -- keymappings
  lvim.leader = "space"
  lvim.keys.normal_mode["<esc><esc>"] = "<cmd>nohlsearch<cr>"
  lvim.keys.normal_mode["Y"] = "y$"
  lvim.keys.visual_mode["p"] = [["_dP]]

  -- n/N always center
  vim.api.nvim_set_keymap("n", "n", "nzzzv", { noremap = true })
  vim.api.nvim_set_keymap("n", "N", "Nzzzv", { noremap = true })

  -- Undo break points
  vim.api.nvim_set_keymap("i", ",", ",<c-g>u", { noremap = true })
  vim.api.nvim_set_keymap("i", ".", ".<c-g>u", { noremap = true })
  vim.api.nvim_set_keymap("i", "!", "!<c-g>u", { noremap = true })
  vim.api.nvim_set_keymap("i", "?", "?<c-g>u", { noremap = true })
  vim.api.nvim_set_keymap("i", "[", "[<c-g>u", { noremap = true })

  -- Easy colon, shift not needed
  vim.api.nvim_set_keymap("n", ";", ":", { noremap = true })
  vim.api.nvim_set_keymap("v", ";", ":", { noremap = true })
  vim.api.nvim_set_keymap("n", ":", ";", { noremap = true })
  vim.api.nvim_set_keymap("v", ":", ";", { noremap = true })

  -- remove alt j/k, doesn't play well in macos, when pressing esc-j/k quickly they do the mapping
  lvim.keys.normal_mode["<A-j>"] = nil
  lvim.keys.normal_mode["<A-k>"] = nil

  lvim.keys.insert_mode["<A-j>"] = nil
  lvim.keys.insert_mode["<A-k>"] = nil

  -- splitv go to def
  lvim.keys.normal_mode["gv"] = "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>"

  -- harpoon
  lvim.keys.normal_mode["<C-Space>"] = "<cmd>lua require('harpoon.cmd-ui').toggle_quick_menu()<CR>"

  -- Whichkey

  -- Move packer keys to 'P', and update 'p' to paste from clipboard
  lvim.builtin.which_key.mappings["P"] = lvim.builtin.which_key.mappings["p"]
  lvim.builtin.which_key.mappings["p"] = { '"+p', "paste from clipboard" }
  lvim.builtin.which_key.mappings["p"] = { '"+p', "paste from clipboard" }

  local function clip()
    require("telescope").extensions.neoclip.default(require("telescope.themes").get_dropdown())
  end
  lvim.builtin.which_key.mappings["y"] = {
    name = "+yank",
    y = { '"+y', "yank to clipboard" },
    l = { clip, "neoclip: open yank history" },
  }
  lvim.builtin.which_key.vmappings["y"] = { '"+y', "yank to clipboard" }

  lvim.builtin.which_key.mappings["a"] = {
    name = "+Actions",
    l = { "<cmd>IndentBlanklineToggle<cr>", "Toggle Indent line" },
  }

  -- overwrite the find files command to search for git then files
  lvim.builtin.which_key.mappings["f"] = { "<cmd>lua require('user.telescope').project_files()<cr>", "Find Git/File" }
  lvim.builtin.which_key.mappings["v"] = { "<cmd>vsplit<CR>", "split right" }
  lvim.builtin.which_key.mappings["x"] = { "<cmd>close<CR>", "close pane" }
  lvim.builtin.which_key.mappings.l.d = { "<cmd>Trouble<cr>", "Diagnostics" }
  lvim.builtin.which_key.mappings.l.R = { "<cmd>TroubleToggle lsp_references<cr>", "References" }
  lvim.builtin.which_key.mappings.l.o = { "<cmd>SymbolsOutline<cr>", "Outline" }
  lvim.builtin.which_key.mappings["r"] = {
    name = "+Replace",
    r = { "<cmd>lua require('spectre').open()<cr>", "Replace" },
    w = { "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", "Replace Word" },
    f = { "<cmd>lua require('spectre').open_file_search()<cr>", "Replace Buffer" },
  }
  lvim.builtin.which_key.mappings["o"] = {
    name = "+Open",
    e = { "<cmd>lua require('user.utils').open_env_file()<cr>", "open env file" },
    c = { "<cmd>e ~/configfiles/README.md<cr>", "open configfiles" },
    z = { "<cmd>e ~/.config/zsh/zshrc<cr>", "open zshrc" },
    v = { "<cmd>e ~/.config/lvim/lv-config.lua<cr>", "open lv-config" },
    s = { "<cmd>e ~/.local/share/lunarvim/lvim/init.lua<cr>", "open lvim core project" },
  }
  lvim.builtin.which_key.mappings["t"] = {
    name = " +Test",
    f = { "<cmd>TestFile<cr>", "File" },
    n = { "<cmd>TestNearest<cr>", "Nearest" },
    s = { "<cmd>TestSuite<cr>", "Suite" },
  }

  lvim.builtin.which_key.mappings["n"] = {
    name = "+Work",
    t = { "<cmd>lua require('user.telescope').work_studio_lib()<cr>", "Studio lib files" },
    s = { "<cmd>lua require('user.telescope').work_studio_deployment()<cr>", "Studio deployment files" },
  }
end

return M
