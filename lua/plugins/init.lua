if vim.fn.has('nvim-0.9.0') == 0 then
	vim.api.nvim_echo({
		{ 'Upgrade to Neovim >= 0.10.0 for the best experience.\n', 'ErrorMsg' },
		{ 'Press any key to exit', 'MoreMsg' },
	}, true, {})
	vim.fn.getchar()
	vim.cmd([[quit]])
	return {}
end

require('config.init').init()

local M

M = {

	-- Modern plugin manager for Neovim
	{ 'folke/lazy.nvim', version = '*' },

	-- Lua functions library
	{ 'nvim-lua/plenary.nvim', lazy = false },

	-- leetcode
	{
		'kawre/leetcode.nvim',
		cmd = 'Leet',
		opts = {
			-- configuration goes here
		},
	},

	-- liveserver
	{
		'aurum77/live-server.nvim',
		lazy = true,
		build = ':LiveServerInstall',
		cmd = 'LiveServer',
	},
}

if ConfigVariable.util.rest then
	table.insert(M, { import = 'lazyvim.plugins.extras.util.rest' })
end

if ConfigVariable.util.sql then
	table.insert(M, { import = 'lazyvim.plugins.extras.lang.sql' })
end

return M
