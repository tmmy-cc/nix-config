{ self, config, pkgs, ... }:

{
  nix = {
    # Enable linux builder qemu VM
    linux-builder = {
      enable = false;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      ephemeral = true;
      maxJobs = 4;
      config = {
        nix.settings = {
          experimental-features = [ "nix-command" "flakes" ];
        };
        users.users."builder".extraGroups = [ "wheel" ];
        security.sudo.wheelNeedsPassword = false;
        boot.binfmt.emulatedSystems = [ "x86_64-linux" ];
        virtualisation = {
          darwin-builder = {
            diskSize = 40 * 1024;
            memorySize = 12 * 1024;
          };
          cores = 8;
        };
      };
    };

    settings = {
      # Prerequisite for using linux builder
      trusted-users = [ "@admin" ];

      # Enable nix-command and flakes.
      experimental-features = [ "nix-command" "flakes" ];
    };

    # Disable Nix channels since we have a flake based config
    channel.enable = false;
  };

  # Enable rossetta builder
  nix-rosetta-builder = {
    enable = true;
    memory = "12GiB";
    cores = 8;
    onDemand = true;
  };

  # Debug Linux builder
  # launchd.daemons.linux-builder = { serviceConfig = { StandardOutPath = "/var/log/darwin-builder.log"; StandardErrorPath = "/var/log/darwin-builder.log"; }; };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Make vim the default editor
  programs.vim = {
    #defaultEditor = true;
  };

  programs.zsh = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
  };

  services.karabiner-elements = {
    enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # monitoring tools
    btop
    #iotop
    #iftop
    #strace
    #ltrace
    #lsof
    # editor
    vim
    # python
    python3
    # utils
    wget
    curl
    mkalias
  ];

  environment.variables = {
    TERMINFO = "/usr/share/terminfo/";
  };

  homebrew = {
    enable = true;
    brews = [
      "mas"
      "ffmpeg"
      #"aarch64-unknown-linux-gnu"
      #"x86_64-unknown-linux-gnu"
    ];
    casks = [
      "mac-mouse-fix"
      "iina"
      "the-unarchiver"
      "battery"
      "coconutbattery"
      "amethyst"
      "chromium"
      "wine-stable"
      #"aerospace"
      #"ghostty"
    ];
    masApps = {
     #"Yoink" = 457622435;
    };
    onActivation.cleanup = "zap";
  };

  system.activationScripts.extraActivation.text = ''
    softwareupdate --install-rosetta --agree-to-license
  '';

  system.defaults = {
    dock.autohide  = true;
    dock.persistent-apps = [
      "${pkgs.alacritty}/Applications/Alacritty.app"
      "/System/Cryptexes/App/System/Applications/Safari.app"
      "${pkgs.obsidian}/Applications/Obsidian.app"
      "/System/Applications/Mail.app"
      "/System/Applications/Calendar.app"
    ];
    finder.FXPreferredViewStyle = "clmv";
    loginwindow.GuestEnabled  = false;
    NSGlobalDomain.AppleICUForce24HourTime = true;
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
    NSGlobalDomain.KeyRepeat = 2;
  };

  # Set home directory
  users.users.thomasstahl.home = "/Users/thomasstahl";

  # Allow Touch ID authentication
  security.pam.enableSudoTouchIdAuth = true;

  # Set Git commit hash for darwin version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
