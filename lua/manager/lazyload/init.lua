local M = {}

local manager = require("manager.core")

function M.key(mode, lhs, rhs, plugin_id, opts)
    vim.keymap.set(
        mode, lhs,
        function()
            manager.load(plugin_id)
            vim.keymap.set(mode, lhs, rhs, opts)
            if type(rhs) == "string" then
                local keys = vim.api.nvim_replace_termcodes(rhs, true, false, true)
                vim.api.nvim_feedkeys(keys, 'n', true)
            else
                rhs()
            end
        end,
        opts
    )
end

function M.event(event_name, plugin_id, pattern)
    vim.api.nvim_create_autocmd(event_name, {
        group = vim.api.nvim_create_augroup(plugin_id .. "_load", { clear = true }),
        pattern = pattern or "*",
        callback = function()
            manager.load(plugin_id)
        end
    })
    return M
end

return M
