{ self, config, pkgs, nix-homebrew, ... }:

{
  # Enable nix-command and flakes.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
    ];
    casks = [
     #"sanesidebuttons"
     "mac-mouse-fix"
     "iina"
     "the-unarchiver"
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
  users.users.tmmy.home = "/Users/tmmy";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
