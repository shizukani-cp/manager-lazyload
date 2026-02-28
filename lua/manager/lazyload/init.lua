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

function M.setup(manager)
	manager.lazyload_key = key
	manager.lazyload_event = event
end

return M
