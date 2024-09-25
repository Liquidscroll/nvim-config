return {
	{
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	requires = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")
		harpoon.setup()
	-- Key mappings for Harpoon functionality
		vim.keymap.set("n", "<leader>a", function() harpoon.mark.add_file() end)
		vim.keymap.set("n", "<C-e>", function() harpoon.ui.toggle_quick_menu() end)
	
		vim.keymap.set("n", "<C-h>", function() harpoon.ui.nav_file(1) end)
		vim.keymap.set("n", "<C-t>", function() harpoon.ui.nav_file(2) end)
		vim.keymap.set("n", "<C-n>", function() harpoon.ui.nav_file(3) end)
		vim.keymap.set("n", "<C-s>", function() harpoon.ui.nav_file(4) end)
	-- Toggle previous & next buffers stored within Harpoon list
		vim.keymap.set("n", "<C-S-P>", function() harpoon.ui.nav_prev() end)
		vim.keymap.set("n", "<C-S-N>", function() harpoon.ui.nav_next() end)
	end
	}
}


