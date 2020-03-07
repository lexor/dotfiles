#!/usr/bin/env bash

# ---------------------------------------------

tm_segment() {
  icon=$1
  color=$2
  text=$3

  res=""

  # Default color
  [[ -z $color ]] \
    && color="colour237"

  # Icon
  [[ -n $icon ]] \
    && res+="#[ fg=${color}, noreverse] ${icon}"

  [[ -n $text ]] \
    && res+="#[fg=${color} bg=default, noreverse] ${text} "

  # Reset
  res+="#[bg=default, fg=default]"

  echo -ne "$res"
}

tm_divider() {
  echo -ne "#[fg=colour237]|#[bg=default, fg=default]"
}


# ---------------------------------------------

# Detect if headphones are connected
# This is for macOS only
segment_headphones() {
  [[ "$(uname -s)" == "Darwin" ]] \
    || return 1

  if system_profiler SPAudioDataType | grep Headphones &> /dev/null; then
    tm_segment "0(o.o)0" "cyan"
    tm_divider
  fi
}

# ---------------------------------------------
# Music
segment_music() {
  [[ $(command -v osascript) ]] \
    || return 1

  spotify="$(osascript "$DOTFILES"/.misc/applescripts/spotify.scpt)"
  is_playing="$(osascript "$DOTFILES"/.misc/applescripts/spotify_is_playing.scpt)"

  # Animate the music icon cuz i got no life
  # ¯\_(ツ)_/¯
  frames=( "⢄" "⢂" "⢁" "⡁" "⡈" "⡐" "⡠" )
  epoch="$(date +%s)"
  frame_index="$(( epoch % ${#frames[@]} ))"

  [[ "$is_playing" == 1 ]] && \
    music_icon="${frames[$frame_index]} " || \
    music_icon=""

  # Truncate the result
  [[ ${#spotify} -gt 25 ]] && \
    spotify="$(echo "$spotify" | cut -c 1-25)..."

  if [[ -n "$spotify" ]]; then
    tm_segment "$music_icon" "cyan" "$spotify"
    tm_divider
  fi
}

# ---------------------------------------------

# Battery status
segment_battery() {
  if [[ $(command -v pmset) ]]; then
    battery_percentage="$(pmset -g batt | awk '{print $3}' | grep '%')"
    battery_status="$(pmset -g batt | awk '{print $4}' | grep 'char')"
    battery_color="yellow"

    [[ $battery_status == 'discharging;' ]] && battery_color="magenta"

    tm_segment "" "$battery_color" "${battery_percentage%?}"
    tm_divider
  fi
}

# ---------------------------------------------

# Date and time
segment_date() {
  tm_segment "" "colour243" "$(date +'%d %b %Y %H:%M')"
  tm_divider
}

# ---------------------------------------------

# Machine name
segment_host() {
  tm_segment "" "blue" "#h"
}

# ---------------------------------------------

# segment_headphones
segment_music
segment_battery
segment_date
segment_host
