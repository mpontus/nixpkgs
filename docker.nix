{ config, pkgs, ... }:

{
  virtualisation.containerd.enable = true;
  virtualisation.docker.enable = true;
  users.users.mpontus.extraGroups = [ "docker" ];
  environment.systemPackages = [ pkgs.docker-compose ];
}
