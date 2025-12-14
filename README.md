# yoda-core.nvim

Core utility library for Neovim plugin development, providing reusable, well-tested foundational modules that eliminate code duplication and enforce best practices.

## Value Proposition

**yoda-core.nvim** solves a critical problem in Neovim plugin development: repeated implementation of common utilities across multiple plugins. By consolidating essential functionality into a single, testable, dependency-injected library, it enables:

- **Faster Plugin Development**: Reuse battle-tested utilities instead of reimplementing basic operations
- **Higher Code Quality**: All modules follow SOLID principles, DRY principles, and maintain low cyclomatic complexity
- **Enhanced Testability**: Dependency injection design allows easy mocking and comprehensive unit testing
- **Cross-Platform Compatibility**: Platform-aware utilities handle Windows, macOS, and Linux differences automatically
- **Consistent APIs**: Uniform error handling and return patterns across all modules

## Core Capabilities

### 1. Caching (`cache.lua`)
High-performance caching system with TTL support for expensive operations.

**Features:**
- Time-to-live (TTL) based expiration (default 150ms, configurable)
- Persistent cache option (never expires)
- Memoization pattern with `get_or_compute`
- Manual invalidation and clearing
- Efficient timestamp-based expiration checking

**Use Cases:**
- Cache file system queries
- Memoize expensive computations
- Reduce redundant API calls
- Optimize repeated data access

### 2. I/O Operations (`io.lua`)
Comprehensive file system and JSON operations with proper error handling.

**Features:**
- **File/Directory Checks**: `is_file()`, `is_dir()`, `exists()`
- **Safe File Reading**: Protected reads with error messages
- **JSON Operations**: Parse and write JSON files with validation
- **Temporary Files**: Create temporary files and directories
- **Error Handling**: Consistent success/error return pattern

**Use Cases:**
- Read configuration files safely
- Parse JSON data with validation
- Create temporary workspaces
- Check file existence before operations

### 3. Platform Detection (`platform.lua`)
Cross-platform utilities for detecting OS and handling paths correctly.

**Features:**
- **OS Detection**: `is_windows()`, `is_macos()`, `is_linux()`, `get_platform()`
- **Path Operations**: Platform-appropriate separators, path joining, normalization
- **Automatic Handling**: Path operations automatically use correct separators

**Use Cases:**
- Write cross-platform plugins
- Handle paths correctly on all systems
- Execute platform-specific logic
- Normalize user-provided paths

### 4. String Utilities (`string.lua`)
Essential string manipulation functions for text processing.

**Features:**
- **Trimming**: Remove leading/trailing whitespace
- **Pattern Matching**: `starts_with()`, `ends_with()` checks
- **Splitting**: Parse delimited strings into arrays
- **Validation**: `is_blank()` for empty/whitespace detection
- **Path Parsing**: Extract file extensions

**Use Cases:**
- Parse user input
- Process file paths
- Validate string data
- Text transformation

### 5. Table Operations (`table.lua`)
Robust table manipulation utilities for Lua data structures.

**Features:**
- **Merging**: Shallow merge with defaults and overrides
- **Deep Copying**: Recursive copy with metatable preservation
- **Validation**: `is_empty()`, `size()` for any table type
- **Searching**: `contains()` for value existence checks

**Use Cases:**
- Merge user configurations with defaults
- Clone data structures safely
- Validate table inputs
- Search collections

## Why Use yoda-core.nvim?

### For Plugin Developers
- **No More Duplication**: Stop rewriting `is_windows()`, `read_file()`, and other common functions
- **Proven Reliability**: Comprehensive unit tests ensure correctness
- **Modern Architecture**: Dependency injection enables easy testing and mocking
- **Consistent Patterns**: All modules follow the same error handling and return conventions

### For Teams
- **Shared Standards**: Common utility library ensures consistent code across plugins
- **Easier Maintenance**: Fix bugs once in the core library, benefit everywhere
- **Faster Onboarding**: New developers learn one set of utilities

### For End Users
- **Better Plugins**: Higher quality plugins built on solid foundations
- **Fewer Bugs**: Well-tested core utilities reduce plugin instability
- **Performance**: Optimized implementations with caching support

## Design Principles

All modules in yoda-core.nvim adhere to:

- **DRY (Don't Repeat Yourself)**: Consolidate common patterns
- **SOLID Principles**: Single responsibility, dependency injection, clear interfaces
- **Low Complexity**: Cyclomatic complexity ≤ 7 per function
- **Type Safety**: Full LuaLS annotations for type checking
- **Testability**: Dependency injection for easy mocking
- **Error Handling**: Consistent success/error return patterns

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "jedi-knights/yoda-core.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("yoda-core").setup({
      use_di = false,
    })
  end,
}
```

Using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use {
  "jedi-knights/yoda-core.nvim",
  requires = { "nvim-lua/plenary.nvim" },
  config = function()
    require("yoda-core").setup({
      use_di = false,
    })
  end,
}
```

## Usage

### Basic Usage (Recommended)

```lua
local yoda = require("yoda-core")

local cache = yoda.cache({ ttl_ms = 5000 })
local io = yoda.io()
local platform = yoda.platform()

local function get_config(path)
  return cache:get_or_compute(path, function()
    local ok, config = io.parse_json_file(path)
    return ok and config or {}
  end)
end

local config_path = platform.join_path(vim.fn.stdpath("config"), "settings.json")
local config = get_config(config_path)
```

### Direct Module Usage

You can also require modules directly without the centralized setup:

```lua
local cache = require("yoda-core.cache")
local io = require("yoda-core.io")
local platform = require("yoda-core.platform")

local file_cache = cache.new({ ttl_ms = 5000 })
local ok, data = io.parse_json_file("config.json")
local is_win = platform.is_windows()
```

### Dependency Injection (Advanced)

Enable DI mode for maximum testability:

```lua
require("yoda-core").setup({
  use_di = true,
  dependencies = {
    plenary_path = true,
  },
})

local yoda = require("yoda-core")
local io = yoda.io()
```

## Configuration

### Setup Options

```lua
require("yoda-core").setup({
  use_di = false,
  dependencies = {},
})
```

**Options:**

- `use_di` (boolean, default: `false`): Enable dependency injection mode for all modules
- `dependencies` (table, default: `{}`): Dependencies to inject into DI-enabled modules
  - `plenary_path` (boolean): Inject plenary.path for advanced file operations

### Configuration Examples

**Default Configuration (Direct Module Access):**
```lua
require("yoda-core").setup()
```

**Dependency Injection Mode (For Testing):**
```lua
require("yoda-core").setup({
  use_di = true,
  dependencies = {
    plenary_path = true,
  },
})
```

## Requirements

- Neovim >= 0.8.0
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)

## Migration Guide

### From Direct Requires to Centralized Setup

**Before (still supported):**
```lua
local cache = require("yoda-core.cache")
local io = require("yoda-core.io")
local platform = require("yoda-core.platform")

local file_cache = cache.new({ ttl_ms = 5000 })
```

**After (recommended):**
```lua
local yoda = require("yoda-core")
yoda.setup()

local cache = yoda.cache({ ttl_ms = 5000 })
local io = yoda.io()
local platform = yoda.platform()
```

### Benefits of Centralized Setup

1. **Consistent API**: All modules follow the same access pattern
2. **Easy DI Configuration**: Toggle between direct and DI modes globally
3. **Future-Proof**: New features can be added through setup options
4. **Backward Compatible**: Direct requires still work as before

## Testing

```bash
make test
```

## License

MIT License
