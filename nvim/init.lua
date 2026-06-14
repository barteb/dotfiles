-- Misc plugins
vim.pack.add(
	{
		{ src = 'https://github.com/nvim-lualine/lualine.nvim',       version = "a905eeebc4e63fdc48b5135d3bf8aea5618fb21c" },
		{ src = 'https://github.com/AvengeMedia/base46',              version = "cb8a1257bbc2640f6e7415a01219b34d3efd1494" },
		{ src = 'https://github.com/stevearc/oil.nvim',               version = "v2.16.0" },
		{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "4916d6592ede8c07973490d9322f187e07dfefac" }, -- pinned main (14.04.2026)
		{ src = "https://github.com/folke/which-key.nvim",            version = "v3.17.0" },
		{ src = "https://github.com/stevearc/conform.nvim",           version = "v9.1.0" },
		{ src = "https://github.com/saghen/blink.cmp",                version = "v1.10.2" },
	}
)
-- Lsp plugins
vim.pack.add(
	{
		{ src = "https://github.com/neovim/nvim-lspconfig", version = "v2.8.0" },
		{ src = "https://github.com/mason-org/mason.nvim",  version = "v2.2.1" }
	}
)
-- Git plugins
vim.pack.add(
	{
		{ src = "https://github.com/lewis6991/gitsigns.nvim", version = "v2.1.0" },
		{ src = "https://github.com/tpope/vim-fugitive",      version = "v3.7" }
	}
)

-- Colorscheme setup
vim.cmd('colorscheme base46-oxocarbon')

-- Plugins setup
require("mason").setup()
require("gitsigns").setup()
require("oil").setup()
require("lualine").setup({
	options = {
		icons_enabled = false
	}
})
require("which-key").setup({
	-- As we do not use nerd fonts, we use common unicode characters in few places, or just text
	icons = {
		mappings = false,
		keys = {
			Up = "↑",
			Down = "↓",
			Left = "←",
			Right = "→",
			C = "CTRL-",
			M = "ALT/META-",
			D = "CMD-",
			S = "SHIFT-",
			CR = "⏎",
			Esc = "<ESC>",
			ScrollWheelDown = "<SCROLL-DOWN>",
			ScrollWheelUp = "<SCROLL-UP>",
			NL = "<NL>",
			BS = "<BS>",
			Space = "<SPACE>",
			Tab = "<TAB>",
			F1 = "F1",
			F2 = "F2",
			F3 = "F3",
			F4 = "F4",
			F5 = "F5",
			F6 = "F6",
			F7 = "F7",
			F8 = "F8",
			F9 = "F9",
			F10 = "F10",
			F11 = "F11",
			F12 = "F12",
		},
	},
})
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
	},
})
require("blink.cmp").setup({
	completion = {
		accept = {
			auto_brackets = {
				enabled = true,
			},
		},
		ghost_text = {
			enabled = true,
			show_with_menu = false,
		},
		menu = {
			draw = {
				columns = { { 'label', 'label_description', gap = 1 }, { 'kind' } }, -- For iconless setup
			},
			auto_show = false,
		},
	},
})


-- Options
vim.g.mapleader = " "
vim.opt.termguicolors = true
vim.o.signcolumn = "yes"
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.smartindent = true

-- This autocommand highlights text on yank for a moment
vim.api.nvim_create_autocmd("TextYankPost",
	{
		group = vim.api.nvim_create_augroup("yankHl", {}),
		pattern = "*",
		callback = function()
			vim.hl.on_yank { timeout = 350 }
		end
	}
)
-- Diagnostics
vim.diagnostic.config({ virtual_text = true })
vim.api.nvim_create_autocmd("DiagnosticChanged", {
	callback = function(_)
		vim.diagnostic.setloclist({ open = false })
	end
})
vim.keymap.set("n", "<leader>d", vim.diagnostic.setloclist, { desc = "Toggle diagnostics in loclist" })

-- Treesitter
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("TS", { clear = true }),
	callback = function(ev)
		pcall(vim.treesitter.start, ev.buf)
	end
})

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = true
vim.o.incsearch = true

-- Formatter
-- This command is a conform-nvim recipe: https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#format-command
vim.api.nvim_create_user_command("Format", function(args)
	local range = nil
	if args.count ~= -1 then
		local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
		range = {
			start = { args.line1, 0 },
			["end"] = { args.line2, end_line:len() },
		}
	end
	require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })
vim.keymap.set({ "v", "n" }, "<leader>f", function() vim.cmd('Format') end,
	{ desc = "Format (buffer or visual selection)" })

-- LSP
vim.lsp.enable({ "lua_ls" })
