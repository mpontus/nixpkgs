# edit this configuration file to define what should be installed on
# your system.  help is available in the configuration.nix(5) man page
# and in the nixos manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # include the results of the hardware scan.
      ./hardware-configuration.nix
      
    ];

  environment.systemPackages = with pkgs; [
    pkgs.virt-manager
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Define a user account. Don't forget to set a password with ‘passwd’
  users.users.mpontus = {
    isNormalUser = true;
    extraGroups = [ "wheel" "pcspkr" ]; # Enable ‘sudo’ for the user.
  };
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.vboxnet0.useDHCP = true;
  networking.interfaces.virbr0.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;
  virtualisation.libvirtd.enable= true;
  boot.kernelModules = ["kvm-intel" "kvm-amd"];
  security.sudo.extraConfig = ''
      Defaults        env_reset,timestamp_timeout=30
    '';
  # Use vim as default editor
  programs.vim.defaultEditor = true;
  services.xserver.enable = true;
  # Enable the GNOME Desktop Environment
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # this value determines the nixos release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. it‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # did you read the comment?
}
