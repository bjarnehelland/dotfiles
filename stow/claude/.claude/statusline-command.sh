#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract values from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
context_used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
input_tokens=$(echo "$input" | jq -r '
  (.context_window.current_usage.input_tokens // 0) +
  (.context_window.current_usage.cache_creation_input_tokens // 0) +
  (.context_window.current_usage.cache_read_input_tokens // 0)
')
model_id=$(echo "$input" | jq -r '.model.id // empty')

# Change to the working directory
cd "$cwd" 2>/dev/null || cd "$HOME"

# Get current directory (abbreviated home)
dir_display="${cwd/#$HOME/~}"

# Get git branch if in a git repo
git_branch=""
if git -c gc.auto=0 rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -c gc.auto=0 branch --show-current 2>/dev/null)
  if [ -n "$branch" ]; then
    git_branch=" on $(printf '\033[35m')$branch$(printf '\033[0m')"
  fi
fi

# Context percentage
context_info=""
if [ -n "$context_used" ]; then
  used_pct=$(printf "%.1f" "$context_used")
  used_int=$(printf "%.0f" "$context_used")
  if [ "$used_int" -ge 75 ]; then
    color=$(printf '\033[31m')
  elif [ "$used_int" -ge 50 ]; then
    color=$(printf '\033[33m')
  else
    color=$(printf '\033[32m')
  fi
  reset=$(printf '\033[0m')
  if [ "$input_tokens" -ge 1000 ] 2>/dev/null; then
    tokens_display="$(( input_tokens / 1000 ))k"
  else
    tokens_display="${input_tokens}"
  fi
  context_info=" ${color}${tokens_display} (${used_pct}%)${reset}"
fi

# Model name (short form extracted from model ID)
model_info=""
if [ -n "$model_id" ]; then
  # Extract the model family name: e.g. "claude-opus-4-6" -> "opus", "claude-sonnet-4-6" -> "sonnet"
  model_short=$(echo "$model_id" | sed -E 's/^claude-([a-z]+).*/\1/')
  # Extract the version number: e.g. "claude-sonnet-4-6" -> "4.6", "claude-opus-4" -> "4"
  model_version=$(echo "$model_id" | sed -nE 's/^claude-[a-z]+-([0-9]+(-[0-9]+)?).*/\1/p' | sed 's/-/./g')
  if [ -n "$model_version" ]; then
    model_label="${model_short} ${model_version}"
  else
    model_label="${model_short}"
  fi
  model_info=" $(printf '\033[36m')${model_label}$(printf '\033[0m')"
fi

# Build final status line
printf "$(printf '\033[34m\033[1m')%s$(printf '\033[0m')%s%s%s" "$dir_display" "$git_branch" "$context_info" "$model_info"
