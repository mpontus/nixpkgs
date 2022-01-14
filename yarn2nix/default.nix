name: { stdenv,  lib, pkgs, ... }:
let
  site-lisp = pkgs.writeTextDir "package.json" builtins.toJSON {
    depdendencies = [ name ];
  };
  yarn2nix = pkgs.callPackage (
    builtins.fetchTarball {
      url = https://github.com/nix-community/yarn2nix/archive/master.tar.gz;
    }
  ) {
    src = pkgs.runCommandLocal "install" {
      nativeBuildInputs = [ pkgs.yarn ];
    } '' yarn install '';
  };
  src = pkgs.writeTextDir "package.json" builtins.toJSON {
    depdendencies = [ name ];
  };
in stdenv.mkDerivation {
  inherit name;
  nativeBuildInputs = [pkgs.yarn];
  installStage = ''
    cp -R ${src} $out/
    cd $out/
    yarn install
  '';
}
