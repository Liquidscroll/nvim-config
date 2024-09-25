return {
    {
        'Exafunction/codeium.vim',
        requires = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp"
        },
        config = function ()
            -- Disable Codeium
            vim.g.codeium_enabled = false
            if(not vim.g.codeium_enable) then
                print("Codeium disabled.")
            else
                vim.keymap.set('i', '<C-g>', function () return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
                vim.keymap.set('i', '<C-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
                vim.keymap.set('i', '<C-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
                vim.keymap.set('i', '<C-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
                print("Codeium enabled.")
            end
            -- Change '<C-g>' here to any keycode you like.
        end
    }
}
