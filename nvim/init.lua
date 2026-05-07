vim.pack.add(
	{
		{ src = 'https://github.com/nvim-tree/nvim-web-devicons', version = "c72328a5494b4502947a022fe69c0c47e53b6aa6" },
		{ src = 'https://github.com/nvim-lualine/lualine.nvim',   version = "a905eeebc4e63fdc48b5135d3bf8aea5618fb21c" }
	}
)
vim.pack.add(
	{
		{ src = "https://github.com/neovim/nvim-lspconfig", version = "v2.8.0" }
	}
)
vim.pack.add(
	{
		{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "4916d6592ede8c07973490d9322f187e07dfefac" } -- pinned main (14.04.2026)
	}
)
vim.pack.add(
	{
		{ src = "https://github.com/mason-org/mason.nvim", version = "v2.2.1" }
	}
)
vim.pack.add(
	{
		{ src = "https://github.com/lewis6991/gitsigns.nvim", version = "v2.1.0" }
	}
)
vim.pack.add(
	{
		{ src = "https://github.com/tpope/vim-fugitive", version = "v3.7" }
	}
)

-- Misc plugins
require("mason").setup()
require("lualine").setup({
	options = {
		icons_enabled = false
	}
})
require("gitsigns").setup()

-- Options
-- vim.cmd([[colorscheme modus]])
vim.opt.termguicolors = true
vim.o.signcolumn = "yes"
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.smartindent = true
vim.diagnostic.config({ virtual_text = true })
vim.api.nvim_create_autocmd("TextYankPost",
	{
		group = vim.api.nvim_create_augroup("yankHl", {}),
		pattern = "*",
		callback = function()
			vim.hl.on_yank { timeout = 350 }
		end
	}
)

-- Treesitter
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("TS", {clear = true}),
	callback = function(ev)
		pcall(vim.treesitter.start, ev.buf)
	end
})

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = true
vim.o.incsearch = true

-- Autocomplete
vim.o.autocomplete = true
vim.o.completeopt = "menu,menuone,noinsert,popup"
local lsp_attach_config_group = vim.api.nvim_create_augroup("lsp_attach_config_group", {clear = true})
local enable_lsp_autocomplete = function(args)
	local client_id = args.data.client_id
	if not client_id then
		return
	end
	local client = vim.lsp.get_client_by_id(client_id)
	if client and client:supports_method("textDocument/completion") then
		vim.lsp.completion.enable(true, client_id, args.buf, {
			autotrigger = true,
		})
	end
end
vim.api.nvim_create_autocmd("LspAttach", {
	group = lsp_attach_config_group,
	callback = enable_lsp_autocomplete
})

-- LSP
vim.lsp.enable({ "lua_ls" })


