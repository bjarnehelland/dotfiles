{
  lib,
  username,
  useremail,
  ...
}:
{
  # `programs.git` will generate the config file: ~/.config/git/config
  # to make git use this config file, `~/.gitconfig` should not exist!
  #
  #    https://git-scm.com/docs/git-config#Documentation/git-config.txt---global
  home.activation.removeExistingGitconfig = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    rm -f ~/.gitconfig
  '';

  programs = {
    # github cli
    gh = {
      enable = true;
    };

    # github dash
    gh-dash = {
      enable = true;
    };

    git = {
      enable = true;
      lfs.enable = true;

      userName = username;
      userEmail = useremail;

      includes = [
        # When the working directory is under ~/code/stacc then sign-off commits
        # with Stacc email address.
        {
          condition = "gitdir:~/code/stacc/";
          contents.user.email = "bjarneh@stacc.com";
        }
      ];

      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        pull.rebase = true;

        gpg.format = "ssh";
        commit.gpgsign = true;
        tag.gpgsign = true;
      };

      signing = {
        key = "~/.ssh/id_ed25519.pub";
        signByDefault = true;
      };

      delta = {
        enable = true;
        options = {
          features = "side-by-side";
        };
      };

      aliases = {
        # common aliases
        br = "branch";
        co = "checkout";
        st = "status";
        ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
        ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
        cm = "commit -m";
        ca = "commit -am";
        dc = "diff --cached";
        amend = "commit --amend -m";

        # aliases for submodule
        update = "submodule update --init --recursive";
        foreach = "submodule foreach";
      };
    };
  };
}
