local lazy = {}

function lazy.install(path)
	local uv = vim.uv or vim.loop
	if not uv.fs_stat(path) then
		print('Installing lazy.nvim....')
		vim.fn.system({
			'git',
			'clone',
			'--filter=blob:none',
			'https://github.com/folke/lazy.nvim.git',
			'--branch=stable', -- latest stable release
			path,
		})
	end
end

function lazy.setup(plugins)
	if vim.g.plugins_ready then
		return
	end

	lazy.install(lazy.path)
	vim.opt.rtp:prepend(lazy.path)

	require('lazy').setup(plugins, lazy.opts)
	vim.g.plugins_ready = true
end

lazy.path = table.concat({
	vim.fn.stdpath('data'),
	'lazy',
	'lazy.nvim'
}, '/')

lazy.opts = {}

lazy.setup({
	-- {'folke/tokyonight.nvim'},
	{ 'folke/which-key.nvim' },
	{ 'neovim/nvim-lspconfig' },
	{ 'echasnovski/mini.nvim',           branch = 'main' },
	{ 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
	{
		'nvim-telescope/telescope.nvim',
		dependencies = {
			'nvim-lua/plenary.nvim'
			-- { "nvim-telescope/telescope-fzf-native", build="make" }
		}
	},
	{"luukvbaal/nnn.nvim"},
	{'ThePrimeagen/vim-be-good'}


})

-- ========================================================================== --
-- ==                         PLUGIN CONFIGURATION                         == --
-- ========================================================================== --

require('nnn').setup({
	-- replace_netrw = "picker"
})
vim.keymap.set('n', '<leader>e', function()
  if vim.fn.bufexists('NNN') == 1 then
    vim.cmd('bdelete NNN')
  else
    vim.cmd('NnnPicker')
  end
end, { desc = "Toggle NnnPicker" })

vim.keymap.set('n', '<leader>b', function()
  if vim.fn.bufexists('NNN') == 1 then
    vim.cmd('bdelete NNN')
  else
    vim.cmd('NnnExplorer')
  end
end, { desc = "Toggle NnnExplorer" })

-- Treesitter setup
require('nvim-treesitter.configs').setup({
	highlight = { enable = true },
	auto_install = true,
	ensure_installed = { 'lua', 'vim', 'vimdoc', 'json' },
})

-- Which-key setup
require('which-key').setup({
	icons = {
		mappings = false,
		keys = {
			Space = 'Space',
			Esc = 'Esc',
			BS = 'Backspace',
			C = 'Ctrl-',
		},
	},
})

require('which-key').add({
	{ '<leader>f', group = 'telescope' },
	{ '<leader>b', group = 'Buffer' },
})

-- Mini.nvim plugins setup
require('mini.comment').setup({})
-- require('mini.starter').setup({})
require('mini.surround').setup({})
require('mini.bufremove').setup({})
require('mini.snippets').setup({})
require('mini.icons').setup({})
require('mini.pairs').setup({})
require('mini.tabline').setup({})
require('mini.completion').setup({
	lsp_completion = {
		auto_setup = true
	}
})

vim.keymap.set('i', '<Tab>', function()
	return vim.fn.pumvisible() == 1 and '<C-n>' or '<Tab>'
end, { expr = true, noremap = true, desc = 'Next completion item' })

vim.keymap.set('i', '<S-Tab>', function()
	return vim.fn.pumvisible() == 1 and '<C-p>' or '<S-Tab>'
end, { expr = true, noremap = true, desc = 'Previous completion item' })

vim.keymap.set('i', '<CR>', function()
	return vim.fn.pumvisible() == 1 and '<C-y>' or '<CR>'
end, { expr = true, noremap = true, desc = 'Confirm completion' })

vim.keymap.set('i', '<C-Space>', '<cmd>lua MiniCompletion.complete()<cr>', { desc = 'Trigger completion' })


require('mini.base16').setup({
	-- Table with names from `base00` to `base0F` and values being strings of
	-- HEX colors with format "#RRGGBB". NOTE: this should be explicitly
	-- supplied in `setup()`.
	palette = {
		base00 = '#181818',
		base01 = '#282828',
		base02 = '#383838',
		base03 = '#585858',
		base04 = '#b8b8b8',
		base05 = '#d8d8d8',
		base06 = '#e8e8e8',
		base07 = '#f8f8f8',
		base08 = '#ab4642',
		base09 = '#dc9656',
		base0A = '#f7ca88',
		base0B = '#a1b56c',
		base0C = '#86c1b9',
		base0D = '#7cafc2',
		base0E = '#ba8baf',
		base0F = '#a16946',

	},

	-- Whether to support cterm colors. Can be boolean, `nil` (same as
	-- `false`), or table with cterm colors. See `setup()` documentation for
	-- more information.
	use_cterm = nil,

	-- Plugin integrations. Use `default = false` to disable all integrations.
	-- Also can be set per plugin (see |MiniBase16.config|).
	plugins = { default = true },
})
-- Buffer removal mapping
vim.keymap.set('n', '<leader>q', '<cmd>lua pcall(MiniBufremove.delete)<cr>', { desc = 'Close buffer' })

-- MiniFiles for file explorer
-- local mini_files = require('mini.files')
-- mini_files.setup({})

-- vim.keymap.set('n', '<leader>e', function()
-- 	if mini_files.close() then
-- 		return
-- 	end
-- 	mini_files.open()
-- end, { desc = 'File explorer' })

-- telescope bindings
vim.keymap.set('n', '<leader>ff', require("telescope.builtin").find_files, { desc = 'find files' })
vim.keymap.set('n', '<leader>fr', require("telescope.builtin").builtin, { desc = 'telescope help' })
vim.keymap.set('n', '<leader>fg', require("telescope.builtin").command_history, { desc = 'cmd history' })
vim.keymap.set('n', '<leader>fc', function()
	require("telescope.builtin").find_files {
		cwd = vim.fn.stdpath("config")
	}
end
, { desc = 'find in cfg' })

-- Statusline setup
local mini_statusline = require('mini.statusline')

local function statusline()
	local mode, mode_hl = mini_statusline.section_mode({ trunc_width = 120 })
	local diagnostics = mini_statusline.section_diagnostics({ trunc_width = 75 })
	local lsp = mini_statusline.section_lsp({ icon = 'LSP', trunc_width = 75 })
	local filename = mini_statusline.section_filename({ trunc_width = 140 })
	local percent = '%2p%%'
	local location = '%3l:%-2c'

	return mini_statusline.combine_groups({
		{ hl = mode_hl,                 strings = { mode } },
		{ hl = 'MiniStatuslineDevinfo', strings = { diagnostics, lsp } },
		'%<',
		{ hl = 'MiniStatuslineFilename', strings = { filename } },
		'%=',
		{ hl = 'MiniStatuslineFilename', strings = { '%{&filetype}' } },
		{ hl = 'MiniStatuslineFileinfo', strings = { percent } },
		{ hl = mode_hl,                  strings = { location } },
	})
end

mini_statusline.setup({
	content = { active = statusline },
})

-- LSP Configuration
vim.api.nvim_create_autocmd('LspAttach', {
	desc = 'LSP actions',
	callback = function(event)
		local opts = { buffer = event.buf }
		vim.keymap.set('n', 'grr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
		vim.keymap.set('n', 'gri', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
		vim.keymap.set('n', 'grn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
		vim.keymap.set('n', 'gra', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
		vim.keymap.set('n', 'gO', '<cmd>lua vim.lsp.buf.document_symbol()<cr>', opts)
		vim.keymap.set({ 'i', 's' }, '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
		vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts) -- remember
		vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
		vim.keymap.set('n', 'grt', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
		vim.keymap.set('n', 'grd', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
		vim.keymap.set({ 'n', 'x' }, 'gq', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts) -- remember
	end,
})
