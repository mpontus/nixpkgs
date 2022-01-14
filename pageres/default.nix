{ pkgs ? import <nixpkgs> {} }:

let
  node2nix = import ./node2nix.nix { inherit pkgs; };
  package = node2nix.pageres-cli.override {
    preInstallPhases = "puppeteerSkipDownload";
    puppeteerSkipDownload = ''
      export PUPPETEER_SKIP_DOWNLOAD=1
    '';
  };
in pkgs.stdenv.mkDerivation {
  name = "pageres";
  src = package;

  buildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    ln -s $src/bin/pageres $out/bin/
    wrapProgram $out/bin/pageres \
      --set PUPPETEER_EXECUTABLE_PATH ${pkgs.chromium.outPath}/bin/chromium
  '';
}

# Taken from https://github.com/justinwoo/my-blog-posts/blob/master/posts/2019-08-23-using-puppeteer-with-node2nix.md
