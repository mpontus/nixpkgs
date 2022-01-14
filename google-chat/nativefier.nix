{ pkgs ? import <nixpkgs> { }
, pkgsLinux ? import <nixpkgs> { system = "x86_64-linux"; }
, name
, url
}:
let
  nativefier = pkgs.dockerTools.buildImage {
    name = "nativfier/nativefier";
  };
in nativefier


# stdenv.mkDerivation rec {
#   inherit name;
#   buildInputs = with pkgs; [docker];
#   unpackPhase = ''
#     docker run --rm -v $out:/target/ nativefier/nativefier ${url} /target/
#   '';
# }
