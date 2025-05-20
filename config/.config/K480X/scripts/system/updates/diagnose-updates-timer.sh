#!/usr/bin/env bash

echo "==> Checking user systemd timer & service status for updates..."

echo
echo "[TIMER STATUS]"
systemctl --user list-timers | grep check-updates || echo "❌ Timer not found"

echo
echo "[SERVICE STATUS]"
systemctl --user status check-updates.service --no-pager

echo
echo "[Last Run Logs]"
journalctl --user-unit=check-updates.service -n 10 --no-pager

