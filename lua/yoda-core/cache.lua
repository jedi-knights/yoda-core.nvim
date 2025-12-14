-- lua/yoda/core/cache.lua
-- Reusable caching utility with TTL support

local M = {}

--- Create a new cache instance with TTL support
--- @param opts table|nil Options: { ttl_ms: number, weak: boolean }
--- @return table Cache instance
function M.new(opts)
  opts = opts or {}
  
  -- Use weak tables for automatic garbage collection
  local weak_mode = opts.weak ~= false and "kv" or nil
  local cache = {
    data = weak_mode and setmetatable({}, { __mode = weak_mode }) or {},
    timestamps = {},
    ttl_ms = opts.ttl_ms or 150, -- Default 150ms TTL
  }

  --- Get value from cache
  --- @param key string Cache key
  --- @return any|nil Cached value or nil if expired/missing
  function cache:get(key)
    if type(key) ~= "string" then
      return nil
    end

    local value = self.data[key]
    if value == nil then
      return nil
    end

    -- Check if expired
    local timestamp = self.timestamps[key]
    if timestamp then
      local current_time = vim.loop.hrtime() / 1000000 -- Convert to ms
      if (current_time - timestamp) >= self.ttl_ms then
        -- Expired, remove from cache
        self.data[key] = nil
        self.timestamps[key] = nil
        return nil
      end
    end

    return value
  end

  --- Set value in cache
  --- @param key string Cache key
  --- @param value any Value to cache
  function cache:set(key, value)
    if type(key) ~= "string" then
      return
    end

    self.data[key] = value
    self.timestamps[key] = vim.loop.hrtime() / 1000000 -- Current time in ms
  end

  --- Invalidate specific cache entry
  --- @param key string Cache key
  function cache:invalidate(key)
    if type(key) ~= "string" then
      return
    end

    self.data[key] = nil
    self.timestamps[key] = nil
  end

  --- Clear all cache entries
  function cache:clear()
    local weak_mode = opts.weak ~= false and "kv" or nil
    self.data = weak_mode and setmetatable({}, { __mode = weak_mode }) or {}
    self.timestamps = {}
  end

  --- Check if key exists and is not expired
  --- @param key string Cache key
  --- @return boolean
  function cache:has(key)
    return self:get(key) ~= nil
  end

  --- Get or compute value (memoization pattern)
  --- @param key string Cache key
  --- @param compute_fn function Function to compute value if not cached
  --- @return any Cached or computed value
  function cache:get_or_compute(key, compute_fn)
    local cached = self:get(key)
    if cached ~= nil then
      return cached
    end

    local value = compute_fn()
    self:set(key, value)
    return value
  end

  return cache
end

--- Create a simple cache without TTL (never expires)
--- @return table Cache instance
function M.new_persistent()
  return M.new({ ttl_ms = math.huge })
end

return M
