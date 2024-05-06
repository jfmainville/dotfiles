local leap = require("leap")
local leap_user = require("leap.user")

leap.create_default_mappings()
leap.case_sensitive = false
leap.opts.equivalence_classes = { ' \t\r\n', '([{', ')]}', '\'"`' }
leap.opts.special_keys.prev_target = '<backspace>'
leap.opts.special_keys.prev_group = '<backspace>'
leap.opts.special_keys.prev_target = '<bs>'
leap.opts.special_keys.prev_group = '<bs>'
leap_user.set_repeat_keys('<enter>', '<backspace>')
leap.opts.safe_labels = {}
leap.opts.max_phase_one_targets = 0
leap.opts.highlight_unlabeled_phase_one_targets = true

-- Lightspeed-style highlighting configuration
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    local bg = vim.api.nvim_get_hl(0, { name = 'LeapLabelSecondary' }).bg
    vim.api.nvim_set_hl(0, 'LeapLabelSecondary', { fg = bg, bg = bg, })
  end
})
vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' }) -- or some grey
vim.api.nvim_set_hl(0, 'LeapMatch', {
  -- For light themes, set to 'black' or similar.
  fg = 'white',
  bold = true,
  nocombine = true,
})

-- Lightspeed colors
-- primary labels: bg = "#f02077" (light theme) or "#ff2f87"  (dark theme)
-- secondary labels: bg = "#399d9f" (light theme) or "#99ddff" (dark theme)
-- shortcuts: bg = "#f00077", fg = "white"
-- You might want to use either the primary label or the shortcut colors
-- for Leap primary labels, depending on your taste.
vim.api.nvim_set_hl(0, 'LeapLabelPrimary', {
  fg = 'black', bg = '#89b4f9', bold = true, nocombine = true,
})
vim.api.nvim_set_hl(0, 'LeapLabelSecondary', {
  fg = 'black', bg = "#cba5f7", bold = true, nocombine = true,
})
