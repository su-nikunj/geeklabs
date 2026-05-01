#!/bin/bash

# Copy the services to user systemd directory
cp -a ./gitops-services/. $HOME/.config/systemd/user/

# Run the timer
systemctl --user daemon-reload
systemctl --user enable --now git-pull.timer
