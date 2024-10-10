return {
    {
        'numToStr/FTerm.nvim',
        opts = {
            border = 'single', -- Customize the border style
            dimensions = {
                height = 0.6,
                width = 0.6,
            }
        },
            vim.keymap.set('n', '<leader>t', '<CMD>lua require("FTerm").toggle()<CR>'),
            vim.keymap.set('t', '<C-d>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')
    }
}