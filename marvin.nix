{ pkgs ? import <nixpkgs> {} }:
pkgs.appimageTools.wrapType2 {
  name = "Marvin";
  src = pkgs.fetchurl {
    url = "https://amazingmarvin.s3.amazonaws.com/Marvin-1.61.0.AppImage";
    sha256 = "e83924a7e28dbe62b63992e1cffe0347c191fcce79c074a18a09427a603ce33f";
  };
}
