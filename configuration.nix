# edit this configuration file to define what should be installed on
# your system.  help is available in the configuration.nix(5) man page
# and in the nixos manual (accessible by running ‘nixos-help’).
{ config, lib, pkgs, ... }:

{
  imports =
    [ # include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  environment.systemPackages = with pkgs; [
    pkgs.virt-manager
    firefox
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "nixos"; # Define your hostname.
  # Set your time zone.
  time.timeZone = "Europe/Moscow";
  users.users.root.initialPassword = "nixos";
  users.users.mpontus = {
    isNormalUser = true;
    hashedPassword = "$6$QrKXg5g6nEHsWbkm$GdlWBtzXoQo7djWCJcMYcAZ/Zypk13Bq6nETchLc49hstumtoZ2q0tKvvrX3CLxqEmnZhDA8/0aw/Sen9mo5L/";
    extraGroups = [ "wheel" "pcspkr" ];
  };
  environment.homeBinInPath = true;
  networking.useDHCP = false;
  networking.interfaces.wlp2s0.useDHCP = true;
  sound.enable = true;
  hardware.pulseaudio.enable = true;
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
  virtualisation.libvirtd.enable= true;
  boot.kernelModules = ["kvm-intel" "kvm-amd"];
  nix = {
    package = pkgs.nixUnstable; # or versioned attributes like nix_2_4
    # extraOptions = ''
    #   experimental-features = nix-command flakes
    # '';
  };
  home-manager.users.mpontus = { pkgs, ... }: {
    imports = [
      
    ];
    home.packages = with pkgs; [
      ag
      ripgrep
      htop
      awscli2
      cmake
      fd
      file
      git
      gnupg
      hub
      imagemagick
      jq
      ledger
      libtool
      ncdu
      nodejs
      pass
      pkgs.nodePackages.node2nix
      ripgrep
      tree
      tree
      unzip
      wmctrl
      xclip
      xdotool
      yarn
      gnome.dconf-editor
        tilda
        tridactyl-native
        chromium
        deluge
        pavucontrol
        tdesktop
        # tor-browser-bundle-bin
        slack
        vscode
        obsidian
        discord
        vlc
        pkgs.gnome.gnome-tweaks
        obs-studio
        element-desktop
    ];
    nixpkgs.config.packageOverrides = pkgs: {
      nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
    };
    programs.bash = {
      enable = true;
      historySize = 100000;
      historyFileSize = 100000;
      historyControl = ["ignoredups" "erasedups"];
      initExtra = ''
          source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
          export PATH="$HOME/.npm-packages/bin:$PATH"
        '';
      # bashrcExtra = ''
      #   export PROMPT_COMMAND="history -a; history -c; history -r"
      # '';
      enableVteIntegration = true;
    };
    
    dconf.settings = {
      "ca/desrt/dconf-editor" = { show-warning = false; };
    } // (lib.trivial.pipe {
      "<Super>e" = {
          name = "Switch to Emacs";
          command = "launch-or-raise  -W emacs emacs";
      };
      "<Shift><Super>e" = {
          name = "Switch to Element";
          command = "launch-or-raise -r -W element element-desktop";
      };
      "<Super>w" = {
          name = "Switch to Firefox";
          command = "launch-or-raise -r -c 'firefox' \"Mozilla Firefox\"";
      };
      "<Shift><Super>c" = {
          name = "Switch to Chromium";
          command = "launch-or-raise -W chromium-browser -c chromium-browser";
      };
      "<Super>t" = {
          name = "Switch to Telegram";
          command = "launch-or-raise -r -c telegram-desktop Telegram";
      };
      "<Shift><Super>w" = {
          name = "Switch to Tor Browser";
          command = "launch-or-raise -r -c 'tor-browser' \"Tor Browser\"";
      };
      "<Super>m" = {
          name = "Open System Monitor";
          command = "launch-or-raise  -W gnome-system-monitor gnome-system-monitor";
      };
      "<Super>r" = {
          name = "Switch to Roam";
          command = "launch-or-raise -W \"roam research\" roam-research";
      };
      "<Super>c" = {
          name = "Switch to Console";
          command = "launch-or-raise -W gnome-terminal-server -c gnome-terminal";
      };
      "<Super>s" = {
          name = "Switch to Slack";
          command = "launch-or-raise -c slack Slack";
      };
      "<Super>i" = {
          name = "Switch to Obsidian";
          command = "obsidian";
      };
      "<Super>a" = {
          name = "Switch to Amazing Marvin";
          command = "launch-or-raise  Marvin";
      };
      "<Super>v" = {
          name = "Switch to VSCode";
          command = "launch-or-raise -r -W Code code";
      };
      "<Shift><Super>t" = {
          name = "Switch to TopTracker";
          command = "launch-or-raise -W toptracker -c TopTracker";
      };
    } [
        (lib.attrsets.mapAttrsToList (binding: { name, command }: {
            inherit binding name command;
        }))
        (lib.lists.imap0 (i: value: {
            name = "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${toString(i)}";
            inherit value;
        }))
        lib.attrsets.listToAttrs
      ]
    );
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
      "slack"
      "vscode"
      "discord"
      "obsidian"
    ];
  };
  security.sudo.extraConfig = ''
      Defaults        env_reset,timestamp_timeout=30
    '';
  # Use vim as default editor
  programs.vim.defaultEditor = true;
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  systemd.services."getty@tty1".enable = true;
  systemd.services."autovt@tty1".enable = true;
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "mpontus";
  services.xserver.windowManager.xmonad.enable = true;
  services.emacs.enable = true;
  services.emacs.package =
    let emacsPackages = pkgs.emacsPackagesFor pkgs.emacs;
    in emacsPackages.emacsWithPackages (epkgs: [epkgs.vterm]);
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
  # this value determines the nixos release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. it‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # did you read the comment?
}
