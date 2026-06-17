#!/usr/bin/env bash
set -euo pipefail

fallback_name="term-$(date +%Y%m%d-%H%M%S)-$$"

if ! tmux has-session -t main 2>/dev/null; then
  exec tmux new-session -s main
fi

printf "Nome da nova sessao tmux (vazio = %s): " "$fallback_name"
read -r session_name

if [ -z "$session_name" ]; then
  session_name="$fallback_name"
fi

session_name="$(printf "%s" "$session_name" | tr -cs '[:alnum:]_.-' '-')"
session_name="${session_name#-}"
session_name="${session_name%-}"

if [ -z "$session_name" ]; then
  session_name="$fallback_name"
fi

if tmux has-session -t "$session_name" 2>/dev/null; then
  exec tmux attach-session -t "$session_name"
fi

exec tmux new-session -s "$session_name"
