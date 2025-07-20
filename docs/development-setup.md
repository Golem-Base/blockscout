# How to run Blockscout backend for development

This guide helps you set up a local Blockscout backend development environment without Docker

## Install dependencies

Choose your operating system:

- [macOS](#macos-dependencies)
- [Ubuntu](#ubuntu-dependencies)

### macOS Dependencies

```bash
brew update
brew install automake gcc gmp libtool mise node nvm postgresql@14 tesseract

# Setup mise
echo 'eval "$(mise activate zsh)"' >> ~/.zshrc

# Setup PostgreSQL 14
# When prompted for password, use 'l3explorer' to match the default .env-dev configuration
createuser -dlP blockscout

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

**Important:** Restart your shell for the changes to take effect.

### Ubuntu Dependencies

```bash
# Install software dependencies
sudo apt-get update
sudo apt-get -y install autoconf automake build-essential cmake curl fop git inotify-tools libgl1-mesa-dev libglu1-mesa-dev libgmp-dev libgmp10 libncurses-dev libpng-dev libssh-dev libtool libudev-dev libxml2-utils lsb-release m4 openjdk-11-jdk postgresql-common unixodbc-dev unzip xsltproc zip

# Install mise
curl https://mise.run | sh
echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc

# Install PostgreSQL 14
sudo /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh
sudo apt-get -y install postgresql-14
# When prompted for password, use 'l3explorer' to match the default .env-dev configuration
sudo -u postgres createuser -dlP blockscout

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

**Important:** Restart your shell for the changes to take effect.

## Setup instructions

### Clone repository and install toolchain

```bash
git clone https://github.com/Golem-Base/blockscout.git blockscout-backend
cd blockscout-backend
# Install erlang, elixir and nodejs from .tool-versions
mise install
```

### Install and compile backend dependencies

```bash
mix do deps.get, local.rebar --force, deps.compile
```

### Generate database secret key

```bash
mix phx.gen.secret
```

Replace `SECRET_KEY_BASE` in `.env-dev` file with obtained secret key.

### Setup environment variables

```bash
source .env-dev
```

### Compile backend

```bash
mix compile
```

### Create and migrate database

```bash
mix do ecto.create, ecto.migrate
```

To wipe current database and start with a fresh instance run:

```bash
mix do ecto.drop, ecto.create, ecto.migrate
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

### Edit `/etc/hosts`

Add `blockscout` and `blockscout.local` as aliases to `localhost`

```
# Static table lookup for hostnames.
# See hosts(5) for details.
127.0.0.1        localhost blockscout blockscout.local
::1              localhost blockscout blockscout.local
```

## Run

```bash
mix phx.server
```
