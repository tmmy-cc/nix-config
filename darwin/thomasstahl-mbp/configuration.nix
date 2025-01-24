{ self, config, pkgs, ... }:

{
  nix = {
    # Enable linux builder qemu VM
    linux-builder = {
      enable = true;
      ephemeral = true;
      maxJobs = 4;
      config = {
        #services.openssh.enable = true;
        virtualisation = {
          #qemu.package = pkgs.qemu-apple-m4;
          darwin-builder = {
            diskSize = 20 * 1024;
            memorySize = 8 * 1024;
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
      "aarch64-unknown-linux-gnu"
      "x86_64-unknown-linux-gnu"
    ];
    casks = [
      #"sanesidebuttons"
      "mac-mouse-fix"
      "iina"
      "the-unarchiver"
      "battery"
      "coconutbattery"
      "amethyst"
      #"aerospace"
      #"ghostty"
    ];
    masApps = {
     #"Yoink" = 457622435;
    };
    onActivation.cleanup = "zap";
  };

  system.activationScripts.applications.text = let
    env = pkgs.buildEnv {
      name = "system-applications";
      paths = config.environment.systemPackages;
      pathsToLink = "/Applications";
    };
  in
    pkgs.lib.mkForce ''
      # Set up applications.
      echo "setting up /Applications..." >&2
      rm -rf /Applications/Nix\ Apps
      mkdir -p /Applications/Nix\ Apps
      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read -r src; do
        app_name=$(basename "$src")
        echo "copying $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      done
    '';

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
