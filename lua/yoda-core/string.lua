-- lua/yoda/core/string.lua
-- String manipulation utilities (extracted from utils.lua for better organization)

local M = {}

-- ============================================================================
-- STRING MANIPULATION
-- ============================================================================

--- Trim whitespace from string
--- @param str string
--- @return string
function M.trim(str)
  if type(str) == "string" then
    return str:match("^%s*(.-)%s*$")
  end
  return ""
end

--- Check if string starts with prefix
--- @param str string
--- @param prefix string
--- @return boolean
function M.starts_with(str, prefix)
  if type(str) == "string" and type(prefix) == "string" then
    return str:sub(1, #prefix) == prefix
  end
  return false
end

--- Check if string ends with suffix
--- @param str string
--- @param suffix string
--- @return boolean
function M.ends_with(str, suffix)
  if type(str) == "string" and type(suffix) == "string" then
    if suffix == "" then
      return true
    end
    return str:sub(-#suffix) == suffix
  end
  return false
end

--- Split string by delimiter
--- @param str string String to split
--- @param delimiter string Delimiter (default: " ")
--- @return table Array of parts
function M.split(str, delimiter)
  if type(str) == "string" then
    delimiter = delimiter or " "
    return vim.split(str, delimiter)
  end
  return {}
end

--- Check if string is empty or whitespace only
--- @param str string
--- @return boolean
function M.is_blank(str)
  if type(str) == "string" and str ~= "" then
    return str:match("^%s*$") ~= nil
  end
  return true
end

--- Get file extension from path
--- @param path string File path
--- @return string Extension without dot, or empty string
function M.get_extension(path)
  if type(path) == "string" then
    local ext = path:match("^.+%.(.+)$")
    return ext or ""
  end
  return ""
end

return M
