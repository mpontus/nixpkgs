{ pkgs ? import <nixpkgs> {} }: with pkgs; let
in stdenv.mkDerivation rec {
  pname = "qwertickle";
  version = "master";

  src = builtins.fetchTarball {
    url = "https://github.com/aitjcize/qwertickle/archive/${version}.tar.gz";
  };

  buildInputs = [ # autogen
    autoconf automake libtool glib
    gtk2
    # libgstreamer
    # libxtst
    xorg.libxcb
    # xorg.libxorg
  ];

  buildPhase = ''
    ls /bin
    sed -i 's!AM_VERSION=-1.14!AM_VERSION=-1.13!' autogen.sh
    ./autogen.sh
    ./configure
    make
  '';
  # preConfigure = ''
  #   LIBTOOLIZE=libtoolize ./autogen.sh
  # '';
  # patchPhase = ''
  #   aclocal --version
  #   # substituteInPlace Makefile.am --replace "/usr" ""
  # '';
  # configurePhase = "./autogen.sh";
  # installFlags = [ "DESTDIR=$(out)" ];
}
