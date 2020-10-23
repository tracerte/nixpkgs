{ music_directory ? ""}:
with import <nixpkgs>{};
writeText "mpd.conf" ''
# Recommended location for database
db_file            "~/.config/mpd/database"

# Logs to systemd journal
log_file           "syslog"

# The music directory is by default the XDG directory, uncomment to amend and choose a different directory
music_directory    "${music_directory}"

# Uncomment to refresh the database whenever files in the music_directory are changed
#auto_update "yes"

# Uncomment to enable the functionalities
playlist_directory "~/.config/mpd/playlists"
pid_file           "~/.config/mpd/pid"
#state_file         "~/.config/mpd/state"
sticker_file       "~/.config/mpd/sticker.sql"

user "tracerte"

audio_output {
        type            "pulse"
        name            "pulse audio"
        mixer_type      "software"
##      server          "remote_server"         # optional
##      sink            "remote_server_sink"    # optional
##      media_role      "media_role"            #optional
}

input {
        enabled    "no"
        plugin     "qobuz"
}

input {
        enabled      "no"
        plugin       "tidal"
}

decoder {
       enabled                  "no"
       plugin                   "wildmidi"
}
''
