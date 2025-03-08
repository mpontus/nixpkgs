{ pkgs ? import <nixpkgs> { } }:
pkgs.appimageTools.wrapType2 {
  name = "ResponsivelyApp";
  src = pkgs.fetchurl {
    url =
      "https://github.com/responsively-org/responsively-app-releases/releases/download/v1.12.0/ResponsivelyApp-1.12.0.AppImage";
    hash = "sha256-qW6vEOAUZVHdNmn8QWmBGksIjYXez0IGei/AYrxn1VQ=";
    # sha256 = "e83924a7e28dbe62b63992e1cffe0347c191fcce79c074a18a09427a603ce33a";
  };
}
