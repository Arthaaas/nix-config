# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Personal NixOS configuration (nixos-unstable) built on **flake-parts** + **import-tree**. Comments and commit messages are in Portuguese; keep that convention.

## Commands

```sh
# Rebuild a host (config names differ from directory names — see Hosts below)
sudo nixos-rebuild switch --flake .#pc              # desktop-casa
sudo nixos-rebuild switch --flake .#notebook-casa
sudo nixos-rebuild switch --flake .#notebook-kot

# Iterate without activating: build only, or test (activate, no bootloader entry)
sudo nixos-rebuild build --flake .#pc
sudo nixos-rebuild test  --flake .#pc

nix flake check          # evaluate all outputs
nix flake update         # bump all inputs in flake.lock

just                     # list recipes
just sync-noctalia       # pull runtime ~/.config/noctalia back into the repo (see below)
```

There is no test suite or linter beyond `nix flake check`. Nvim Lua dotfiles are formatted with `stylua` (config at `modules/dotfiles/nvim/stylua.toml`).

## Architecture

`flake.nix` is intentionally minimal: it declares inputs and delegates all module loading to `import-tree ./modules`. **Every `.nix` file under `modules/` is auto-imported** — there is no central list of modules and no `imports` entry in `flake.nix`. Adding a file to `modules/` (outside `modules/archive/`) makes it part of the flake automatically. Each `default.nix` you see is a manual re-import list that predates or complements this and can usually be ignored when adding new files.

The codebase composes NixOS configurations in three layers, all glued through named flake outputs rather than relative paths:

1. **Features** (`modules/features/**`) — reusable, option-gated building blocks. Each file defines a named module, e.g. `flake.nixosModules.corePackages`, and typically exposes an enable flag under the `my.*` option namespace (`my.packages.core.enable`, `my.desktop.niri.*`, etc.). Package sets live in `modules/features/packages/` (core, dev, erp-dev, desktop-apps, work, media, notes, personal, games), each gated by `my.packages.<name>.enable`.

2. **Profiles** (`modules/profiles/**`) — opinionated stacks that `import` feature modules and set their enable flags. The chain is `baseProfile` → `niriWorkstationProfile` → (`personalDesktopProfile` | `workLaptopProfile`). A profile pulls in modules via `imports = [ self.nixosModules.<name> ];`.

3. **Hosts** (`modules/hosts/<host>/`) — each host has `default.nix` (declares `flake.nixosConfigurations.<name>`), `configuration.nix` (imports a profile + boot + hardware, sets `my.host`), and `hardware.nix`. Hosts differ almost entirely through the `my.host.*` options (hostname, user, locale, keyboard) — see `modules/features/system/host-options.nix` for the full option set.

**Cross-module references use `self.nixosModules.<name>` / `self.homeModules.<name>`, never relative imports.** When you add a new feature, define it as `flake.nixosModules.<name> = { ... }: { ... };` and reference that name from the consuming profile.

### Hosts (config name → directory)

| `.#name`        | Directory                | Profile               | User      |
|-----------------|--------------------------|-----------------------|-----------|
| `pc`            | `hosts/desktop-casa`     | personalDesktop       | arthas    |
| `notebook-casa` | `hosts/notebook-casa`    | workLaptop            | arthas    |
| `notebook-kot`  | `hosts/notebook-kot`     | workLaptop            | arthurb   |

`modules/archive/vms/` holds retired VM hosts; import-tree still picks them up, so leave them under `archive/` if not in use.

### Home Manager

Home Manager runs as a NixOS module (`self.nixosModules.home`, in `modules/home/default.nix`), wired into every workstation via `niriWorkstationProfile`. It reads the target user from `config.my.host.userName` and imports `self.homeModules.default`, which aggregates the per-program home modules in `modules/home/programs/` (fish, kitty, nvim, tmux, brave). Home program modules are declared as `flake.homeModules.<name>` (the `flake.homeModules` option is defined in `modules/flake-parts.nix`).

### Desktop / dotfiles

The desktop is **niri** (Wayland) with the **Noctalia** shell (via the `wrapper-modules` input) plus DMS/iNiR. Static dotfiles live under `modules/dotfiles/` (nvim, kitty, tmux, noctalia).

Noctalia is special: its package is built in `modules/features/noctalia.nix` from `modules/dotfiles/noctalia/noctalia.json`, but points `outOfStoreConfig` at the live `~/.config/noctalia`. After changing settings in the running shell, run `just sync-noctalia` (→ `scripts/sync-noctalia-config`) to copy the runtime settings/colors/plugins/colorschemes back into the repo so they're committed.
