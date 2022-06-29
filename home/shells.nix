{ config, pkgs, lib, ... }:

{
  programs = {
    fish = {
      # https://rycee.gitlab.io/home-manager/options.html#opt-programs.fish.enable
      enable = true;

      functions = {
      };

      # Fish abbreviations
      shellAbbrs = {
      };

      # Fish alias : register alias command in fish
      shellAliases = {
        # Nix related
        drb = "darwin-rebuild build --flake ~/.config/nixpkgs/";
        drs = "darwin-rebuild switch --flake ~/.config/nixpkgs/";

        # is equivalent to: nix build --recreate-lock-file
        flakeup = "nix flake update ~/.config/nixpkgs/";
        nb = "nix build";
        nd = "nix develop";
        nf = "nix flake";
        nr = "nix run";
        ns = "nix search";

        # CD to dir
        cn = "cd ~/.config/nixpkgs";
      };

      shellInit = ''
        # Fish color
        set -U fish_color_command 6CB6EB --bold
        set -U fish_color_redirection DEB974
        set -U fish_color_operator DEB974
        set -U fish_color_end C071D8 --bold
        set -U fish_color_error EC7279 --bold
        set -U fish_color_param 6CB6EB
        set fish_greeting
      '';

      plugins = with pkgs.fishPlugins;[
      ];
    };

    # jump like `z` or `fasd`
    zoxide = {
      enable = true;
      enableBashIntegration = config.programs.bashInteractive.enable;
      enableZshIntegration = config.programs.zsh.enable;
      enableFishIntegration = config.programs.fish.enable;
    };

    # Fish prompt and style
    starship = {
      enable = true;
      settings = {
        add_newline = true;
        command_timeout = 1000;
        cmd_duration = {
          format = " [$duration]($style) ";
          style = "bold #EC7279";
          show_notifications = true;
        };
        nix_shell = {
          format = " [$symbol$state]($style) ";
        };
        battery = {
          full_symbol = "🔋 ";
          charging_symbol = "⚡️ ";
          discharging_symbol = "💀 ";
        };
        git_branch = {
          format = "[$symbol$branch]($style) ";
        };
        gcloud = {
          format = "[$symbol$active]($style) ";
        };
      };
    };
  };
}