{ ... }:
{
  programs.starship = {
    enable = true;

    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;

    settings = {
      # add_newline = false;

      # character = {
      #   success_symbol = "[\uf054](white)";
      #   vicmd_symbol = "[\ue62b](white)";
      #   error_symbol = "[\uf467](red)";
      # };

      # package.disabled = true;
      directory.style = "blue bold";
      package.disabled = true;
      username.disabled = true;
      hostname.disabled = true;
      aws.disabled = true;
      docker_context.disabled = true;
      git_branch.disabled = false;
      git_commit.disabled = true;
      git_state.disabled = true;
      git_metrics.disabled = true;
      git_status = {
        disabled = false;
        ahead = "↑$count";
        diverged = "↑$ahead_count↓$behind_count";
        behind = "↓$count";
      };
      kubernetes = {
        disabled = false;
        contexts = [
          {
            context_pattern = "k8s-login-lba-link-stacc-dev-context";
            style = "bold green";
            context_alias = "LBA";
          }
          {
            context_pattern = "k8s-flow-login-test-1-opf-stacc-dev-context";
            style = "bold green";
            context_alias = "OPF";
          }
          {
            context_pattern = "scc-prod-opf-01-aks-admin";
            style = "bold red";
            context_alias = "OPF";
          }
        ];
      };
    };
  };
}
