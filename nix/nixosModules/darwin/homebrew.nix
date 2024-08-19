{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  brewEnabled = config.homebrew.enable;
in
{
  environment.shellInit =
    mkIf brewEnabled # bash
      ''
        eval "$(${config.homebrew.brewPrefix}/brew shellenv)"
      '';

  system.activationScripts.preUserActivation.text =
    mkIf brewEnabled # bash
      ''
        if [ ! -f ${config.homebrew.brewPrefix}/brew ]; then
          ${pkgs.bash}/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
      '';

  homebrew.enable = true;
  homebrew.onActivation.cleanup = "zap";
  homebrew.global.brewfile = true;

  homebrew.taps = [
    "homebrew/services"
  ];

  homebrew.masApps = {
    Slack = 803453959;
    CopyClip = 595191960;
    WhatsApp = 310633997;
  };

  homebrew.casks = [
    ##############
    # Misc
    ##############
    "shottr"
    "iina"
    "hiddenbar"
    
    ##############
    # Development
    ##############
    "jetbrains-toolbox"
    "visual-studio-code"
    "orbstack"
    "postman"

    ##############
    # Productivity
    ##############
    "obs"
    "telegram"
    "appcleaner"
    "logi-options-plus"
    "calibre"
    "arc"
    "publish-or-perish"
  ];

  homebrew.brews = [
    ##############
    # Development
    ##############
    "mockery"
    "golang-migrate"
    "ffmpeg"
  ];

}