set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

# Lista os comandos disponiveis.
default:
    just --list

# Sincroniza configuracoes runtime do Noctalia v5 deste host para o repositorio.
sync-noctalia:
    bash scripts/sync-noctalia-config host

# Sincroniza o estado atual do Noctalia v5 como base comum para hosts novos.
sync-noctalia-common:
    bash scripts/sync-noctalia-config common

# Sincroniza a configuracao legada do Noctalia para o repositorio.
sync-noctalia-legacy:
    bash scripts/sync-noctalia-config legacy
