local M = {}

M.config = function()
  local status_ok, nls = pcall(require, "null-ls")
  if not status_ok then
    return
  end

  -- you can either config null-ls itself
  nls.config {
    debounce = 150,
    save_after_format = false,
    sources = {
      nls.builtins.formatting.prettier_d_slim, -- prettier
      nls.builtins.diagnostics.eslint_d, -- daemon eslint
      nls.builtins.formatting.stylua, -- lua format
      nls.builtins.diagnostics.luacheck, -- lua lint
      nls.builtins.diagnostics.shellcheck, -- shell lint
      nls.builtins.formatting.shfmt.with { extra_args = { "-i", "2", "-ci" } }, -- shell fmt
      nls.builtins.formatting.goimports, -- go fmt
      nls.builtins.formatting.terraform_fmt, -- terraform fmt
      nls.builtins.diagnostics.hadolint, -- dockerlint
      nls.builtins.diagnostics.markdownlint, -- md lint
    },
  }

  lvim.lang.markdown.linters = {
    {
      exe = "markdownlint",
    },
  }
end

return M
