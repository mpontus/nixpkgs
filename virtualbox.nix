{ config, pkgs, ... }:

{
   nixpkgs.config.allowUnfree = true;
   virtualisation.virtualbox.host.enable = true;
   virtualisation.virtualbox.host.enableExtensionPack = true;
   users.extraGroups.vboxusers.members = ["mpontus"];
   virtualisation.libvirtd.enable= true;
   boot.kernelModules = ["kvm-intel" "kvm-amd"];
   environment.systemPackages = [pkgs.virt-manager];

}
