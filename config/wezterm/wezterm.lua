local f = require("utils/font")
local h = require("utils/helpers")
local k = require("utils/keys")

local wezterm = require("wezterm")
local act = wezterm.action

local config = {

	font = f.get_font({
		"JetBrainsMono Nerd Font", -- "Monaspace Argon",
		-- "Monaspace Krypton",
		-- "Monaspace Neon",
		-- "Monaspace Radon",
		-- "Monaspace Xenon",
	}),

	font_size = 14,

	line_height = 1.1,

	window_padding = {
		left = 30,
		right = 30,
		top = 20,
		bottom = 10,
	},

	set_environment_variables = {
		-- THEME_FLAVOUR = "latte",
		TERM = "xterm-256color",
		LC_ALL = "en_US.UTF-8",
	},

	-- general options
	adjust_window_size_when_changing_font_size = false,
	debug_key_events = false,
	enable_tab_bar = false,
	native_macos_fullscreen_mode = false,
	-- window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE",

	keys = {
		k.cmd_key(".", k.multiple_actions(":ZenMode")),
		k.cmd_key(
			"[",
			act.SendKey({
				mods = "CTRL",
				key = "o",
			})
		),
		k.cmd_key(
			"]",
			act.SendKey({
				mods = "CTRL",
				key = "i",
			})
		),
		-- k.cmd_key("f", k.multiple_actions(":Grep")),
		-- k.cmd_key("H", act.SendKey({ mods = "CTRL", key = "h" })),
		-- k.cmd_key("i", k.multiple_actions(":SmartGoTo")),
		-- k.cmd_key("J", act.SendKey({ mods = "CTRL", key = "j" })),
		-- k.cmd_key("K", act.SendKey({ mods = "CTRL", key = "k" })),
		-- k.cmd_key("K", act.SendKey({ mods = "CTRL", key = "k" })),
		-- k.cmd_key("L", act.SendKey({ mods = "CTRL", key = "l" })),
		-- k.cmd_key("P", k.multiple_actions(":GoToCommand")),
		-- k.cmd_key("p", k.multiple_actions(":GoToFile")),
		-- k.cmd_key("j", k.multiple_actions(":GoToFile")),
		-- k.cmd_key("q", k.multiple_actions(":qa!")),
		k.cmd_to_tmux_prefix("1", "1"),
		k.cmd_to_tmux_prefix("2", "2"),
		k.cmd_to_tmux_prefix("3", "3"),
		k.cmd_to_tmux_prefix("4", "4"),
		k.cmd_to_tmux_prefix("5", "5"),
		k.cmd_to_tmux_prefix("6", "6"),
		k.cmd_to_tmux_prefix("7", "7"),
		k.cmd_to_tmux_prefix("8", "8"),
		k.cmd_to_tmux_prefix("9", "9"),
		k.cmd_to_tmux_prefix("`", "n"),
		k.cmd_to_tmux_prefix("b", "B"),
		k.cmd_to_tmux_prefix("C", "C"),
		k.cmd_to_tmux_prefix("d", "D"),
		k.cmd_to_tmux_prefix("G", "G"),
		k.cmd_to_tmux_prefix("g", "g"),
		k.cmd_to_tmux_prefix("K", "T"),
		k.cmd_to_tmux_prefix("k", "K"),
		k.cmd_to_tmux_prefix("l", "L"),
		k.cmd_to_tmux_prefix("n", '"'),
		k.cmd_to_tmux_prefix("N", "%"),
		k.cmd_to_tmux_prefix("o", "u"),
		k.cmd_to_tmux_prefix("T", "!"),
		k.cmd_to_tmux_prefix("t", "c"),
		k.cmd_to_tmux_prefix("w", "x"),
		k.cmd_to_tmux_prefix("z", "z"),
		k.cmd_to_tmux_prefix("Z", "Z"),
		k.cmd_key(
			"R",
			act.Multiple({
				act.SendKey({
					key = "\x1b",
				}), -- escape
				k.multiple_actions(":source %"),
			})
		),
		k.cmd_key(
			"s",
			act.Multiple({
				act.SendKey({
					key = "\x1b",
				}), -- escape
				k.multiple_actions(":w"),
			})
		),
		{
			mods = "CMD|SHIFT",
			key = "}",
			action = act.Multiple({
				act.SendKey({
					mods = "CTRL",
					key = "b",
				}),
				act.SendKey({
					key = "n",
				}),
			}),
		},
		{
			mods = "CMD|SHIFT",
			key = "{",
			action = act.Multiple({
				act.SendKey({
					mods = "CTRL",
					key = "b",
				}),
				act.SendKey({
					key = "p",
				}),
			}),
		},
		{
			mods = "CTRL",
			key = "Tab",
			action = act.Multiple({
				act.SendKey({
					mods = "CTRL",
					key = "b",
				}),
				act.SendKey({
					key = "n",
				}),
			}),
		},
		{
			mods = "CTRL|SHIFT",
			key = "Tab",
			action = act.Multiple({
				act.SendKey({
					mods = "CTRL",
					key = "b",
				}),
				act.SendKey({
					key = "n",
				}),
			}),
		}, -- FIX: disable binding
		-- {
		-- 	mods = "CMD",
		-- 	key = "`",
		-- 	action = act.Multiple({
		-- 		act.SendKey({ mods = "CTRL", key = "b" }),
		-- 		act.SendKey({ key = "n" }),
		-- 	}),
		-- },
		{
			mods = "CMD",
			key = "~",
			action = act.Multiple({
				act.SendKey({
					mods = "CTRL",
					key = "b",
				}),
				act.SendKey({
					key = "p",
				}),
			}),
		},
	},
}

config.color_scheme = "Tokyo Night"
config.mouse_bindings = { -- Ctrl-click will open the link under the mouse cursor
	{
		event = {
			Up = {
				streak = 1,
				button = "Left",
			},
		},
		mods = "CTRL",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}
return config
