local leap = require("leap")

leap.create_default_mappings()
leap.opts.special_keys.prev_target = '<bs>'
leap.opts.special_keys.prev_group = '<bs>'
leap.opts.safe_labels = {}
leap.opts.max_phase_one_targets = 0
leap.opts.highlight_unlabeled_phase_one_targets = false
