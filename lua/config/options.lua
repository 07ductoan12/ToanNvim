-- Keyboard leaders
vim.g.mapleader = ','
vim.g.maplocalleader = ';'

-- Enable elite-mode (hjkl mode. arrow-keys resize window)
vim.g.elite_mode = false

-- When enabled, 'q' closes any window
vim.g.window_q_mapping = true

-- File diff program
vim.g.diffprg = 'bcompare'

-- LazyVim auto format
vim.g.autoformat = false

-- LazyVim picker to use.
-- Can be one of: telescope, fzf
-- Leave it to "auto" to automatically use the picker
-- enabled with `:LazyExtras`
vim.g.lazyvim_picker = 'auto'

-- LazyVim root dir detection
-- Each entry can be:
-- * the name of a detector function like `lsp` or `cwd`
-- * a pattern or array of patterns like `.git` or `lua`.
-- * a function with signature `function(buf) -> string|string[]`
vim.g.root_spec = { 'lsp', { '.git', 'lua' }, 'cwd' }

-- LazyVim automatically configures lazygit:
--  * theme, based on the active colorscheme.
--  * editPreset to nvim-remote
--  * enables nerd font icons
-- Set to false to disable.
-- Set the options you want to override in `~/.config/lazygit/custom.yml`
-- WARN: on Windows you might want to set `editPreset: "nvim"` due to
-- this issue https://github.com/jesseduffield/lazygit/issues/3467
vim.g.lazygit_config = true

-- Options for the LazyVim statuscolumn
vim.g.lazyvim_statuscolumn = {
	folds_open = false, -- show fold sign when fold is open
	folds_githl = false, -- highlight fold sign with git sign color
}

-- Hide deprecation warnings
vim.g.deprecation_warnings = false

-- Set filetype to `bigfile` for files larger than 1.5 MB
-- Only vim syntax will be enabled (with the correct filetype)
-- LSP, treesitter and other ft plugins will be disabled.
-- mini.animate will also be disabled.
vim.g.bigfile_size = 1024 * 1024 * 1.5 -- 1.5 MB

-- Show the current document symbols location from Trouble in lualine
-- You can disable this for a buffer by setting `vim.b.trouble_lualine = false`
vim.g.trouble_lualine = false

-- General
-- ===
-- stylua: ignore start

local opt = vim.opt

opt.title = true
opt.titlestring = '%<%F%=%l/%L - nvim'
opt.mouse = 'nv'          -- Enable mouse in normal and visual modes only
opt.virtualedit = 'block' -- Position cursor anywhere in visual block
opt.confirm = true        -- Confirm unsaved changes before exiting buffer
opt.conceallevel = 2      -- Hide * markup for bold and italic, but not markers with substitutions
opt.signcolumn = 'yes'    -- Always show signcolumn
opt.spelllang = { 'en' }
opt.spelloptions:append('camel')
opt.spelloptions:append('noplainbuffer')
opt.updatetime = 200 -- Idle time to write swap and trigger CursorHold
vim.g.vscode = true
if not vim.g.vscode then
	opt.timeoutlen = 500 -- Time out on mappings
	opt.ttimeoutlen = 10 -- Time out on key codes
end

-- only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically. Requires Neovim >= 0.10.0
opt.clipboard = vim.env.SSH_TTY and '' or
		'unnamedplus' -- Sync with system clipboard

opt.completeopt = 'menu,menuone,noselect'
opt.wildmode = 'longest:full,full'
opt.diffopt:append({ 'indent-heuristic', 'algorithm:patience' })

opt.textwidth = 80     -- Text width maximum chars before wrapping
opt.tabstop = 2        -- The number of spaces a tab is
opt.smartindent = true -- Smart autoindenting on new lines
opt.shiftwidth = 2     -- Number of spaces to use in auto(indent)
opt.shiftround = true  -- Round indent to multiple of 'shiftwidth'

-- What to save for views and sessions
opt.sessionoptions:remove({ 'blank', 'buffers', 'terminal' })
opt.sessionoptions:append({ 'globals', 'skiprtp' })

