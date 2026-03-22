#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract values from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
model_name=$(echo "$input" | jq -r '.model.display_name')
context_used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
context_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
input_tokens=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // empty')

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

# Context usage progress bar
context_info=""
if [ -n "$context_used" ]; then
  # Round to integer
  used_int=$(printf "%.0f" "$context_used")

  # Choose color based on usage level
  if [ "$used_int" -ge 75 ]; then
    bar_color=$(printf '\033[31m')   # red
  elif [ "$used_int" -ge 50 ]; then
    bar_color=$(printf '\033[33m')   # yellow
  else
    bar_color=$(printf '\033[32m')   # green
  fi
  reset=$(printf '\033[0m')

  # Build 10-char progress bar
  bar_width=10
  filled=$(( used_int * bar_width / 100 ))
  empty=$(( bar_width - filled ))
  bar=""
  for i in $(seq 1 $filled); do bar="${bar}█"; done
  for i in $(seq 1 $empty);  do bar="${bar}░"; done

  context_info=" ${bar_color}[${bar}]${reset} ${bar_color}${used_int}%%${reset}"
fi

# Context window size bar (tokens used out of total context window)
context_window_info=""
if [ -n "$input_tokens" ] && [ -n "$context_size" ] && [ "$context_size" -gt 0 ] 2>/dev/null; then
  window_pct=$(( input_tokens * 100 / context_size ))

  if [ "$window_pct" -ge 75 ]; then
    win_color=$(printf '\033[31m')   # red
  elif [ "$window_pct" -ge 50 ]; then
    win_color=$(printf '\033[33m')   # yellow
  else
    win_color=$(printf '\033[32m')   # green
  fi
  reset=$(printf '\033[0m')

  bar_width=10
  filled=$(( window_pct * bar_width / 100 ))
  empty=$(( bar_width - filled ))
  win_bar=""
  for i in $(seq 1 $filled); do win_bar="${win_bar}█"; done
  for i in $(seq 1 $empty);  do win_bar="${win_bar}░"; done

  # Convert token counts to human-readable (k)
  tokens_k=$(( input_tokens / 1000 ))
  size_k=$(( context_size / 1000 ))

  context_window_info=" ${win_color}[${win_bar}]${reset} ${win_color}${tokens_k}k/${size_k}k${reset}"
fi

# Model name
model_info=""
if [ -n "$model_name" ]; then
  model_info=" $(printf '\033[36m')$model_name$(printf '\033[0m')"
fi

# Build final status line
printf "$(printf '\033[34m\033[1m')%s$(printf '\033[0m')%s%s%s%s" "$dir_display" "$git_branch" "$model_info" "$context_info" "$context_window_info"
