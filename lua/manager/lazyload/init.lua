---@alias Manager.LazyloadKey fun(self: Manager, mode: string|string[], lhs: string, rhs: string|function, plugin_id: string, opts?: table)
---@alias Manager.LazyloadEvent fun(self: Manager, event_name: string|string[], plugin_id: string, pattern?: string|string[])

---@class Manager
---@field lazyload_key Manager.LazyloadKey
---@field lazyload_event Manager.LazyloadEvent

---@type Manager.LazyloadKey
local function key(self, mode, lhs, rhs, plugin_id, opts)
	vim.keymap.set(mode, lhs, function()
		self:load(plugin_id)
		vim.keymap.set(mode, lhs, rhs, opts)
		if type(rhs) == "string" then
			local keys = vim.api.nvim_replace_termcodes(rhs, true, false, true)
			vim.api.nvim_feedkeys(keys, "n", true)
		else
			rhs()
		end
	end, opts)
end

---@type Manager.LazyloadEvent
local function event(self, event_name, plugin_id, pattern)
	vim.api.nvim_create_autocmd(event_name, {
		group = vim.api.nvim_create_augroup(plugin_id .. "_load", { clear = true }),
		pattern = pattern or "*",
		once = true,
		callback = function()
			self:load(plugin_id)
		end,
	})
end

local M = {}

---@param manager Manager
function M.setup(manager)
	manager.lazyload_key = key
	manager.lazyload_event = event
end

return M
