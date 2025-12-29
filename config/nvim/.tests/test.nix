{
    lib,
    pkgs,
    ...
}:
{
    environment.systemPackages = with pkgs; [
        (retroarch.withCores (
            cores: with cores; [
                genesis-plus-gx
                snes9x
                beetle-psx-hw
            ]
        ))

        flare

        superTux
        superTuxKart

        # melonDS
        # mgba

        # minecraft

        # mcpelauncher-client
        # mcpelauncher-ui-qt
        #
        # prismlauncher
        # libGL
        # cairo
        # xorg.libXxf86vm
        # minecraft
        # appimage-run
        # openjdk17
        # gtk3
        # glib
        # gsettings-desktop-schemas
        # fontconfig
        # freetype
        # stdenv.cc.cc.lib
    ];
}
