{ pkgs ? import <nixpkgs> {}, ... }:

pkgs.callPackage ./nativefier.nix {
    name = "gmail";
    url = "https://gmail.com/";
}
