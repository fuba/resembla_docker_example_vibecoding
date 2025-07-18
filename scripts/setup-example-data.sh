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
    cp -r /opt/resembla/example/conf/* /data/config/
    cp -r /opt/resembla/example/corpus/* /data/corpus/
    
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