opt.undofile = false
opt.undolevels = 10000
opt.writebackup = false

-- If sudo, disable vim swap/backup/undo/shada writing
local USER = vim.env.USER or ''
local SUDO_USER = vim.env.SUDO_USER or ''
if
		SUDO_USER ~= '' and USER ~= SUDO_USER
		and vim.env.HOME ~= vim.fn.expand('~' .. USER, true)
		and vim.env.HOME == vim.fn.expand('~' .. SUDO_USER, true)
then
	vim.opt_global.modeline = false
	vim.opt_global.undofile = false
	vim.opt_global.swapfile = false
	vim.opt_global.backup = false
	vim.opt_global.writebackup = false
	vim.opt_global.shadafile = 'NONE'
end

-- Searching
-- ===
opt.ignorecase = true      -- Search ignoring case
opt.smartcase = true       -- Keep case when searching with *
opt.inccommand = 'nosplit' -- Preview incremental substitute
opt.jumpoptions = 'view'

-- Formatting
-- ===

opt.wrap = false     -- No wrap by default
opt.linebreak = true -- Break long lines at 'breakat'
opt.breakindent = true
opt.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"

opt.formatoptions = opt.formatoptions
		- 'a' -- Auto formatting is BAD.
		- 't' -- Don't auto format my code. I got linters for that.
		+ 'c' -- In general, I like it when comments respect textwidth
		+ 'q' -- Allow formatting comments w/ gq
		- 'o' -- O and o, don't continue comments
		+ 'r' -- But do continue when pressing enter.
		+ 'n' -- Indent past the formatlistpat, not underneath it.
		+ 'j' -- Auto-remove comments if possible.
		- '2' -- I'm not in gradeschool anymore

-- Editor UI
-- ===

opt.termguicolors = true                               -- True color support
opt.shortmess:append({ W = true, I = true, c = true }) --  (default "ltToOCF")
opt.showcmd = false                                    -- Don't show command in status line
opt.showmode = false                                   -- Don't show mode in cmd window
opt.laststatus = 3                                     -- Global statusline
opt.scrolloff = 4                                      -- Keep at least 2 lines above/below
opt.sidescrolloff = 8                                  -- Keep at least 5 lines left/right
opt.numberwidth = 2                                    -- Minimum number of columns to use for the line number
opt.number = true                                      -- Don't show line numbers
opt.relativenumber = true
opt.ruler = false                                      -- Disable default status ruler
opt.list = true                                        -- Show hidden characters
opt.foldlevel = 99
opt.cursorline = true                                  -- Highlight the text line under the cursor
opt.splitbelow = true                                  -- New split at bottom
opt.splitright = true                                  -- New split on right
opt.splitkeep =
'screen'                                               -- New split keep the text on the same screen line

opt.cmdheight = 0
opt.colorcolumn = '+0' -- Align text at 'textwidth'
opt.showtabline = 2 -- Always show the tabs line
opt.helpheight = 0 -- Disable help window resizing
opt.winwidth = 30 -- Minimum width for active window
opt.winminwidth = 1 -- Minimum width for inactive windows
opt.winheight = 1 -- Minimum height for active window
opt.winminheight = 1 -- Minimum height for inactive window
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of items to show in the popup menu

opt.showbreak = '⤷  ' -- ↪	⤷
opt.listchars = {
	tab = '  ',
	extends = '⟫',
	precedes = '⟪',
	conceal = '',
	nbsp = '␣',
	trail = '·'
}
opt.fillchars = {
	foldopen = '', -- 󰅀 
	foldclose = '', -- 󰅂 
	fold = ' ', -- ⸱
	foldsep = ' ',
	diff = '╱',
	eob = ' ',
	horiz = '━',
	horizup = '┻',
	horizdown = '┳',
	vert = '┃',
	vertleft = '┫',
	vertright = '┣',
	verthoriz = '╋',
}

opt.statuscolumn = [[%!v:lua.require'lazyvim.util'.ui.statuscolumn()]]

