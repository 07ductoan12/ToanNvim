local M = {}

local lazy_clipboard

function M.setup()
	-- Autocmds can be loaded lazily when not opening a file
	local lazy_autocmds = vim.fn.argc(-1) == 0
	if not lazy_autocmds then
		M.load('autocmds')
	end

	local group = vim.api.nvim_create_augroup('ToanVim', { clear = true })
	vim.api.nvim_create_autocmd('User', {
		group = group,
		pattern = 'VeryLazy',
		callback = function()
			if lazy_autocmds then
				M.load('autocmds')
			end
			M.load('keymaps')
			if lazy_clipboard ~= nil then
				vim.opt.clipboard = lazy_clipboard
			end
		end,
	})
end

---@param name 'autocmds' | 'options' | 'keymaps'
function M.load(name)
	local function _load(mod)
		if require('lazy.core.cache').find(mod)[1] then
			LazyVim.try(function()
				require(mod)
			end, { msg = 'Failed loading ' .. mod })
		end
	end
	_load('config.' .. name)
	if vim.bo.filetype == 'lazy' then
		vim.cmd([[do VimResized]])
	end
	local pattern = 'ToanVim' .. name:sub(1, 1):upper() .. name:sub(2)

	vim.api.nvim_exec_autocmds('User', { pattern = pattern, modeline = false })
end

-- This is the main entry-point once lazy.nvim is set-up.
M.did_init = false
function M.init()
	if M.did_init then
		return
	end
	M.did_init = true
	local plugin = require('lazy.core.config').spec.plugins.LazyVim
	if plugin then
		vim.opt.rtp:append(plugin.dir)
	end

	-- This is premature by purpose, to load the LazyVim global.
	local LazyVimConfig = require('lazyvim.config')

	-- Delay notifications till vim.notify was replaced or after 500ms
	LazyVim.lazy_notify()

	-- Load options here, before lazy init while sourcing plugin modules
	-- this is needed to make sure options will be correctly applied
	-- after installing missing plugins
	M.load('options')

	-- Defer built-in clipboard handling: "xsel" and "pbcopy" can be slow
	lazy_clipboard = vim.opt.clipboard
	vim.opt.clipboard = ''

	LazyVim.plugin.setup()
	LazyVimConfig.json.load()

	-- Add lua/*/plugins/extras as list of "extra" sources
	LazyVim.extras.sources = {
		{
			name = 'LazyVim',
			desc = 'LazyVim extras',
			module = 'lazyvim.plugins.extras',
		},
		{
			name = 'User ',
			desc = 'User extras',
			module = 'plugins.extras',
		},
	}
end

return M
