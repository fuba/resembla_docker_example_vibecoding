#!/bin/bash

# Entrypoint script for Resembla Docker container
# Allows switching between resembla_index and resembla_cli

# Default command
COMMAND=""

# Parse first argument to determine which tool to run
case "$1" in
    index|resembla_index)
        COMMAND="resembla_index"
        shift
        ;;
    cli|resembla_cli|search)
        COMMAND="resembla_cli"
        shift
        ;;
    --help|-h|help)
        echo "Resembla Docker Container"
        echo ""
        echo "Usage:"
        echo "  docker run [docker-options] <image> index [options]    - Run resembla_index"
        echo "  docker run [docker-options] <image> cli [options]      - Run resembla_cli"
        echo "  docker run [docker-options] <image> search [options]   - Run resembla_cli (alias)"
        echo ""
        echo "Examples:"
        echo "  # Create index"
        echo "  docker run -v \$(pwd)/data:/data resembla index -c /data/config/name.json"
        echo ""
        echo "  # Search with CLI"
        echo "  docker run -it -v \$(pwd)/data:/data resembla cli -c /data/config/name.json"
        echo ""
        echo "  # Direct command execution"
        echo "  docker run resembla /bin/bash -c 'resembla_index --help'"
        echo ""
        echo "Default config files are in /data/config/"
        echo "Default corpus files are in /data/corpus/"
        exit 0
        ;;
    /bin/*|/usr/bin/*|bash|sh)
        # Allow direct command execution
        exec "$@"
        ;;
    *)
        # If no recognized command, check if it's a direct resembla command
        if command -v "$1" > /dev/null 2>&1; then
            exec "$@"
        else
            echo "Error: Unknown command '$1'"
            echo "Run with --help for usage information"
            exit 1
        fi
        ;;
esac

# Execute the selected command with remaining arguments
if [ -n "$COMMAND" ]; then
    exec "$COMMAND" "$@"
fi