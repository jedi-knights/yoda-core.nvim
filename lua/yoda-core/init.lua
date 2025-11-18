local M = {}

local _is_setup = false

M._config = {
  use_di = false,
  dependencies = {},
}

function M.setup(opts)
  if _is_setup then
    vim.notify("yoda-core.nvim: setup() called multiple times", vim.log.levels.WARN)
    return
  end

  opts = opts or {}
  M._config = vim.tbl_deep_extend("force", M._config, opts)
  _is_setup = true
end

function M.cache(opts)
  return require("yoda-core.cache").new(opts)
end

function M.io(deps)
  if M._config.use_di then
    return require("yoda-core.io_di").new(deps or M._config.dependencies)
  end
  return require("yoda-core.io")
end

function M.platform(deps)
  if M._config.use_di then
    return require("yoda-core.platform_di").new(deps or M._config.dependencies)
  end
  return require("yoda-core.platform")
end

function M.string(deps)
  if M._config.use_di then
    return require("yoda-core.string_di").new(deps or M._config.dependencies)
  end
  return require("yoda-core.string")
end

function M.table(deps)
  if M._config.use_di then
    return require("yoda-core.table_di").new(deps or M._config.dependencies)
  end
  return require("yoda-core.table")
end

return M
