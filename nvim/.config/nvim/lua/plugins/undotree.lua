return {
	"mbbill/undotree",
	keys = {
		{
			mode = "n",
			"<leader>u",
			function()
				vim.cmd.UndotreeToggle()
				vim.cmd.UndotreeFocus()
			end,
      desc = "Toggle the Undotree window",
		},
	},
}
