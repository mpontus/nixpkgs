{ pkgs, config, ... }: {
  
  nix.extraOptions = ''
    plugin-files = ${pkgs.nix-plugins_4.override { nix = config.nix.package; }}/lib/nix/plugins/libnix-extra-builtins.so
  '';
  
  environment.systemPackages = [ pkgs.nixops ];
}
