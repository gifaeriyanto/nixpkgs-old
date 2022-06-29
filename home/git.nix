{ ... }:

let
  gifaeriyanto = {
    name = "Gifa Eriyanto";
    email = "gifa.eriyanto@gmail.com";
    signingKey = "2662BA9E137481B7";
  };
in
{
  programs = {
    git = {
      enable = true;
      userName = gifaeriyanto.name;
      userEmail = gifaeriyanto.email;

      signing = {
        key = gifaeriyanto.signingKey;
        signByDefault = true;
        gpgPath = "gpg";
      };

      ignores = [
        "*~"
        ".DS_Store"
        "*.swp"
      ];

      aliases = {
        st = "status";
        co = "checkout";
        cb = "checkout -b";
        rb = "rebase";
        rba = "rebase --abort";
        rbc = "rebase --continue";
        rbi = "rebase -i";
        pf = "push --force-with-lease";
      };

      diff-so-fancy.enable = true;

      includes = [
        {
          condition = "gitdir:~/.local/share/";
          contents.user = gifaeriyanto;
        }

        {
          condition = "gitdir:~/.config/nixpkgs/";
          contents.user = gifaeriyanto;
        }
      ];
    };
  };
}