#!/bin/bash
set -e

# Define the path for the runtime crontab file
RUNTIME_CRONTAB="/app/runtime.crontab"
# Define the command to be scheduled
SYNC_COMMAND="/usr/local/bin/python /app/test.py"

# --- Crontab Setup (Dynamic) ---

if [ -z "$CRON_SCHEDULE" ]; then
  echo "Error: CRON_SCHEDULE environment variable is not set." >&2
  exit 1
fi

echo "Generating crontab file with schedule: $CRON_SCHEDULE"

# Create the crontab file for Supercronic
echo "$CRON_SCHEDULE $SYNC_COMMAND" > "$RUNTIME_CRONTAB"
echo "" >> "$RUNTIME_CRONTAB"

echo "Runtime crontab content:"
cat "$RUNTIME_CRONTAB" # Optional: Log the generated crontab for debugging

# --- Start Supercronic Service ---
echo "Starting Supercronic scheduler with runtime crontab..."
exec /usr/local/bin/supercronic "$RUNTIME_CRONTAB"