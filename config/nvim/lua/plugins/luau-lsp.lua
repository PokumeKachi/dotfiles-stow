return {
	"lopi-py/luau-lsp.nvim",
	opts = {
		platform = {
			type = "roblox",
		},
		types = {
			roblox_security_level = "PluginSecurity",
		},
		sourcemap = {
			enabled = true,
			autogenerate = true,
			generator_cmd = { "argon", "sourcemap", "-w", "-n", "-o", "sourcemap.json" },
			rojo_project_file = "default.project.json",
			sourcemap_file = "sourcemap.json",
		},
		plugin = {
			enabled = true,
			port = 3667,
		},
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
}
