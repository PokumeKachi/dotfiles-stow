local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local function indent(level)
    level = level or 1
    local unit = vim.o.expandtab
        and string.rep(" ", vim.o.shiftwidth)
        or "\t"

    return unit:rep(level)
end

return {
	s("template-flake-rust", {
		t({ "{", indent() .. 'description = "' }),
		i(1, "description"),
		t({ '";', indent() .. 'inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-' }),
		i(2, "unstable"),
		t({
			'";',
			indent() .. "outputs =",
			indent(2) .. "{ self, nixpkgs }:",
			indent(2) .. "let",
			indent(3) .. 'systems = [ "x86_64-linux" ];',
			indent(3) .. "forAllSystems = nixpkgs.lib.genAttrs systems;",
			"",
			indent(3) .. "perSystem = system:",
			indent(4) .. "let",
			indent(5) .. "pkgs = import nixpkgs { inherit system; };",
			indent(5) .. "libs = with pkgs; [",
			indent(6) .. "wayland",
			indent(5) .. "];",
			indent(5) .. "tools = with pkgs; [ ",
			indent(6) .. "pkg-config",
			indent(5) .. "];",
			indent(5) .. "common = { buildInputs = libs; nativeBuildInputs = tools; };",
			indent(4) .. "in { inherit pkgs libs tools common; };",
			indent(2) .. "in {",
			indent(3) .. "packages = forAllSystems (system:",
			indent(4) .. "let ps = perSystem system; in {",
			indent(5) .. "default = ps.pkgs.rustPlatform.buildRustPackage (ps.common // {",
			indent(6) .. 'pname = "',
		}),
		i(3, "package-name"),
		t({
			'";',
			indent(6) .. 'version = "0.1.0";',
			indent(6) .. "src = ps.pkgs.lib.cleanSource ./.;",
			indent(6) .. "cargoLock.lockFile = ./Cargo.lock;",
			indent(5) .. "});",
			indent(4) .. "}",
			indent(3) .. ");",
			"",
			indent(3) .. "devShells = forAllSystems (system:",
			indent(4) .. "let ps = perSystem system; in {",
			indent(5) .. "default = ps.pkgs.mkShell (ps.common // {",
			indent(6) .. "shellHook = ''",
			indent(7) .. "export SHELL=${ps.pkgs.bashInteractive}/bin/bash",
			indent(7) .. "export LD_LIBRARY_PATH=${ps.pkgs.lib.makeLibraryPath ps.libs}:$LD_LIBRARY_PATH",
			indent(6) .. "'';",
			indent(5) .. "});",
			indent(4) .. "}",
			indent(3) .. ");",
			indent(2) .. "};",
			"}",
		}),
	}),
}
