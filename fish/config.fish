if status is-interactive
    # Commands to run in interactive sessions can go here
end

# HiDPI scaling settings for GTK and Qt applications
set -x GDK_SCALE 1
set -x GDK_DPI_SCALE 0.5
set -x QT_AUTO_SCREEN_SCALE_FACTOR 1
set -x QT_SCALE_FACTOR 1
