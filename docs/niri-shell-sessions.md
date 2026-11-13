# Sessoes Niri

Esta configuracao mantem uma sessao selecionavel no login:

- `niri-noctalia-v5`: Niri com Noctalia v5.

## Fonte de verdade

- `modules/features/niri.nix` define a sessao de login, o wrapper do Niri e os pacotes expostos ao display manager.
- `lib/niri-shell-settings.nix` define a base do Niri e os binds do Noctalia.
- `modules/features/noctalia.nix` habilita o modulo NixOS do Noctalia, sem iniciar servico proprio.
- O mesmo modulo habilita o Noctalia Greeter do nixpkgs para o greetd.
- `modules/home/programs/noctalia.nix` instala a configuracao limpa do Noctalia v5 em `~/.config/noctalia-v5-clean`.

## Monitores pela interface grafica

Nos hosts com `my.desktop.niri.displaySettings = null` (padrao), o pacote
`nwg-displays` fica disponivel no launcher. Abra-o na sessao Niri, arraste
as telas, ajuste resolucao, Hz e escala e clique em Apply.

Os ajustes ficam em `~/.config/niri/monitor.kdl`, um arquivo local editavel
que nao e sobrescrito por rebuilds. O wrapper inclui esse arquivo diretamente,
e o Niri observa suas alteracoes para recarregar a configuracao automaticamente.
O include e opcional para permitir validacao e primeiro login sem estado local.
O Home Manager cria o diretorio e os arquivos iniciais apenas se nao existirem.
O `config.kdl` local serve para a integracao do nwg-displays; a configuracao
principal da sessao continua sendo a gerada pelo wrapper Nix.
O pacote recebe um ajuste para usar o hot reload do Niri, evitando que o
botao Apply carregue somente o arquivo local e remova os binds do wrapper.

Para instalar a integracao no notebook de trabalho:

```sh
sudo nixos-rebuild switch --flake ~/nix-config#notebook-kot
```

Depois, entre novamente na sessao `Niri + Noctalia v5` e abra `nwg-displays`.
Os ajustes seguintes nao precisam de rebuild. Para backup, salve tambem
`~/.config/niri/monitor.kdl`; ele nao e sincronizado pelo `sync-noctalia`.

Hosts com `displaySettings` definido continuam declarativos, sem carregar o
arquivo da GUI. Isso preserva os monitores do desktop de casa, definidos em
`data/desktop-casa-display-settings.nix`. Para migrar um desses hosts para a GUI,
remova a atribuicao de `displaySettings`, aplique o rebuild e configure as telas
no nwg-displays.

## Tela de login

Nos perfis com Noctalia, o greetd inicia `noctalia-greeter-session`, que usa
o compositor proprio do greeter. A sessao padrao e `Niri + Noctalia v5`,
cujo wrapper configura os diretorios de configuracao e estado antes de iniciar
o Niri. Plasma e COSMIC continuam disponiveis no seletor de sessoes.

O teclado do greeter segue `my.host.keyboard.layout` e `variant`: `us/intl`
no desktop e `br` nos notebooks. O diretorio de sessoes gerado pelo NixOS e
exposto ao greetd via `XDG_DATA_DIRS`, incluindo a sessao personalizada.

As opcoes ficam em `services.displayManager.noctalia-greeter`, usando o
modulo do nixpkgs ja fixado no `flake.lock`. O modulo prepara o diretorio
`/var/lib/noctalia-greeter`, habilita AccountsService e integra o Polkit.
O tema e o wallpaper usam os padroes do greeter; a sincronizacao com a
aparencia da sessao nao e configurada aqui.

O tuigreet continua como alternativa nos perfis sem o Noctalia Greeter.
Aplicar e testar a tela de login exige rebuild e nova entrada na sessao,
a cargo do usuario. A avaliacao Nix nao testa renderizacao nem autenticacao.

## Binds comuns

Binds comuns ficam em `commonBinds` dentro de `lib/niri-shell-settings.nix`.
Eles devem ser comandos nativos do Niri ou comandos independentes do shell ativo.

O lock global usa:

```sh
loginctl lock-session
```

Isso evita depender de subcomandos especificos do Noctalia.

## Binds especificos

- `noctaliaBinds`: apenas comandos que chamam `noctalia`.

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
