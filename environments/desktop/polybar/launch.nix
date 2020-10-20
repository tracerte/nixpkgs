{ nixpkgs ? import <nixpkgs> {} }:
with nixpkgs;

writeScript "polybar-launch" ''
#!/usr/bin/env bash

# Terminate already running bar instances
pkill polybar
# If all your bars have ipc enabled, you can also use 
# polybar-msg cmd quit

for m in $(polybar --list-monitors | cut -d":" -f1); do
    MONITOR=$m polybar --reload bar-none &
done

echo "Bars launched..."
''
