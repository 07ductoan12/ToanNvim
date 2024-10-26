return {

	{ import = 'lazyvim.plugins.extras.lang.tailwind' },
	{
		'williamboman/mason-lspconfig.nvim',
		opts = {
			automatic_installation = true,
			ensure_installed = {
				'cssls',
				'emmet_ls',
				'html',
			},
		},
	},
	{
		'neovim/nvim-lspconfig',
		opts = {
			servers = {
				cssls = {
					init_options = {
						provideFormatter = true,
					},
					settings = {
						css = {
							validate = true,
						},
						less = {
							validate = true,
						},
						scss = {
							validate = true,
						},
					},
					single_file_support = true,
				},
				html = {
					init_options = {
						configurationSection = { 'html', 'css', 'javascript' },
						embeddedLanguages = {
							css = true,
							javascript = true,
						},
						provideFormatter = true,
					},
					settings = {},
					single_file_support = true,
				},
				emmet_ls = {
					filetypes = {
						'astro',
						'css',
						'eruby',
						'html',
						'htmldjango',
						'javascriptreact',
						'less',
						'pug',
						'sass',
						'scss',
						'svelte',
						'typescriptreact',
						'vue',
						'htmlangular',
					},
					single_file_support = true,
				},
			},
		},
	},
}
