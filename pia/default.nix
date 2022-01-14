{ pkgs ? import <nixpkgs> {}, stdenv }: 
with pkgs; let
  pname = "pia";
  version = "3.1.2-06767";
  drvName = "${pname}-${version}";
  deps = [
    stdenv.cc.cc
    glibc
    libnl
    openssl
    libxkbcommon
    qt5.qtbase
    qt5.qtdeclarative
    qt5.qtquickcontrols2
  ];
  installEnv = buildFHSUserEnv {
    name = "${drvName}-install-env";
    targetPkgs = pkgs:
      with pkgs; [
        zlib
        glib
        tree
        stdenv.cc.cc
        glibc
        libnl
        openssl
        libxkbcommon
        qt5.qtbase
        qt5.qtdeclarative
        qt5.qtquickcontrols2
        libGL
      ];
    runScript = "bash";
  };
  pia = qt5.mkDerivation rec {
    inherit pname version;
    src = pkgs.fetchurl {
      url = "https://installers.privateinternetaccess.com/download/pia-linux-${version}.run"; 
      sha256 = "2d7b983beafb272b9d229b3838c24eb23a3d8e6edd84e257d406af057a1145e8";
    };
    buildInputs = [ which coreutils procps iproute2 shadow ] ++ deps;
    nativeBuildInputs = [ sudo ];
    patches = [./pia.patch];
    unpackPhase = ''
      /bin/sh $src --noexec --target .
    '';
    installPhase = ''
      interpreter=$(patchelf --print-interpreter $(readlink -f $(which patchelf)))
      ldpath=${lib.makeLibraryPath deps}:$out/opt/piavpn/lib
      for file in piafiles/bin/*; do
          patchelf --set-interpreter $interpreter --set-rpath $ldpath $file || true
      done
      # patchShebangs install.sh piafiles/bin/*.sh
      substituteInPlace install.sh \
        --replace "/opt/" "$out/opt/" \
        --replace "/usr/" "$out/usr/" \
        --replace "/bin/cp " "cp " \
        --replace "sudo " " "
      LD_LIBRARY_PATH="$ldpath:$(pwd)/piafiles/lib" \
        sh install.sh --skip-service || true
      for dir in $out/opt/piavpn/*; do 
        ln -s $dir $out/
      done
      /bin/sh install.sh
    '';

    dontPatchELF = true;
    # preferLocalBuild = true;
  };
  fhsEnv = buildFHSUserEnv {
    name = "${drvName}-fhs-env";
    multiPkgs = pkgs:
      with pkgs; [
        glibc
        gcc
        stdenv.cc.cc
      ];
    targetPkgs = pkgs:
      with pkgs; [
        pia
        bash
        glib
        libGL
        zlib
        # libXau
        # libXdmcp
        # libc
        # gcc
        # stdenv.cc.cc
        # glibc
        # libnl
        # openssl
        # libxkbcommon
        qt5.qtbase
        qt5.qtdeclarative
        qt5.qtquickcontrols2
        xorg.libX11
        xorg.libXau
        xorg.libXdmcp
        # pkgconfig                                                                                                                                                                            
        # openssl.dev
        # bash
        # glibc
        # which
        # sudo
      ];
    runScript = "sh";
  };
  mkPia = runCommand "${drvName}-install" {
    preferLocalBuild = true;
    allowSubstitutes = false;
    passthru = { unwrapped = pia; };
  } ''
    ${fhsEnv}/bin/${drvName}-fhs-env ${pia}/install.sh --skip-service
  '';
in pia
