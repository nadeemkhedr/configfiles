local M = {}

M.toggle_quickfix = function()
  local qf_open = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win["quickfix"] == 1 then
      qf_open = true
    end
  end
  if qf_open == true then
    vim.cmd "cclose"
    return
  end
  if not vim.tbl_isempty(vim.fn.getqflist()) then
    vim.cmd "copen"
  end
end

M.open_env_file = function()
  local dir = vim.fn.finddir(".git/..", vim.fn.expand "%:p:h" .. ";")
  local file = vim.fn.findfile(".env", dir)
  vim.cmd("e " .. vim.fn.fnameescape(file))
end

return M
