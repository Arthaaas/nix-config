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
NOCTALIA_STATE_HOME=$HOME/.local/state/noctalia-v5-clean
```

O arquivo versionado atual e `modules/dotfiles/noctalia-v5/config.toml`, linkado pelo Home Manager para:

```text
~/.config/noctalia-v5-clean/noctalia/config.toml
```

O estado mutavel criado pela UI do Noctalia v5 fica em:

```text
~/.local/state/noctalia-v5-clean/noctalia
```

Esse caminho e linkado pelo Home Manager para:

```text
~/nix-config/modules/dotfiles/noctalia-v5-hosts/<my.host.name>/noctalia
```

Assim, cada host mantem uma copia propria das configuracoes visuais do
Noctalia. O sync preserva `settings.toml`, `state.toml`, `.setup-complete`,
paletas da comunidade e wallpapers referenciados fora do repo. Isso evita que
detalhes de monitores, wallpapers e posicoes de widgets de um host sobrescrevam
os de outro.

O sync nao versiona historico de clipboard, historico de notificacoes,
`recently_used.json`, `usage_counts.json`, cache de plugins, repositorios de
plugins nem catalogos de templates.

Se o diretorio do host ainda nao existir, o Home Manager o inicializa a partir
da base comum em:

```text
~/nix-config/modules/dotfiles/noctalia-v5-common/noctalia
```

Na primeira inicializacao apos o rebuild, se ainda existir estado da sessao
atual em `$XDG_RUNTIME_DIR/noctalia-v5-clean-state/noctalia`, ele e copiado
para o novo local persistente.

## Sincronizacao Manual

`just sync-noctalia` sincroniza as configuracoes visuais atuais do Noctalia v5
para `modules/dotfiles/noctalia-v5-hosts/<hostname>/noctalia`.

`just sync-noctalia-common` sincroniza a sessao atual como base comum para hosts
novos. Use isso apenas quando quiser que o estado atual vire ponto de partida
para outras maquinas.

Para sincronizar a configuracao antiga em `~/.config/noctalia`, use:

```sh
just sync-noctalia-legacy
```

## Verificacao

Evite `nix eval`, `nix build`, `nixos-rebuild` e `nh os` durante revisoes pequenas.
Prefira:

```sh
git diff -- modules/features/niri.nix lib/niri-shell-settings.nix docs/niri-shell-sessions.md
nixfmt --check modules/features/niri.nix lib/niri-shell-settings.nix
```

O rebuild/switch do NixOS fica a cargo do usuario.
