{
  description = "Gifa's home";

  inputs = {
    # Package sets
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-22.05-darwin";
    nixpkgs-unstable.url = github:NixOS/nixpkgs/nixpkgs-unstable;

    # Environment/system management
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # Other sources
  };

  outputs = { self, darwin, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (darwin.lib) darwinSystem;
      inherit (inputs.nixpkgs-unstable.lib) attrValues makeOverridable optionalAttrs singleton;

      # Configuration for `nixpkgs`
      nixpkgsConfig = {
        config = { allowUnfree = true; };
        overlays = attrValues self.overlays ++ singleton (
          # Sub in x86 version of packages that don't build on Apple Silicon yet
          final: prev: (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
            inherit (final.pkgs-x86)
              nix-index;
          })
        );
      };
    in
    {
      darwinConfigurations = rec {
        # Macbook Pro Intel Chip
        gifaeriyanto = darwinSystem {
          system = "x86_64-darwin";
          modules = attrValues self.darwinModules ++ [
            # Main `nix-darwin` config
            ./configuration.nix
            # `home-manager` module
            home-manager.darwinModules.home-manager
            (
              { pkgs, ... }:
              {
                nixpkgs = nixpkgsConfig;

                # Configure default shell for gifaeriyanto to fish
                users.users.gifaeriyanto.shell = pkgs.fish;
                # Somehow this 👆 doesn't work.
                # So I did this instead: https://stackoverflow.com/a/26321141/3187014
                # 
                # ```shell
                # $ sudo sh -c "echo $(which fish) >> /etc/shells"
                # $ chsh -s $(which fish)
                # ```

                # `home-manager` config
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.gifaeriyanto = import ./home;
              }
            )
          ];
        };
      };

      # Overlays --------------------------------------------------------------- {{{

      overlays = {
        # Overlay useful on Macs with Apple Silicon
        apple-silicon = final: prev: optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
          # Add access to x86 packages system is running Apple Silicon
          pkgs-x86 = import inputs.nixpkgs-unstable {
            system = "x86_64-darwin";
            inherit (nixpkgsConfig) config;
          };
        };
      };

      # My `nix-darwin` modules that are pending upstream, or patched versions waiting on upstream
      # fixes.
      darwinModules = {
        programs-nix-index =
          # Additional configuration for `nix-index` to enable `command-not-found` functionality with Fish.
          { config, lib, pkgs, ... }:

          {
            config = lib.mkIf config.programs.nix-index.enable {
              # TODO: split below Fish configuration calls to always apply regardless of nix-index.enable settings above
              # https://fishshell.com/docs/3.5/interactive.html?highlight=fish_vi_key_bindings#vi-mode-commands
              # TODO: https://fishshell.com/docs/3.5/language.html#wildcards-globbing
              programs.fish.interactiveShellInit = ''
                fish_vi_key_bindings
  
                function __fish_command_not_found_handler --on-event="fish_command_not_found"
                  ${if config.programs.fish.useBabelfish then ''
                  command_not_found_handle $argv
                  '' else ''
                  ${pkgs.bashInteractive}/bin/bash -c \
                    "source ${config.programs.nix-index.package}/etc/profile.d/command-not-found.sh; command_not_found_handle $argv"
                  ''}
                end
              '';
            };
          };

      };
    };
}