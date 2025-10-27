#!/bin/sh
icon_up="󰌘"
icon_down="󰌙"
proxmox_ip="92.168.8.110"

syncthing=$(systemctl --user is-active syncthing.service >/dev/null && echo "$icon_up" || echo "$icon_down")
tailscale=$(systemctl is-active tailscaled >/dev/null && echo "$icon_up" || echo "$icon_down")
proxmox=$(ping -c1 -W1 "$proxmox_ip" >/dev/null && echo "$icon_up" || echo "$icon_down")

printf "%s\n%s\n%s\n" "$syncthing" "$tailscale" "$proxmox"
