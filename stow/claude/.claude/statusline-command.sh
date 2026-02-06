#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract values from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
model_name=$(echo "$input" | jq -r '.model.display_name')

# Change to the working directory
cd "$cwd" 2>/dev/null || cd "$HOME"

# Get current directory (abbreviated home)
dir_display="${cwd/#$HOME/~}"

# Get git branch if in a git repo
git_branch=""
if git rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git branch --show-current 2>/dev/null)
  if [ -n "$branch" ]; then
    git_branch=" on $(printf '\033[35m')$branch$(printf '\033[0m')"
  fi
fi

# Get git status
git_status=""
if git rev-parse --git-dir > /dev/null 2>&1; then
  status=$(git --no-optional-locks status --porcelain 2>/dev/null | wc -l | tr -d ' ')
  if [ "$status" -gt 0 ]; then
    git_status=" $(printf '\033[33m')[$status]$(printf '\033[0m')"
  else
    git_status=" $(printf '\033[32m')✓$(printf '\033[0m')"
  fi
fi

# Get Blocc environment if solution.yaml exists
blocc_env=""
if [ -f "solution.yaml" ]; then
  if command -v blocc-env &> /dev/null; then
    env=$(blocc-env 2>/dev/null)
    if [ -n "$env" ]; then
      blocc_env=" $(printf '\033[36m')🧱$env$(printf '\033[0m')"
    fi
  fi
fi

# Get Kubernetes context
k8s_context=""
if command -v kubectl &> /dev/null; then
  ctx=$(kubectl config current-context 2>/dev/null)
  if [ -n "$ctx" ]; then
    # Simplify context name based on your Starship patterns
    case "$ctx" in
      *"intrum-stacc-dev-aks"*) k8s_alias="Intrum" ;;
      *"k8s-flow-login-test-1-opf-stacc-dev"*) k8s_alias="OPF" ;;
      *"scc-prod-opf-01-aks-admin"*) k8s_alias="OPF-PROD" ;;
      *"k8s-login-lba-link-stacc-dev"*) k8s_alias="LBA" ;;
      *) k8s_alias=$(echo "$ctx" | cut -d'-' -f1) ;;
    esac
    k8s_context=" $(printf '\033[34m')☸ $k8s_alias$(printf '\033[0m')"
  fi
fi

# Build final status line
printf "$(printf '\033[34m\033[1m')%s$(printf '\033[0m')%s%s%s%s" "$dir_display" "$git_branch" "$git_status" "$blocc_env" "$k8s_context"