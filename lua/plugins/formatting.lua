return {

	-- Import LazyVim's formatting spec in its entirety.
	{ import = 'lazyvim.plugins.formatting' },
	{ import = 'lazyvim.plugins.extras.formatting.prettier' },

	-- Lightweight yet powerful formatter plugin
	{
		'stevearc/conform.nvim',
		-- stylua: ignore
		keys = {
			{ '<leader>cic', '<cmd>ConformInfo<CR>', silent = true, desc = 'Conform Info' },
		},
	},
}
