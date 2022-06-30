{ config, pkgs, lib, ... }:

{
  programs = {
    fish = {
      # https://rycee.gitlab.io/home-manager/options.html#opt-programs.fish.enable
      enable = true;

      useBabelfish = true;
      babelfishPackage = pkgs.babelfish;

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
        # Needed to address bug where $PATH is not properly set for fish:
        # https://github.com/LnL7/nix-darwin/issues/122
        for p in (string split : ${config.environment.systemPath})
          if not contains $p $fish_user_paths
            set -g fish_user_paths $fish_user_paths $p
          end
        end

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
        {
          name = "z";
          src = pkgs.fetchFromGitHub {
            owner = "jethrokuan";
            repo = "z";
            rev = "85f863f20f24faf675827fb00f3a4e15c7838d76";
            sha256 = "1kaa0k9d535jnvy8vnyxd869jgs0ky6yg55ac1mxcxm8n0rh2mgq";
          };
        }
      ];
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