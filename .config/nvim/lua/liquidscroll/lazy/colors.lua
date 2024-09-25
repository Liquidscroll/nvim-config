function SetColourScheme(color)
	color = color or "one_monokai"
	vim.cmd.colorscheme(color)
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
	{
		"cpea2506/one_monokai.nvim",
		config = function()
			require("one_monokai").setup({
			transparent = true,
			colors = {},
--			themes = function(colors)
--				return {}
--			end,
			italics = false
			})
		end
	}
}
