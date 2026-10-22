# kiro-wayfire: software cursor for wayfire inside a VM.
# QEMU virtio-gpu draws the wlroots hardware cursor away from where clicks land
# (Calamares buttons unclickable). SDDM's wayland-session sources /etc/profile,
# so this reaches wayfire before it starts. Real hardware keeps the hardware cursor.
case "${XDG_SESSION_DESKTOP:-}" in
    Wayfire*)
        if systemd-detect-virt -q 2>/dev/null; then
            export WLR_NO_HARDWARE_CURSORS=1
        fi
        ;;
esac
