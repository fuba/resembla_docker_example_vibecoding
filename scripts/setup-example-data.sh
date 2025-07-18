#!/bin/bash

# Setup example data for resembla docker container
# This script copies and configures example data from the resembla repository

set -e

echo "Setting up example data..."

# Create data directories
mkdir -p /data/config /data/corpus /data/index

# Copy example configurations and corpus
if [ -d "/opt/resembla/example" ]; then
    echo "Copying example configurations..."
    
    # Check if files exist before copying
    if [ -f "/opt/resembla/example/conf/name.json" ]; then
        cp -r /opt/resembla/example/conf/* /data/config/
        echo "Configuration files copied successfully"
    else
        echo "Warning: Configuration files not found, creating from backup"
        # Configuration files were deleted, restore from git
        cd /opt/resembla
        git checkout HEAD -- example/conf/ example/corpus/ || echo "Could not restore from git"
        if [ -f "/opt/resembla/example/conf/name.json" ]; then
            cp -r /opt/resembla/example/conf/* /data/config/
            echo "Configuration files restored and copied"
        else
            echo "Error: Could not restore configuration files"
            exit 1
        fi
    fi
    
    # Copy corpus files
    if [ -f "/opt/resembla/example/corpus/name.tsv" ]; then
        cp -r /opt/resembla/example/corpus/* /data/corpus/
        echo "Corpus files copied successfully"
    else
        echo "Warning: Corpus files not found, creating from backup"
        # Corpus files were deleted, restore from git
        cd /opt/resembla
        git checkout HEAD -- example/corpus/ || echo "Could not restore corpus files"
        if [ -f "/opt/resembla/example/corpus/name.tsv" ]; then
            cp -r /opt/resembla/example/corpus/* /data/corpus/
            echo "Corpus files restored and copied"
        else
            echo "Error: Could not restore corpus files"
            exit 1
        fi
    fi
    
    # Fix paths in configuration files
    echo "Fixing configuration file paths..."
    find /data/config -name "*.json" -type f | while read config_file; do
        # Replace relative paths with absolute paths
        sed -i 's|"../../example/corpus/|"/data/corpus/|g' "$config_file"
        sed -i 's|"../../example/conf/|"/data/config/|g' "$config_file"
    done
    
    echo "Example data setup complete!"
else
    echo "Error: resembla example directory not found"
    exit 1
fi