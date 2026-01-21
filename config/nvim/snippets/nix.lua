local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

function tab(tab_count, tab_space)
	return string.rep(" ", (tab_count or 1) * (tab_space or 4))
end

return {
	s("template-flake-rust", {
		t({ "{", tab() .. 'description = "' }),
		i(1, "description"),
		t({ '";', tab() .. 'inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-' }),
		i(2, "unstable"),
		t({
			'";',
			tab() .. "outputs =",
			tab(2) .. "{ self, nixpkgs }:",
			tab(2) .. "let",
			tab(3) .. 'systems = [ "x86_64-linux" ];',
			tab(3) .. "forAllSystems = nixpkgs.lib.genAttrs systems;",
			"",
			tab(3) .. "perSystem = system:",
			tab(4) .. "let",
			tab(5) .. "pkgs = import nixpkgs { inherit system; };",
			tab(5) .. "libs = with pkgs; [",
			tab(6) .. "wayland",
			tab(5) .. "];",
			tab(5) .. "tools = with pkgs; [ ",
			tab(6) .. "pkg-config",
			tab(5) .. "];",
			tab(5) .. "common = { buildInputs = libs; nativeBuildInputs = tools; };",
			tab(4) .. "in { inherit pkgs libs tools common; };",
			tab(2) .. "in {",
			tab(3) .. "packages = forAllSystems (system:",
			tab(4) .. "let ps = perSystem system; in {",
			tab(5) .. "default = ps.pkgs.rustPlatform.buildRustPackage (ps.common // {",
			tab(6) .. 'pname = "',
		}),
		i(3, "package-name"),
		t({
			'";',
			tab(6) .. 'version = "0.1.0";',
			tab(6) .. "src = ps.pkgs.lib.cleanSource ./.;",
			tab(6) .. "cargoLock.lockFile = ./Cargo.lock;",
			tab(5) .. "});",
			tab(4) .. "}",
			tab(3) .. ");",
			"",
			tab(3) .. "devShells = forAllSystems (system:",
			tab(4) .. "let ps = perSystem system; in {",
			tab(5) .. "default = ps.pkgs.mkShell (ps.common // {",
			tab(6) .. "shellHook = ''",
			tab(7) .. "export SHELL=${ps.pkgs.bashInteractive}/bin/bash",
			tab(7) .. "export LD_LIBRARY_PATH=${ps.pkgs.lib.makeLibraryPath ps.libs}:$LD_LIBRARY_PATH",
			tab(6) .. "'';",
			tab(5) .. "});",
			tab(4) .. "}",
			tab(3) .. ");",
			tab(2) .. "};",
			"}",
		}),
	}),
}
