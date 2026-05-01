# Geeklabs
My cloud server hosted on a VPS. I chose a netcup root server with 8 dedicated AMD EPYC cores, 16 GB of RAM and 1 TB SSD. I'll be running AlmaLinux as the operating system and using podman quadlets for all the services. 

I also created a simple GitOps workflow by just running a systemd timer that frequently pulls from this repo and refreshes systemd. The script checks the git diff-tree and gets a list of .container files that are different from last commit. It then enables, restarts, or delete systemd service based on the status.
> **Note:** The script assumes that containers and systemd services have same names. If you specify `ServiceName=` field with a different name in the quadlet file, the script will fail to manage that service. For now it only detects changes in .container files, so if you modify anything else, make changes in .container file as well for the script to work.

## Steps to setup
1. Enable linger for current user, `loginctl enable-linger`, and also enable podman auto-update timer using `systemctl --user enable --now podman-auto-update.timer`.
2. Clone the repo in `~/.config/containers/systemd` folder.
3. Run the `init.sh` script.
