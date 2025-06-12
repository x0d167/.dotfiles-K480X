#!/usr/bin/env bash

CONFIG="$HOME/.config/rofi/config-powermenu.rasi"
UPTIME="$(uptime -p | sed 's/up //')"
HOST="$(cat /proc/sys/kernel/hostname)"
USER_PROMPT=" $USER@$HOST"

# Icons
hibernate='󰤄'
shutdown='󰐥'
reboot='󰜉'
lock=''
suspend=''
logout='󰍃'
yes=''
no=''

# Main Menu
show_menu() {
	echo -e "$lock\n$suspend\n$logout\n$hibernate\n$reboot\n$shutdown" | \
		rofi -dmenu \
		-p "$USER_PROMPT" \
		-mesg "󰣇 Uptime: $UPTIME" \
		-theme "$CONFIG"
}

# Confirmation
confirm() {
	echo -e "$yes\n$no" | \
		rofi -dmenu \
		-p 'Confirmation' \
		-mesg 'Are you sure?' \
		-theme "$CONFIG"
}

# Graceful Hyprland logout
terminate_clients() {
	TIMEOUT=5
	client_pids=$(hyprctl clients -j | jq -r '.[] | .pid')

	for pid in $client_pids; do
		kill -15 "$pid"
	done

	start_time=$(date +%s)
	for pid in $client_pids; do
		while kill -0 "$pid" 2>/dev/null; do
			if (( $(date +%s) - start_time >= TIMEOUT )); then
				return
			fi
			sleep 1
		done
	done
}

# Actions
confirm_and_run() {
	[[ "$(confirm)" == "$yes" ]] || exit 0
	case "$1" in
		shutdown)
			terminate_clients
			sleep 0.5
			systemctl poweroff
			;;
		reboot)
			terminate_clients
			sleep 0.5
			systemctl reboot
			;;
		hibernate)
			sleep 0.5
			systemctl hibernate
			;;
		suspend)
			sleep 0.5
			systemctl suspend
			;;
		logout)
			terminate_clients
			sleep 0.5
			hyprctl dispatch exit
			sleep 2
			;;
	esac
}

# Main
case "$(show_menu)" in
	$lock)
		sleep 0.5
		hyprlock
		;;
	$suspend) confirm_and_run suspend ;;
	$logout) confirm_and_run logout ;;
	$hibernate) confirm_and_run hibernate ;;
	$reboot) confirm_and_run reboot ;;
	$shutdown) confirm_and_run shutdown ;;
esac

