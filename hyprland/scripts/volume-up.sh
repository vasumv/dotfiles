#!/usr/bin/env bash
# Raise the default sink volume by 5%.
# Allow boosting to 200% only when the active port is the internal speaker;
# any other output (headphones, headset, bluetooth, HDMI, USB, etc.) caps at 100%.

set -euo pipefail

sink="$(pactl get-default-sink)"
limit="1"

if [[ "$sink" != *bluez* ]]; then
    port="$(pactl list sinks | awk -v s="$sink" '
        $1=="Name:" && $2==s {found=1; next}
        found && $1=="Name:" {found=0}
        found && /Active Port:/ {print $3; exit}
    ')"
    case "$port" in
        *[Ss]peaker*) limit="2" ;;
    esac
fi

exec wpctl set-volume -l "$limit" @DEFAULT_AUDIO_SINK@ 5%+
