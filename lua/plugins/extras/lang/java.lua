local java_filetypes = 'java'

return {
	{
		'mfussenegger/nvim-dap',
		optional = true,
		dependencies = {
			{
				'williamboman/mason.nvim',
				opts = { ensure_installed = { 'java-debug-adapter', 'java-test' } },
			},
		},
	},
	{ 'folke/which-key.nvim' },
	{
		'nvim-treesitter/nvim-treesitter',
		opts = { ensure_installed = { 'java' } },
	},
	{
		'williamboman/mason.nvim',
		opts = { ensure_installed = { 'java-debug-adapter', 'java-test' } },
	},

	{ import = 'lazyvim.plugins.extras.lang.java' },
}
