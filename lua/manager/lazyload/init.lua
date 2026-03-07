---@alias Manager.LazyloadKey fun(self: Manager, mode: string|string[], lhs: string, rhs: string|function, plugin_id: string, opts?: table)
---@alias Manager.LazyloadEvent fun(self: Manager, event_name: string|string[], plugin_id: string, pattern?: string|string[])
---@alias Manager.LazyloadFileType fun(self: Manager, filetype: string|string[], plugin_id: string)
---@alias Manager.LazyloadCommand fun(self: Manager, command: string|string[], plugin_id: string)

---@class Manager
---@field lazyload_key Manager.LazyloadKey
---@field lazyload_event Manager.LazyloadEvent
---@field lazyload_filetype Manager.LazyloadFileType
---@field lazyload_command Manager.LazyloadCommand

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

---@type Manager.LazyloadFileType
local function filetype(self, ft, plugin_id)
    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup(plugin_id .. "_load_filetype", { clear = true }),
        pattern = ft,
        callback = function()
            self:load(plugin_id)
        end,
    })
end

---@type fun(self: Manager, cmd: string, plugin_id: string)
local function create_cmd(self, cmd, plugin_id)
    vim.api.nvim_create_user_command(cmd, function(opts)
        vim.api.nvim_del_user_command(cmd)
        self:load(plugin_id)
        local command_str = string.format("%s%s %s", opts.bang and "!" or "", cmd, opts.args or "")
        vim.cmd(command_str)
    end, { bang = true, nargs = "*" })
end

---@type Manager.LazyloadCommand
local function command(self, cmd, plugin_id)
    if type(cmd) == "string" then
        create_cmd(self, cmd, plugin_id)
    elseif type(cmd) == "table" then
        for _, c in ipairs(cmd) do
            create_cmd(self, c, plugin_id)
        end
    end
end

local M = {}

---@param manager Manager
function M.setup(manager)
    manager.lazyload_key = key
    manager.lazyload_event = event
    manager.lazyload_filetype = filetype
    manager.lazyload_command = command
end

return M
