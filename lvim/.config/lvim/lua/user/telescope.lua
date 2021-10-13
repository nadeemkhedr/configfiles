local M = {}

local builtin = require "telescope.builtin"

M.project_files = function()
  local opts = {} -- define here if you want to define something
  local ok = pcall(builtin.git_files, opts)
  if not ok then
    builtin.find_files(opts)
  end
end

M.work_studio_deployment = function()
  builtin.find_files { cwd = "~/work/screencastify/castify/deployments/client/studio" }
end

M.work_studio_lib = function()
  builtin.find_files { cwd = "~/work/screencastify/castify/lib/studio" }
end

return M
