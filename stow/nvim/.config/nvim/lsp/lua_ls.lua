-- Teach lua_ls about the Neovim runtime (vim global, API completion)
return {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME, '${3rd}/luv/library' },
      },
    },
  },
}
