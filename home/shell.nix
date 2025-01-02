{ ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    initExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
      eval "$(fnm env --use-on-cd --shell zsh)"
    '';
  };

  home.shellAliases = {
    ll = "ls -l";
    s = "sesh connect $(sesh list -i | fzf)";
    k = "kubectl";
    gs = "git status";
    gpp = "git pull --prune";
    gp = "git pull";
    gpush = "git push";

    sz = "source ~/.zshrc";

    bl = "az acr login -n blocc --subscription 5b37ef96-b4b4-483f-9955-92f7a3e74ee1 && az acr login -n bloccephe --subscription 5b37ef96-b4b4-483f-9955-92f7a3e74ee1";

    ls = "eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --group-directories-first --all --no-permissions";
    brewod = "brew outdated | fzf --multi | xargs brew upgrade";

    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";
  };
}
