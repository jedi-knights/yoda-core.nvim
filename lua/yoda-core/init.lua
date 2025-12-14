local M = {}

local _is_setup = false
local _module_cache = {}

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

local function lazy_load_module(module_name, module_name_di, create_new)
  return function(deps_or_opts)
    local cache_key = M._config.use_di and module_name_di or module_name
    
    if not _module_cache[cache_key] then
      local mod = require(cache_key)
      if not create_new then
        _module_cache[cache_key] = mod
      else
        return create_new(mod, deps_or_opts)
      end
    end
    
    return _module_cache[cache_key]
  end
end

M.cache = lazy_load_module("yoda-core.cache", nil, function(mod, opts)
  return mod.new(opts)
end)

M.io = lazy_load_module("yoda-core.io", "yoda-core.io_di", function(mod, deps)
  if M._config.use_di then
    return mod.new(deps or M._config.dependencies)
  end
  return mod
end)

M.platform = lazy_load_module("yoda-core.platform", "yoda-core.platform_di", function(mod, deps)
  if M._config.use_di then
    return mod.new(deps or M._config.dependencies)
  end
  return mod
end)

M.string = lazy_load_module("yoda-core.string", "yoda-core.string_di", function(mod, deps)
  if M._config.use_di then
    return mod.new(deps or M._config.dependencies)
  end
  return mod
end)

M.table = lazy_load_module("yoda-core.table", "yoda-core.table_di", function(mod, deps)
  if M._config.use_di then
    return mod.new(deps or M._config.dependencies)
  end
  return mod
end)

return M
