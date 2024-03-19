local M = {}

M.map_lsp_keybinds = function(buffer_number)

    local map = function(keys, func, desc)
        vim.keymap.set('n', keys, func, {
            buffer = event.buf,
            desc = 'LSP: ' .. desc
        })
    end

    -- nnoremap("<leader>rn", vim.lsp.buf.rename, { desc = "LSP: [R]e[n]ame", buffer = buffer_number })
    -- nnoremap("<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: [C]ode [A]ction", buffer = buffer_number })
    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    -- nnoremap("gd", vim.lsp.buf.definition, { desc = "LSP: [G]oto [D]efinition", buffer = buffer_number })

    -- -- Telescope LSP keybinds --
    -- nnoremap(
    -- 	"gr",
    -- 	require("telescope.builtin").lsp_references,
    -- 	{ desc = "LSP: [G]oto [R]eferences", buffer = buffer_number }
    -- )

    -- nnoremap(
    -- 	"gi",
    -- 	require("telescope.builtin").lsp_implementations,
    -- 	{ desc = "LSP: [G]oto [I]mplementation", buffer = buffer_number }
    -- )

    -- nnoremap(
    -- 	"<leader>bs",
    -- 	require("telescope.builtin").lsp_document_symbols,
    -- 	{ desc = "LSP: [B]uffer [S]ymbols", buffer = buffer_number }
    -- )

    -- nnoremap(
    -- 	"<leader>ps",
    -- 	require("telescope.builtin").lsp_workspace_symbols,
    -- 	{ desc = "LSP: [P]roject [S]ymbols", buffer = buffer_number }
    -- )

    -- -- See `:help K` for why this keymap
    -- nnoremap("K", vim.lsp.buf.hover, { desc = "LSP: Hover Documentation", buffer = buffer_number })
    -- nnoremap("<leader>k", vim.lsp.buf.signature_help, { desc = "LSP: Signature Documentation", buffer = buffer_number })
    -- inoremap("<C-k>", vim.lsp.buf.signature_help, { desc = "LSP: Signature Documentation", buffer = buffer_number })

    -- -- Lesser used LSP functionality
    -- nnoremap("gD", vim.lsp.buf.declaration, { desc = "LSP: [G]oto [D]eclaration", buffer = buffer_number })
    -- nnoremap("td", vim.lsp.buf.type_definition, { desc = "LSP: [T]ype [D]efinition", buffer = buffer_number })
end

return M
