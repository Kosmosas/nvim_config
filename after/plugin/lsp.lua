 require("mason").setup()
 require("mason-lspconfig").setup()

--require('rust-tools').setup({})
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
	lsp_zero.default_keymaps({buffer = bufnr})
end)

local handlers = {
	-- The first entry (without a key) will be the default handler
	-- and will be called for each installed server that doesn't have
	-- a dedicated handler.
	function (server_name) -- default handler (optional)
		require("lspconfig")[server_name].setup {}
	end,
	-- Next, you can provide targeted overrides for specific servers.
	--["rust_analyzer"] = function ()
	--	require("rust-tools").setup {}
	--end,
	["lua_ls"] = function ()
		local lspconfig = require("lspconfig")
		lspconfig.lua_ls.setup {
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim", "require" }
					}
				}
			}
		}
	end,
}

-- alt 1. Either pass handlers when setting up mason-lspconfig:
require("mason-lspconfig").setup({ handlers = handlers })

-- alt 2. or call the .setup_handlers() function.
--require("mason-lspconfig").setup_handlers(handlers)

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
  mapping = {
    -- Navigate between completion item
    ['<M-k>'] = cmp.mapping.select_prev_item(),
    ['<M-j>'] = cmp.mapping.select_next_item(),

    -- toggle completion
    ['<M-u>'] = cmp_action.toggle_completion(),

    -- navigate between snippet placeholder
    ['<C-a>'] = cmp_action.luasnip_jump_backward(),
    ['<C-d>'] = cmp_action.luasnip_jump_forward(),

    -- Confirm item
    ['<Tab>'] = cmp.mapping.confirm({select = true}),
  }
})

