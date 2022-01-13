{ config, pkgs, ... }:

{
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        # Disable = "Headset";
        Enable = "Source,Sink,Headet,Media,Socket";
        # Disable = "Socket";
        # MultiProfile = "multiple";
      };
    };
  };
  # environment.systemPackages = [ pkgs.blueman ];
  services.blueman.enable = true;
}
