# dotfiles

Personal dotfiles for my development environment.

## Quick start (one command)

On any server or machine — run a single command. Everything loads dynamically from GitHub:

```bash
# Install aliases only
curl -fsSL https://raw.githubusercontent.com/Roman505050/dotfiles/main/setup.sh | bash -s -- aliases

# Install all
curl -fsSL https://raw.githubusercontent.com/Roman505050/dotfiles/main/setup.sh | bash -s -- all
```

After installation run `source ~/.zshrc` (or `source ~/.bashrc`) or open a new terminal.

## Usage

### Commands

| Command   | Description                                  |
|-----------|----------------------------------------------|
| `aliases` | Install shell aliases (Docker, Git, Python)  |
| `all`     | Install all configs                         |
| `help`    | Show help                                    |

### From local clone

```bash
git clone https://github.com/Roman505050/dotfiles.git
cd dotfiles
./setup.sh aliases
./setup.sh all
```

### From remote server (one link)

The script downloads configs from GitHub — no need to clone the repo:

```bash
curl -fsSL https://raw.githubusercontent.com/Roman505050/dotfiles/main/setup.sh | bash -s -- aliases
```

### Custom repository

```bash
DOTFILES_REPO=https://github.com/user/dotfiles DOTFILES_BRANCH=main \
  curl -fsSL https://raw.githubusercontent.com/user/dotfiles/main/setup.sh | bash -s -- aliases
```

Override with `DOTFILES_REPO` and `DOTFILES_BRANCH` for a custom repo.

## What gets installed

- **aliases** — copies `.config/.aliases` to `~/.config/dotfiles-aliases` and adds `source` to `.zshrc`/`.bashrc`

## Structure

```
dotfiles/
├── setup.sh          # Main setup script
├── .config/
│   └── .aliases      # Shell aliases
└── README.md
```