if vim.fn.has('nvim-0.10') == 1 then
	opt.smoothscroll = true
	vim.opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
	vim.opt.foldmethod = 'expr'
	vim.opt.foldtext = ''
else
	vim.opt.foldmethod = 'indent'
	vim.opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
end

-- Misc
-- ===

-- Disable python/perl/ruby/node providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
vim.g.yaml_indent_multiline_scalar = 1

vim.g.no_gitrebase_maps = 1 -- See share/nvim/runtime/ftplugin/gitrebase.vim
vim.g.no_man_maps = 1       -- See share/nvim/runtime/ftplugin/man.vim

-- Filetype detection
-- ===

vim.filetype.add({
	filename = {
		Brewfile = 'ruby',
		justfile = 'just',
		Justfile = 'just',
		['.buckconfig'] = 'toml',
		['.flowconfig'] = 'ini',
		['.jsbeautifyrc'] = 'json',
		['.jscsrc'] = 'json',
		['.watchmanconfig'] = 'json',
		['helmfile.yaml'] = 'yaml',
		['todo.txt'] = 'todotxt',
		['yarn.lock'] = 'yaml',
	},
	pattern = {
		['%.config/git/users/.*'] = 'gitconfig',
		['%.kube/config'] = 'yaml',
		['.*%.js%.map'] = 'json',
		['.*%.postman_collection'] = 'json',
		['Jenkinsfile.*'] = 'groovy',
	},
})

if vim.g.neovide then
	-- Put anything you want to happen only in Neovide here
	vim.o.guifont =
	"ComicShannsMono Nerd Font:h14" -- text below applies for VimScript
	vim.g.neovide_scale_factor = 1.0
	vim.g.neovide_text_gamma = 0.0
	vim.g.neovide_text_contrast = 0.5
	vim.g.neovide_padding_top = 0
	vim.g.neovide_padding_bottom = 0
	vim.g.neovide_padding_right = 0
	vim.g.neovide_padding_left = 0

	-- Helper function for transparency formatting
	local alpha = function()
		return string.format("%x", math.floor(255 * vim.g.transparency or 0.8))
	end
	-- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
	vim.g.neovide_transparency = 0.65
	vim.g.transparency = 0.8
	vim.g.neovide_background_color = "#0f1117" .. alpha()
	vim.g.neovide_window_blurred = true
	vim.g.neovide_floating_blur_amount_x = 2.0
	vim.g.neovide_floating_blur_amount_y = 2.0
	vim.g.neovide_floating_shadow = true
	vim.g.neovide_floating_z_height = 10
	vim.g.neovide_light_angle_degrees = 45
	vim.g.neovide_light_radius = 5
	vim.g.neovide_show_border = true
	vim.g.neovide_position_animation_length = 0.15
	vim.g.neovide_scroll_animation_length = 0.3
	vim.g.neovide_scroll_animation_far_lines = 1
	vim.g.neovide_hide_mouse_when_typing = false
	vim.g.neovide_underline_stroke_scale = 1.0
	vim.g.neovide_theme = 'auto'
	vim.g.experimental_layer_grouping = false
	vim.g.neovide_refresh_rate = 60
	vim.g.neovide_refresh_rate_idle = 5
	vim.g.neovide_no_idle = true
	vim.g.neovide_confirm_quit = true
	vim.g.neovide_detach_on_quit = 'always_quit'
	vim.g.neovide_fullscreen = true
	vim.g.neovide_remember_window_size = true

	local function set_ime(args)
		if args.event:match("Enter$") then
			vim.g.neovide_input_ime = true
		else
			vim.g.neovide_input_ime = false
		end
	end

	local ime_input = vim.api.nvim_create_augroup("ime_input", { clear = true })

	vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
		group = ime_input,
		pattern = "*",
		callback = set_ime
	})

	vim.api.nvim_create_autocmd({ "CmdlineEnter", "CmdlineLeave" }, {
		group = ime_input,
		pattern = "[/\\?]",
		callback = set_ime
	})
end

-- vim: set ts=2 sw=0 tw=80 noet :
