{ pkgs ? import <nixpkgs> {} }: with pkgs; let 
  deps = with xorg; [
    libcxx systemd libpulseaudio libdrm mesa
    stdenv.cc.cc alsa-lib atk at-spi2-atk at-spi2-core cairo cups dbus expat fontconfig freetype
    gdk-pixbuf glib gtk3 libnotify libX11 libXcomposite libuuid
    libXcursor libXdamage libXext libXfixes libXi libXrandr libXrender
    libXtst nspr nss libxcb pango libXScrnSaver
    libappindicator-gtk3 libdbusmenu
    ffmpeg
    libxshmfence
    # stdenv.cc.cc
    # glib
    # xorg.libX11
    # xorg.libXScrnSaver 
    # xorg.libXcomposite
    # xorg.libXdamage
    # xorg.libXfixes
    # xorg.libXrandr
    # xorg.libXext
    # libdrm
    # expat
    libxkbcommon
    # ffmpeg
    # mesa
    # cups
    # dbus
    # nss
    # atk
    # cairo
    # pango
    # gtk3
    # # libsnpr4
    # at-spi2-atk
    # alsa-lib
    # libappindicator-gtk2
    # qt5.qtbase
    # qt5.qtsvg
    # qt5.qtmultimedia
  ];
in qt5.mkDerivation rec {
  pname = "roamresearch";
  version = "0.0.13";
  src = fetchurl {
    url = "https://roam-electron-deploy.s3.us-east-2.amazonaws.com/roam-research_${version}_amd64.deb";
    sha256 = "09aa9d9636fbc04cba89b76c0a44f40b5f26bf1ce55e9d7162d8d402e296e6ad";
  };
  buildInputs = [tree dpkg which] ++ deps;

  unpackPhase = ''
    dpkg-deb -x $src unpacked
    mv unpacked $out
    mkdir $out/bin
    ln -s $out/opt/Roam\ Research/roam-research $out/bin
  '';
  
  installPhase = ''
    interpreter=$(patchelf --print-interpreter $(readlink -f $(which patchelf)))
    ldpath="${lib.makeLibraryPath deps}:$out/opt/Roam Research"
    patchelf --set-interpreter $interpreter --set-rpath "$ldpath" $out/bin/roam-research
    # ldd $out/bin/roam-research | grep "not found" && exit 1
    # sed -e "s!/opt/Roam Research!$out!" \
    #     -e "s!/usr/bin/toptracker!$out/bin/TopTracker!" \
    #     -i $out/share/applications/toptracker.desktop
  '';
  
  dontStrip = true;
  dontPatchELF = true;
}

  
