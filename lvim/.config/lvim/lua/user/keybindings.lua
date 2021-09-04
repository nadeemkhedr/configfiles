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

  -- Moving text with formating
  vim.api.nvim_set_keymap("v", "J", ":m '>+1<CR>gv=gv", { noremap = true })
  vim.api.nvim_set_keymap("v", "K", ":m '<-2<CR>gv=gv", { noremap = true })
  vim.api.nvim_set_keymap("i", "<C-j>", "<esc>:m .+1<CR>==a", { noremap = true })
  vim.api.nvim_set_keymap("i", "<C-k>", "<esc>:m .-2<CR>==a", { noremap = true })

  -- Easy colon, shift not needed
  vim.api.nvim_set_keymap("n", ";", ":", { noremap = true })
  vim.api.nvim_set_keymap("v", ";", ":", { noremap = true })
  vim.api.nvim_set_keymap("n", ":", ";", { noremap = true })
  vim.api.nvim_set_keymap("v", ":", ";", { noremap = true })

  -- splitv go to def
  lvim.keys.normal_mode["gv"] = "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>"

  -- Whichkey

  -- Move packer keys to 'P', and update 'p' to paste from clipboard
  lvim.builtin.which_key.mappings["P"] = lvim.builtin.which_key.mappings["p"]
  lvim.builtin.which_key.mappings["p"] = { '"+p', "paste from clipboard" }
  lvim.builtin.which_key.mappings["p"] = { '"+p', "paste from clipboard" }
  lvim.builtin.which_key.mappings["y"] = {
    name = "+yank",
    y = { '"+y', "yank to clipboard" },
  }
  lvim.builtin.which_key.vmappings["y"] = { '"+y', "yank to clipboard" }

  lvim.builtin.which_key.mappings["a"] = {
    name = "+Actions",
    l = { "<cmd>IndentBlanklineToggle<cr>", "Toggle Indent line" },
  }
  lvim.builtin.which_key.mappings["F"] = { "<cmd>Telescope git_files<CR>", "find git files" }
  lvim.builtin.which_key.mappings["v"] = { "<cmd>vsplit<CR>", "split right" }
  lvim.builtin.which_key.mappings["x"] = { "<cmd>close<CR>", "close pane" }
  lvim.builtin.which_key.mappings["z"] = { "<cmd>call zoom#toggle()<CR>", "zoom" }
  lvim.builtin.which_key.mappings.l.d = { "<cmd>TroubleToggle<cr>", "Diagnostics" }
  lvim.builtin.which_key.mappings.l.R = { "<cmd>TroubleToggle lsp_references<cr>", "References" }
  lvim.builtin.which_key.mappings.l.o = { "<cmd>SymbolsOutline<cr>", "Outline" }
  lvim.builtin.which_key.mappings["r"] = {
    name = "Replace",
    r = { "<cmd>lua require('spectre').open()<cr>", "Replace" },
    w = { "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", "Replace Word" },
    f = { "<cmd>lua require('spectre').open_file_search()<cr>", "Replace Buffer" },
  }
  lvim.builtin.which_key.mappings["o"] = {
    name = "+Open",
    c = { "<cmd>e ~/configfiles/README.md<cr>", "open configfiles" },
    z = { "<cmd>e ~/.config/zsh/zshrc<cr>", "open zshrc" },
    v = { "<cmd>e ~/.config/lvim/lv-config.lua<cr>", "open lv-config" },
    s = { "<cmd>e ~/.local/share/lunarvim/lvim/init.lua<cr>", "open lvim core project" },
  }
  lvim.builtin.which_key.mappings["."] = { "<cmd>lua require('lir.float').toggle()<cr>", "Files" }
end

return M
