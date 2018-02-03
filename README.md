# GrinHelper Suite - Bash Script Repository

Grin is an in-progress implementation of the MimbleWimble protocol. To learn more, read the [introduction to MimbleWimble and Grin](https://github.com/mimblewimble/grin/blob/master/doc/intro.md).

## Installation instructions

1. Get yourself a clean Ubuntu or Debian (tested working on Ubuntu 16.04 LTS minimal)
2. Run these commands

```bash
wget https://raw.githubusercontent.com/dewdeded/GrinHelper/master/GrinHelper.sh -O ./grinhelper
chmod +x /bin/grinhelper
sudo mv ./grinhelper /bin/ # needs root for /bin or if you prefer /usr/bin or ~/bin/ perhaps
```

## GrinHelper.sh

This bash script manages your local Grin node.

### Features

This is what this script will do for you.

#### Automatic setup

- Install Grin depencies: Clang-3.8, Rust 1.21, rustup
- Install it's own depencies: figlet, screen, jq
- Install Grin
- Autofix logfile size

#### Launcher and corresponding logviewer

- Start detached Grin Wallet Node
- Check logfiles of Grin Wallet Node
- Start detached Grin Mining Server
- Check logfiles of Grin Mining Server
- Start detached Grin Regular Server (non-mining)
- Check logfiles of Grin Regular Server (non-mining)

#### Show funds and transfers

- View balance of local Grin wallet
- Show outputs of local Grin wallet

#### Monitoring and operations

- Check which Grin processes are running
- Show sync & mining stats
- Killall Grin processes
- Update Grindhelper

## Script: GrinHelper-CheckRemoteNodes.sh
**Manage, monitor and aggregate status info from remote Grin nodes**

### Functions

- Check Sync & Mining Stats (at all remote nodes)
- Check Outputs (at all remote nodes)
- Check Balance (at all remote nodes)
- Update Grinhelper (on all remote nodes)

[![asciicast](https://asciinema.org/a/tNSrjbW66g8ph043lKT7jxqdE.png)](https://asciinema.org/a/tNSrjbW66g8ph043lKT7jxqdE)
