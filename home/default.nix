{ ... }:

{
  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    # Direnv, load and unload environment variables depending on the current directory.
    # https://direnv.net
    # https://rycee.gitlab.io/home-manager/options.html#opt-programs.direnv.enable
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # Htop
    # https://rycee.gitlab.io/home-manager/options.html#opt-programs.htop.enable
    htop = {
      enable = true;
      settings.show_program_path = true;
    };
  };

  imports = [
    ./packages.nix
    ./shells.nix
    ./git.nix
  ];
}