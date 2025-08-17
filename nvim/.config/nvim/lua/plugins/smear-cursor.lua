return {
	"sphamba/smear-cursor.nvim",
	opts = {
		enabled = true,
		smear_terminal_mode = false,

		-- This is a fix to prevent the cursor from being drawn over the target primarily an issue in command mode
		hide_target_hack = true,
		never_draw_over_target = true,
	},
}
