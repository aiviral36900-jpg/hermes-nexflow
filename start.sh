#!/bin/bash

# Create config directory
mkdir -p ~/.hermes/data
mkdir -p ~/nexflow

# Download SOUL.md from GitHub if exists
if [ ! -f ~/.hermes/SOUL.md ]; then
  curl -s https://raw.githubusercontent.com/aiviral36900-jpg/nexflow-ai1/main/docs/SOUL.md \
    -o ~/.hermes/SOUL.md 2>/dev/null || echo "SOUL.md not found, starting fresh"
fi

# Download agency.json from GitHub
if [ ! -f ~/.hermes/data/agency.json ]; then
  curl -s https://raw.githubusercontent.com/aiviral36900-jpg/nexflow-ai1/main/docs/agency.json \
    -o ~/.hermes/data/agency.json 2>/dev/null || echo '{}' > ~/.hermes/data/agency.json
fi

# Set environment variables
export HERMES_PORT=${PORT:-3000}
export HERMES_HOST=0.0.0.0

# Start Hermes
echo "Starting Hermes Agent..."
hermes start --headless --port $HERMES_PORT
