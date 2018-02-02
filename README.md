# Grinhelper Suite - BASH Script Repository

## Setup Instructions

Based on a clean Ubuntu 16.04 LTS minimal install (other Ubuntu and Debian should work too)

## Script: GrinHelper.sh - Manage Local Grin Node

### Features

- Install Grin depencies: Clang-3.8, Rust
- Install its own depencies: figlet, screen, jq
- Install Grin
- Autofix logfile size
- Everything listed under functions

### Functions

#### Launcher and corresponding logviewer

- Start detached Grin Wallet Node
- Check logfiles of Grin Wallet Node
- Start detached Grin Mining Server
- Check logfiles of Grin Mining Server
- Start detached Grin Regular Server (non-mining)
- Check logfiles of Grin Regular Server (non-mining)

#### Funds and Transfers

- View balance of local Grin wallet
- Show outputs of local Grin wallet

#### Monitoring and Operations

- Check which Grin processes are running
- Show sync & mining stats
- Killall Grin processes
- Update Grindhelper

## Script: GrinHelper-CheckRemoteNodes.sh

## Manage, monitor and aggregate infos from remote Grin nodes

### Functions

- Check Sync & Mining Stats (at all remote nodes)
- Check Outputs (at all remote nodes)
- Check Balance (at all remote nodes)
- Update Grinhelper (on all remote nodes)
