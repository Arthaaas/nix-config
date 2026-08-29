# Sessoes Niri

Esta configuracao mantem tres sessoes selecionaveis no login:

- `niri-inir`: Niri com iNiR.
- `niri-noctalia-v5`: Niri com Noctalia v5.
- `niri-dms`: Niri com DMS.

## Fonte de verdade

- `modules/features/niri.nix` define as sessoes de login, wrappers do Niri e pacotes expostos ao display manager.
- `lib/niri-shell-settings.nix` define a base comum do Niri e os binds especificos de cada shell.
- `modules/features/noctalia.nix` habilita o modulo NixOS do Noctalia, sem iniciar servico proprio.
- `modules/features/dms.nix` habilita DMS e seu greeter, sem iniciar a sessao de shell fora do wrapper do Niri.
- `modules/features/inir.nix` habilita iNiR, sem iniciar servico proprio.
- `modules/home/programs/noctalia.nix` instala a configuracao limpa do Noctalia v5 em `~/.config/noctalia-v5-clean`.

## Binds comuns

Binds comuns ficam em `commonBinds` dentro de `lib/niri-shell-settings.nix`.
Eles devem ser comandos nativos do Niri ou comandos independentes do shell ativo.

O lock global usa:

```sh
loginctl lock-session
```

Isso evita depender de subcomandos especificos de Noctalia, DMS ou iNiR.

## Binds especificos

- `noctaliaBinds`: apenas comandos que chamam `noctalia`.
- `dmsBinds`: apenas comandos que chamam `dms`.
- `inirBinds`: apenas comandos que chamam `inir`.

Se um bind chama diretamente um shell, ele nao deve entrar em `commonBinds`.

## Configuracao Noctalia v5

O Noctalia v5 desta sessao usa:

```sh
NOCTALIA_CONFIG_HOME=$HOME/.config/noctalia-v5-clean
NOCTALIA_STATE_HOME=$XDG_RUNTIME_DIR/noctalia-v5-clean-state
```

O arquivo versionado atual e `modules/dotfiles/noctalia-v5/config.toml`, linkado pelo Home Manager para:

```text
~/.config/noctalia-v5-clean/noctalia/config.toml
```

## Script legado

`scripts/sync-noctalia-config` foi criado para outro momento da configuracao e deve ser tratado como legado.
Nao use esse script como fonte de verdade para Noctalia v5 sem revisar o impacto antes.

## Verificacao

Evite `nix eval`, `nix build`, `nixos-rebuild` e `nh os` durante revisoes pequenas.
Prefira:

```sh
git diff -- modules/features/niri.nix lib/niri-shell-settings.nix docs/niri-shell-sessions.md
nixfmt --check modules/features/niri.nix lib/niri-shell-settings.nix
```

O rebuild/switch do NixOS fica a cargo do usuario.
