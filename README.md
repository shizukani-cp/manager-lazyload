# manager-lazyload

Lazy loading extension for [manager.nvim](https://github.com/shizukani-cp/manager.nvim).

## 🚀 Features

- **Keymap Lazy Loading**: Load plugins only when you hit a specific key.
- **Event Lazy Loading**: Load plugins based on Neovim events (Autocmd).
- **Simple Integration**: Injects methods directly into the `manager` instance.

## 📦 Installation

Use [manager.nvim](https://github.com/shizukani-cp/manager.nvim) (or any other manager):

```lua
manager:add({
    id = "manager-lazyload",
    url = "https://github.com/shizukani-cp/manager-lazyload",
})
```

## 🛠️ Setup

You need to pass your manager instance to the `setup` function:

```lua
local manager = require("manager.core").new()
require("manager.lazyload").setup(manager)
```

## 📖 Usage

After setup, you can use these methods on your `manager` instance.

### Keymap Lazy Loading

```lua
manager:lazyload_key("n", "<leader>ff", "Telescope find_files", "telescope.nvim")
```

### Event Lazy Loading

```lua
manager:lazyload_event("BufReadPost", "nvim-treesitter", "*.lua")
```

## 📄 License

MIT
