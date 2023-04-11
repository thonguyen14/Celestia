#!/bin/bash

# Define the webhook URL
WEBHOOK_URL="https://your-webhook-url-here.com"

# Define the command to start celestia
# Hot fix if you get Error: node: failed to start: error getting latest head during Start: header: not found
#CLEANUP_CMD="rm -r $HOME/.celestia-light-blockspacerace-0/data/"
#INIT_CMD="celestia light init --p2p.network blockspacerace"

CELESTIA_CMD="celestia light start --core.ip <ip-address> --gateway --gateway.addr <ip-address> --gateway.port <port> --p2p.network blockspacerace"
process_name="celestia"

# Define the time to wait before checking the status again (in seconds)
WAIT_TIME=300 # 5 minutes

# Define the time to wait before checking the status again after a relaunch failure (in seconds)
RELAUNCH_WAIT_TIME=1800 # 30 minutes

# Initialize the last relaunch time
LAST_RELAUNCH_TIME=0

# Infinite loop to continuously monitor celestia process
while true
do
    # Check if the celestia process is running
    if [[ $(pgrep -c -x $process_name) -gt 0 && $(kill -0 $(pgrep $process_name) &>/dev/null; echo $?) -eq 0 ]]
    then
        echo "celestia is running"
    else
        echo "celestia is not running, relaunching..."
        curl -H "Content-Type: application/json" -d '{"content":"The celestia process has stopped."}' $WEBHOOK_URL
        
        # Launch the celestia process
        $CLEANUP_CMD &
        $INIT_CMD 

        $CELESTIA_CMD &
        # Send the webhook to confirm the new process is running
        curl -H "Content-Type: application/json" -d '{"content":"The celestia process has been relaunched."}' $WEBHOOK_URL
        # Update the last relaunch time
        LAST_RELAUNCH_TIME=$(date +%s)
    fi

    # Check if the last relaunch was more than 30 minutes ago and the celestia process is still not running
    if [[ $(($(date +%s) - LAST_RELAUNCH_TIME)) -ge $RELAUNCH_WAIT_TIME ]] && ! pgrep celestia > /dev/null
    then
        echo "celestia is still not running, waiting for 30 minutes before checking again"
        # Update the last relaunch time to prevent excessive checking
        LAST_RELAUNCH_TIME=$(date +%s)
        # Wait for 30 minutes before checking again
        sleep 1800
    else
        # Wait for the specified time before checking the status again
        sleep $WAIT_TIME
    fi
done
    
