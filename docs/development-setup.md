# Blockscout Backend Development Setup

This guide provides instructions for running Blockscout backend for development against a local blockchain without Docker.

## Install dependencies

### macOS

```bash
brew update
brew install erlang elixir postgresql@14 node automake libtool gcc gmp nvm asdf

# Install Erlang, Elixir and NodeJS
asdf plugin add erlang
asdf plugin add elixir
asdf plugin add nodejs

# Start PostgreSQL 14
brew services start postgresql@14

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### Ubuntu

```bash
sudo apt-get update
sudo apt-get install inotify-tools && sudo apt install make && sudo apt install g++
sudo apt-get install libudev-dev zip unzip build-essential cmake -y
sudo apt-get install git automake libtool inotify-tools libgmp-dev libgmp10 build-essential cmake -y

# Install asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf
echo '. ~/.asdf/asdf.sh' >> ~/.bashrc
. ~/.asdf/asdf.sh

# Install Erlang, Elixir and NodeJS
asdf plugin add erlang
asdf plugin add elixir
asdf plugin add nodejs

sudo apt-get -y install build-essential autoconf m4 libncurses5-dev libwxgtk3.0-gtk3-dev libwxgtk-webview3.0-gtk3-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop libxml2-utils libncurses-dev openjdk-11-jdk

# Install PostgreSQL 14
curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
sudo apt update
sudo apt install postgresql-14
sudo systemctl status postgresql

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

## Setup instructions

### Clone repository and install toolchain

```bash
git clone https://github.com/Golem-Base/blockscout.git blockscout-backend
cd blockscout-backend
asdf install
```

### Install Mix dependencies

```bash
mix do deps.get, local.rebar --force, deps.compile
```

### Generate database secret key

```bash
mix phx.gen.secret
```

Replace `SECRET_KEY_BASE` in `.env.dev` file with obtained secret key.

### Compile backend

```bash
mix compile
```

### Create and migrate database

```bash
mix do ecto.create, ecto.migrate
```

### Install Node.js dependencies

```bash
cd apps/block_scout_web/assets
npm install && node_modules/webpack/bin/webpack.js --mode production
cd -
cd apps/explorer
npm install
cd -
```

### Build static assets

```bash
mix phx.digest
```

### Generate SSL certificate for Phoenix server

```bash
cd apps/block_scout_web
mix phx.gen.cert blockscout blockscout.local
cd -
```
