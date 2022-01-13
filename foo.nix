# edit this configuration file to define what should be installed on
# your system.  help is available in the configuration.nix(5) man page
# and in the nixos manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    # networking.hostName = "nixos"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.mpontus = {
      isNormalUser = true;
      extraGroups = [ "wheel" "pcspkr" ]; # Enable ‘sudo’ for the user.
    };
  
    environment.homeBinInPath = true;
    # Set your time zone.
    time.timeZone = "Europe/Moscow";
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    networking.useDHCP = false;
    networking.interfaces.enp0s31f6.useDHCP = true;
    networking.interfaces.wlp2s0.useDHCP = true;
  
    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  
    # Select internationalisation properties.
    # i18n.defaultLocale = "en_US.UTF-8";
    # console = {
    #   font = "Lat2-Terminus16";
    #   keyMap = "us";
    # };
    # Enable the X11 windowing system.
    services.xserver.enable = true;
    services.touchegg.enable = true;
    # Enable the GNOME Desktop Environment.
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
    systemd.services."getty@tty1".enable = true;
    systemd.services."autovt@tty1".enable = true;
    services.xserver.displayManager.autoLogin.enable = true;
    services.xserver.displayManager.autoLogin.user = "mpontus";
  
    # Configure keymap in X11
    # services.xserver.layout = "us";
    # services.xserver.xkbOptions = "eurosign:e";
  
    # Enable CUPS to print documents.
    # services.printing.enable = true;
    boot.kernel.sysctl = {
      "net.ipv4.ip_default_ttl" = 65;
    };
  
    # Enable sound.
    sound.enable = true;
    hardware.pulseaudio.enable = true;
  
    fonts = {
      enableDefaultFonts = false;
      fonts = with pkgs; [
        noto-fonts
        noto-fonts-cjk
        # noto-fonts-emoji
        twitter-color-emoji
        liberation_ttf
        fira-code
        fira-code-symbols
        mplus-outline-fonts
        dina-font
        proggyfonts
        source-code-pro
        gentium
      ];
    };
    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;
    # programs.vim.defaultEditor = true;
    nixpkgs.config.allowUnfree = true;
    programs.steam.enable = true;
  
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      coreutils
      inetutils
      gnumake
      gcc
      curl
      wget
      python
    ];
  
    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    programs.vim.defaultEditor = true;
  
    # List services that you want to enable:
  
    # Enable the OpenSSH daemon.
    # services.emacs = {
    #   enable = true;
    #   defaultEditor = true;
    # };
    # services.touchegg.enable = true;
    services.locate = {
      enable = true;
      locate = pkgs.mlocate;
      localuser = null;
      interval = "1h";
    };
  services.openvpn.servers = let
    pkg = pkgs.fetchzip {
      url = "https://www.privateinternetaccess.com/openvpn/openvpn.zip";
      sha256 = "0vxm18gzn7fi7dd85rmj3hnbral568bgczhvgi8cb348lx5i23v4";
      stripRoot = false;
    };
    # TODO: Use secure credentials storage
    authUserPass = {
      username = "p7919690";
      password = "n3imRaNv35";
    };
    pia = name: {
      inherit authUserPass;
      config = '' config ${pkg}/${name}.ovpn '';
      autoStart = false;
    };
  in with builtins;
    listToAttrs
      (map (name: { inherit name; value = pia name; })
        (map (lib.removeSuffix ".ovpn")
          (attrNames (readDir pkg))));
  
  
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
  nixpkgs.config.allowUnfree = true;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  virtualisation.libvirtd.enable= true;
  boot.kernelModules = ["kvm-intel" "kvm-amd"];
  environment.systemPackages = [pkgs.virt-manager];
  users.extraGroups.vboxusers.members = ["mpontus"];
    security.sudo.extraConfig = ''
  
    '';

  # this value determines the nixos release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. it‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateversion = "21.05"; # did you read the comment?
}
