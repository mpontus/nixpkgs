name: { pkgs, ... }:
let
  src = pkgs.writeTextDir "src/package.json" (
    builtins.toJSON { dependencies = [ "create-react-app" ]; }
  );
  package-json = pkgs.writeText "package.json" (
    builtins.toJSON { dependencies = [ name ]; }
  );
  installed = pkgs.runCommand "install" {
    nativeBuildInputs = [ pkgs.nodejs pkgs.yarn ];
  } ''
    mkdir $out
    cd $out
    cp ${package-json} .
    yarn install
  '';
  yarn2nix = pkgs.callPackage (
    builtins.fetchTarball {
      url = https://github.com/nix-community/yarn2nix/archive/master.tar.gz;
    }
  ) { src = ./.; };
  # y2n = pkgs.runCommandLocal "foobar" { preferLocalBuild = true; } ''
  #   cp -R ${yarn2nix} $out/
  # '';
in installed
# in stdenv.mkDerivation {
#   nativeBuildInputs = [pkgs.yarn];
#   installStage = ''
#     cp -R ${src} $out/
#     cd $out/
#     yarn install
#   '';
# }
