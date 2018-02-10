# GrinHelper Suite - Bash Script Repository

Grin is an in-progress implementation of the MimbleWimble protocol. To learn more, read the [introduction to MimbleWimble and Grin](https://github.com/mimblewimble/grin/blob/master/doc/intro.md).

## Installation instructions

1. Get yourself a clean Ubuntu or Debian (tested working on Ubuntu 16.04 LTS minimal)
2. Run these commands

```bash
curl https://raw.githubusercontent.com/dewdeded/GrinHelper/master/Install.sh -sSf | bash
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

- Start detached Grin Wallet (Testnet1)
- Start detached Grin Mining Node (Testnet1)
- Start detached Grin Mining Node (Testnet2)
- Start detached Grin Non-mining Node (Testnet1)

#### Logviewer

- Check logfiles of Grin Wallet
- Check logfiles of Grin Node

#### Show funds, transfers and stats

- Show balance of local Grin wallet
- Show outputs of local Grin wallet
- Show sync & mining statsof local Grin Node

#### Monitoring, operations and update

- Check which Grin processes are running
- Check Grin Connectivity - Check if Grins ports are publicly reachable.
- Stop Grin processes (Killall Grin processes, Kill Grin Wallet, Kill Grin Node)
- Update GrindHelper
- Update Grin (to latest version in master-branch.)

## GrinHelper-Remote.sh

This script manages, monitors and aggregate status info from remote Grin nodes.

### Functions

- Check Sync & Mining Stats (at all remote nodes)
- Check Outputs (at all remote nodes)
- Check Balance (at all remote nodes)
- Check Connectivity (off all remote nodes)
- Update GrinHelper (on all remote nodes)

[![asciicast](https://asciinema.org/a/tNSrjbW66g8ph043lKT7jxqdE.png)](https://asciinema.org/a/tNSrjbW66g8ph043lKT7jxqdE)
