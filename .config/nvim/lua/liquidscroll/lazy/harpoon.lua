return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup()

            vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
            vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
            -- Clear List
            vim.keymap.set("n", "<leader><S-q>", function() harpoon:list():clear() end, { desc = "Clear harpoon list" })
            vim.keymap.set("n", "<leader><C-q>", function() harpoon:list():remove() end, { desc = "Clear current buffer from harpoon list" })

            -- Toggle previous & next buffers stored within Harpoon list
            vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
            vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
        end
    }
}