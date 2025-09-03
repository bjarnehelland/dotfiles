#!/bin/bash

# Get blocc environment from current directory
get_blocc_env() {
    local env=$(blocc config show 2>/dev/null | awk '/deploy:/{flag=1; next} flag && /^\s*environment:/{print $2; exit}')
    
    if [[ -z "$env" ]]; then
        echo "No environment found" >&2
        return 1
    fi
    
    echo "$env"
}

# Main
case "${1:-}" in
    -h|--help)
        echo "Usage: $(basename $0)"
        echo "Output the blocc deploy environment for current directory"
        ;;
    *)
        get_blocc_env
        ;;
esac