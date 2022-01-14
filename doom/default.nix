# -*- compile-command: "nix-build"; -*-
{ pkgs ? import <nixpkgs> {}, ... }:
with pkgs;
let
  # nix-doom-emacs = builtins.fetchTarball {
  #   url = https://github.com/nix-community/nix-doom-emacs/archive/master.tar.gz;
  # };
  # doom = pkgs.callPackage nix-doom-emacs {
  #   doomPrivateDir = ./doom.d;  # Directory containing your config.el init.el
  # };
  # doom-icon = pkgs.fetchurl {
  #   url = "https://raw.githubusercontent.com/eccentric-j/doom-icon/master/cute-doom/doom.png";
  #   sha256 = "15jv8d5zz583467wxdjgxl7z1rqva259k2dv3dwdgh1hjpzp9ydl";
  # };
  # doom-desktop-item = makeDesktopItem {
  #   name = "doom-emacs";
  #   desktopName = "Doom Emacs";
  #   icon = doom-icon;
  #   exec = "doom";
  # };
  # doom-wrapped = runCommand "doom-wrapped" {} ''
  #   mkdir -p $out/bin
  #   ln -s ${doom}/bin/emacs $out/bin/doom
  #   ln -s ${doom-desktop-item}/share $out/
  # '';

  # emacs = emacsPackages.emacsWithPackages (epkgs: []);
  doom = fetchGit {
    url = "https://github.com/hlissner/doom-emacs/";
  };
  # emacs-overlay = builtins.fetchTarball {
  #   url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
  # };
  # overlay = callPackage emacs-overlay {};
  # emacs = pkgs.emacs;
  # emacs-pkgs = pkgs.emacsPackagesFor pkgs.emacs;
  # emacs = emacs-pkgs.emacs;
  default.el = writeTextDir "share/emacs/site-lisp/default.el" ''
    (when (> emacs-major-version 26)
          (load "${src}/early-init.el"))
    (load "${src}/init.el")
  '';
  site-start.el = writeTextDir "share/emacs/site-lisp/default.el" ''
    ;; (load "${emacs}/share/emacs/site-lisp/site-start.el")
    (when (> emacs-major-version 26)
          (load "${src}/early-init.el"))
    (load "${src}/init.el")
  '';
  # emacs-with-site-lisp = runCommand "emacs" {
  #   preferNativeBuild = true;
  #   buildInputs = [rsync];
  # } '' rsync -avz ${emacs}/* ${site-lisp}/* $out '';
  # emacs-pkgs = emacs-overlay.emacsPackagesFor emacs;
  # doom-emacs = emacs-pkgs.emacsWithPackages (epkgs: [emacs-pkgs]);
  doom-emacs = emacs.pkgs.withPackages (epkgs: [doom default.el site-start.el]);
  # nix-doom-emacs = builtins.fetchTarball {
  #   url = https://github.com/nix-community/nix-doom-emacs/archive/master.tar.gz;
  # };
  # doom-emacs = pkgs.callPackage nix-doom-emacs {
  #   doomPrivateDir = ./doom.d.;  # Directory containing your config.el init.el
  # };
  # site-start = pkgs.writeTextFile {
  #   name = "site-start.el";
  #   text = ''
  #     (when (> emacs-major-version 26)
  #           (load "${doom-emacs}/early-init.el"))
  #     (load "${doom-emacs}/init.el")
  #   '';
  # };
  # emacs = pkgs.emacs;
  # site-lisp = writeTextDir "share/emacs/site-lisp/site-start.el" ''
  #   (load "${emacs}/share/emacs/site-lisp/site-start.el")
  #   (when (> emacs-major-version 26)
  #         (load "${src}/early-init.el"))
  #   (load "${src}/init.el")
  # '';
  # emacs2 = emacsWithPackages (_: []);
  # doom-emacs = emacsWithPackages (epkgs: [site-lisp]);


  # emacs = pkgs.emacs.override ({ ... }: {
  #   siteStart = site-start;
  # });
  # emacs = emacsOverlay.emacs;
  # emacs = emacsWithPackages (epkgs: [doom-emacs]) ;
  # emacs-wrapped = runCommand "site-lisp" {
  #   preferLocalBuild = true;
  #   nativeBuildInputs = [emacs tree rsync coreutils rsync];
  #   addEmacsNativeLoadPath = true;
  # } ''
  #   rsync -arv ${emacs}/* $out/
  #   rsync -arv ${site-lisp}/* $out/
  #   addEmacsVars "$out"
  # '';
in doom-emacs
