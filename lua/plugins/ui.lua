function _LAZYGIT_TOGGLE()
	local Terminal = require('toggleterm.terminal').Terminal
	local lazygit =
		Terminal:new({ cmd = 'lazygit', hidden = true, direction = 'float' })
	lazygit:toggle()
end

local M = {
	-----------------------------------------------------------------------------
	-- Icon provider
	{
		'echasnovski/mini.icons',
		lazy = true,
		opts = {
			file = {
				['.keep'] = { glyph = '󰊢', hl = 'MiniIconsGrey' },
				['devcontainer.json'] = { glyph = '', hl = 'MiniIconsAzure' },
			},
			filetype = {
				dotenv = { glyph = '', hl = 'MiniIconsYellow' },
			},
		},
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			package.preload['nvim-web-devicons'] = function()
				require('mini.icons').mock_nvim_web_devicons()
				return package.loaded['nvim-web-devicons']
			end
		end,
	},

	-----------------------------------------------------------------------------
	-- UI Component Library
	{ 'MunifTanjim/nui.nvim', lazy = false },

	-----------------------------------------------------------------------------
	-- Fancy notification manager
	{
		'rcarriga/nvim-notify',
		priority = 9000,
		keys = {
			{
				'<leader>un',
				function()
					require('notify').dismiss({ silent = true, pending = true })
				end,
				desc = 'Dismiss All Notifications',
			},
		},
		opts = {
			stages = 'static',
			timeout = 3000,
			max_height = function()
				return math.floor(vim.o.lines * 0.75)
			end,
			max_width = function()
				return math.floor(vim.o.columns * 0.75)
			end,
			on_open = function(win)
				vim.api.nvim_win_set_config(win, { zindex = 100 })
			end,
		},
		init = function()
			-- When noice is not enabled, install notify on VeryLazy
			if not LazyVim.has('noice.nvim') then
				LazyVim.on_very_lazy(function()
					vim.notify = require('notify')
				end)
			end
		end,
	},

	-----------------------------------------------------------------------------
	-- Replaces the UI for messages, cmdline and the popupmenu
	{
		'folke/noice.nvim',
		event = 'VeryLazy',
		enabled = not vim.g.started_by_firenvim,
		-- stylua: ignore
		keys = {
			{ '<leader>sn',  '',                                             desc = '+noice' },
			{
				'<S-Enter>',
				function()
					require('noice').redirect(tostring(vim.fn
						.getcmdline()))
				end,
				mode = 'c',
				desc = 'Redirect Cmdline'
			},
			{ '<leader>snl', function() require('noice').cmd('last') end,    desc = 'Noice Last Message' },
			{ '<leader>snh', function() require('noice').cmd('history') end, desc = 'Noice History' },
			{ '<leader>sna', function() require('noice').cmd('all') end,     desc = 'Noice All' },
			{ '<leader>snt', function() require('noice').cmd('pick') end,    desc = 'Noice Picker (Telescope/FzfLua)' },
			{
				'<C-f>',
				function()
					if not require('noice.lsp').scroll(4) then
						return
						'<C-f>'
					end
				end,
				silent = true,
				expr = true,
				desc = 'Scroll Forward',
				mode = { 'i', 'n', 's' }
			},
			{
				'<C-b>',
				function()
					if not require('noice.lsp').scroll(-4) then
						return
						'<C-b>'
					end
				end,
				silent = true,
				expr = true,
				desc = 'Scroll Backward',
				mode = { 'i', 'n', 's' }
			},
		},
		---@type NoiceConfig
		opts = {
			lsp = {
				override = {
					['vim.lsp.util.convert_input_to_markdown_lines'] = true,
					['vim.lsp.util.stylize_markdown'] = true,
					['cmp.entry.get_documentation'] = true,
				},
			},
			messages = {
				view_search = false,
			},
			routes = {
				-- See :h ui-messages
				{
					filter = {
						event = 'msg_show',
						any = {
							{ find = '%d+L, %d+B' },
							{ find = '^%d+ changes?; after #%d+' },
							{ find = '^%d+ changes?; before #%d+' },
							{ find = '^Hunk %d+ of %d+$' },
							{ find = '^%d+ fewer lines;?' },
							{ find = '^%d+ more lines?;?' },
							{ find = '^%d+ line less;?' },
							{ find = '^Already at newest change' },
							{ kind = 'wmsg' },
							{ kind = 'emsg', find = 'E486' },
							{ kind = 'quickfix' },
						},
					},
					view = 'mini',
				},
				{
					filter = {
						event = 'msg_show',
						any = {
							{ find = '^%d+ lines .ed %d+ times?$' },
							{ find = '^%d+ lines yanked$' },
							{ kind = 'emsg', find = 'E490' },
							{ kind = 'search_count' },
						},
					},
					opts = { skip = true },
				},
				{
					filter = {
						event = 'notify',
						any = {
							{ find = '^No code actions available$' },
							{ find = '^No information available$' },
						},
					},
					view = 'mini',
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				lsp_doc_border = true,
			},
		},
		config = function(_, opts)
			-- HACK: noice shows messages from before it was enabled,
			-- but this is not ideal when Lazy is installing plugins,
			-- so clear the messages in this case.
			if vim.o.filetype == 'lazy' then
				vim.cmd([[messages clear]])
			end
			require('noice').setup(opts)
		end,
	},

	-----------------------------------------------------------------------------
	-- Visually display indent levels
	{
		'lukas-reineke/indent-blankline.nvim',
		main = 'ibl',
		event = 'LazyFile',
		opts = function()
			LazyVim.toggle.map('<leader>ue', {
				name = 'Indention Guides',
				get = function()
					return require('ibl.config').get_config(0).enabled
				end,
				set = function(state)
					require('ibl').setup_buffer(0, { enabled = state })
				end,
			})

			return {
				indent = {
					-- See more characters at :h ibl.config.indent.char
					char = '│', -- ▏│
					tab_char = '│',
				},
				scope = { show_start = false, show_end = false },
				exclude = {
					filetypes = {
						'alpha',
						'checkhealth',
						'dashboard',
						'git',
						'gitcommit',
						'help',
						'lazy',
						'lazyterm',
						'lspinfo',
						'man',
						'mason',
						'neo-tree',
						'notify',
						'Outline',
						'TelescopePrompt',
						'TelescopeResults',
						'terminal',
						'toggleterm',
						'Trouble',
					},
				},
			}
		end,
	},

	-----------------------------------------------------------------------------
	-- Visualize and operate on indent scope
	{ import = 'lazyvim.plugins.extras.ui.mini-indentscope' },

	-----------------------------------------------------------------------------
	-- Better quickfix window
	{
		'kevinhwang91/nvim-bqf',
		ft = 'qf',
		cmd = 'BqfAutoToggle',
		event = 'QuickFixCmdPost',
		opts = {
			auto_resize_height = false,
			func_map = {
				tab = 'st',
				split = 'sv',
				vsplit = 'sg',

				stoggleup = 'K',
				stoggledown = 'J',

				ptoggleitem = 'p',
				ptoggleauto = 'P',
				ptogglemode = 'zp',

				pscrollup = '<C-b>',
				pscrolldown = '<C-f>',

				prevfile = 'gk',
				nextfile = 'gj',

				prevhist = '<S-Tab>',
				nexthist = '<Tab>',
			},
			preview = {
				auto_preview = true,
				should_preview_cb = function(bufnr)
					-- file size greater than 100kb can't be previewed automatically
					local filename = vim.api.nvim_buf_get_name(bufnr)
					local fsize = vim.fn.getfsize(filename)
					if fsize > 100 * 1024 then
						return false
					end
					return true
				end,
			},
		},
	},
	-- {
	-- 	'luukvbaal/statuscol.nvim',
	-- 	event = 'VeryLazy',
	-- 	opts = {},
	-- 	config = function()
	-- 		local builtin = require('statuscol.builtin')
	-- 		local ffi = require('statuscol.ffidef')
	-- 		local C = ffi.C
	--
	-- 		-- only show fold level up to this level
	-- 		local fold_level_limit = 2
	-- 		local function foldfunc(args)
	-- 			local foldinfo = C.fold_info(args.wp, args.lnum)
	-- 			if foldinfo.level > fold_level_limit then
	-- 				return ' '
	-- 			end
	--
	-- 			return builtin.foldfunc(args)
	-- 		end
	--
	-- 		require('statuscol').setup({
	-- 			relculright = false,
	-- 			ft_ignore = {
	-- 				'neo-tree',
	-- 				'neo-tree-popup',
	-- 				'alpha',
	-- 				'lazy',
	-- 				'mason',
	-- 				'dashboard',
	-- 				'NvimTree',
	-- 				'Neo-tree',
	-- 			},
	-- 			segments = {
	-- 				{ text = { '%s' }, click = 'v:lua.ScSa' },
	-- 				{ text = { builtin.lnumfunc, ' ' }, click = 'v:lua.ScLa' },
	-- 				{
	-- 					text = { foldfunc, ' ' },
	-- 					condition = { true, builtin.not_empty },
	-- 					click = 'v:lua.ScFa',
	-- 				},
	-- 			},
	-- 		})
	-- 	end,
	-- },
	--
	-- transparent
	{
		'xiyaowong/transparent.nvim',
		config = function()
			require('transparent').setup({ -- Optional, you don't have to run setup.
				groups = { -- table: default groups
					'Normal',
					'NormalNC',
					'Comment',
					'Constant',
					'Special',
					'Identifier',
					'Statement',
					'PreProc',
					'Type',
					'Underlined',
					'Todo',
					'String',
					'Function',
					'Conditional',
					'Repeat',
					'Operator',
					'Structure',
					'LineNr',
					'NonText',
					'SignColumn',
					'CursorLine',
					'CursorLineNr',
					'StatusLine',
					'StatusLineNC',
					'EndOfBuffer',
				},
				extra_groups = {}, -- table: additional groups that should be cleared
				exclude_groups = {}, -- table: groups you don't want to clear
			})
			require('transparent').clear_prefix('NvimTree')
		end,
		lazy = false,
	},

	{
		'HiPhish/rainbow-delimiters.nvim',
		event = 'VeryLazy',
		config = function()
			if vim.fn.expand('%:p') ~= '' then
				vim.cmd.edit({ bang = true })
			end
		end,
	},
	-----------------------------------------------------------------------------
	-- Create key bindings that stick
	{
		'folke/which-key.nvim',
		event = 'VeryLazy',
		cmd = 'WhichKey',
		keys = {
			{
				'<leader>bk',
				function()
					require('which-key').show({ global = false })
				end,
				desc = 'Buffer Keymaps (which-key)',
			},
			{
				'<C-w><Space>',
				function()
					require('which-key').show({ keys = '<c-w>', loop = true })
				end,
				desc = 'Window Hydra Mode (which-key)',
			},
		},
		opts_extend = { 'spec' },
		-- stylua: ignore
		opts = {
			defaults = {},
			icons = {
				breadcrumb = '»',
				separator = '󰁔  ', -- ➜
			},
			delay = function(ctx)
				return ctx.plugin and 0 or 400
			end,
			spec = {
				{
					mode = { 'n', 'v' },
					{ '[',  group = 'prev' },
					{ ']',  group = 'next' },
					{ 'g',  group = 'goto' },
					{ 'gz', group = 'surround' },
					{ 'z',  group = 'fold' },
					{ ';',  group = '+telescope' },
					{ ';d', group = '+lsp' },
					{
						'<leader>b',
						group = 'buffer',
						expand = function()
							return require('which-key.extras').expand.buf()
						end,
					},
					{ '<leader>c',        group = 'code' },
					{ '<leader><leader>', group = 'win' },
					{ '<leader>ch',       group = 'calls' },
					{ '<leader>f',        group = 'file/find' },
					{ '<leader>fw',       group = 'workspace' },
					{
						'<leader>g',
						group = 'git',
						{ "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", desc = "Lazygit" },
					},
					{ '<leader>h', group = 'hunks', icon = { icon = ' ', color = 'red' } },
					{ '<leader>ht', group = 'toggle' },
					{ '<leader>m', group = 'tools' },
					{ '<leader>md', group = 'diff' },
					{ '<leader>s', group = 'search' },
					{ '<leader>sn', group = 'noice' },
					{ '<leader>t', group = 'toggle/tools' },
					{ '<leader>u', group = 'ui', icon = { icon = '󰙵 ', color = 'cyan' } },
					{ '<leader>x', group = 'diagnostics/quickfix', icon = { icon = '󱖫 ', color = 'green' } },
					{
						'<leader>l',
						group = 'lsp',
						{ "<leader>lf", "<cmd>lua vim.lsp.buf.format{async=true}<cr>", desc = "Format" },
					},

					-- Better descriptions
					{ 'gx', desc = 'Open with system app' },

					-- DAP
					{
						"<leader>d",
						group = "Debug",
					},
					{
						"<leader>j",
						group = "Hop",
						mode = { "n", "v" },
						{ "<leader>jj", "<cmd>HopWord<cr>",      desc = "Hop word" },
						{ "<leader>jl", "<cmd>HopLine<cr>",      desc = "Hop line" },
						{ "<leader>jc", "<cmd>HopChar1<cr>",     desc = "Hop char" },
						{ "<leader>jp", "<cmd>HopPattern<cr>",   desc = "Hop arbitrary" },
						{ "<leader>ja", "<cmd>HopAnywhere<cr>",  desc = "Hop all" },
						{ "<leader>js", "<cmd>HopLineStart<cr>", desc = "Hop line start" },
					},
				},
			},
		},
		config = function(_, opts)
			local wk = require('which-key')
			wk.setup(opts)
			if not vim.tbl_isempty(opts.defaults) then
				LazyVim.warn(
					'which-key: opts.defaults is deprecated. Please use opts.spec instead.'
				)
				wk.add(opts.defaults)
			end
		end,
	},

	-----------------------------------------------------------------------------
	-- Snazzy tab/bufferline
	{
		'akinsho/bufferline.nvim',
		event = 'VeryLazy',
		enabled = not vim.g.started_by_firenvim,
		-- stylua: ignore
		keys = {
			{ '<leader>bp', '<Cmd>BufferLineTogglePin<CR>',            desc = 'Toggle Pin' },
			{ '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', desc = 'Delete Non-Pinned Buffers' },
			{ '<leader>bo', '<Cmd>BufferLineCloseOthers<CR>',          desc = 'Delete Other Buffers' },
			{ '<leader>br', '<Cmd>BufferLineCloseRight<CR>',           desc = 'Delete Buffers to the Right' },
			{ '<leader>bl', '<Cmd>BufferLineCloseLeft<CR>',            desc = 'Delete Buffers to the Left' },
			{ '<leader>bc', '<Cmd>BufferLinePick<CR>',                 desc = 'Tab Pick' },
			{ '[B',         '<cmd>BufferLineMovePrev<cr>',             desc = 'Move buffer prev' },
			{ ']B',         '<cmd>BufferLineMoveNext<cr>',             desc = 'Move buffer next' },
		},
		opts = {
			options = {
				indicator = {
					icon = '▎', -- this should be omitted if indicator style is not 'icon'
					style = 'icon', -- 'icon' | 'underline' | 'none',
				},
				buffer_close_icon = '󰅖',
				modified_icon = '● ',
				close_icon = ' ',
				left_trunc_marker = ' ',
				right_trunc_marker = ' ',
				show_buffer_icons = true, -- disable filetype icons for buffers
				show_duplicate_prefix = true, -- whether to show duplicate buffer prefix
				separator_style = 'thick',
				show_close_icon = true,
				show_buffer_close_icons = true,
				diagnostics = 'nvim_lsp',
				show_tab_indicators = true,
				enforce_regular_tabs = true,
				always_show_bufferline = true,
				close_command = function(n)
					LazyVim.ui.bufremove(n)
				end,
				right_mouse_command = function(n)
					LazyVim.ui.bufremove(n)
				end,
				diagnostics_indicator = function(_, _, diag)
					local icons = LazyVim.config.icons.diagnostics
					local ret = (diag.error and icons.Error .. diag.error .. ' ' or '')
						.. (diag.warning and icons.Warn .. diag.warning or '')
					return vim.trim(ret)
				end,
				custom_areas = {
					right = function()
						local result = {}
						local root = LazyVim.root()
						table.insert(result, {
							text = '%#BufferLineTab# ' .. vim.fn.fnamemodify(root, ':t'),
						})

						-- Session indicator
						if vim.v.this_session ~= '' then
							table.insert(result, { text = '%#BufferLineTab#  ' })
						end
						return result
					end,
				},
				offsets = {
					{
						filetype = 'neo-tree',
						text = 'Neo-tree',
						highlight = 'Directory',
						text_align = 'center',
					},
				},
				---@param opts bufferline.IconFetcherOpts
				get_element_icon = function(opts)
					return LazyVim.config.icons.ft[opts.filetype]
				end,
			},
		},
		config = function(_, opts)
			require('bufferline').setup(opts)
			-- Fix bufferline when restoring a session
			vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete' }, {
				callback = function()
					vim.schedule(function()
						---@diagnostic disable-next-line: undefined-global
						pcall(nvim_bufferline)
					end)
				end,
			})
		end,
	},

	{ import = 'plugins.extras.ui.alpha' },
	{ import = 'lazyvim.plugins.extras.ui.mini-indentscope' },
}

return M
