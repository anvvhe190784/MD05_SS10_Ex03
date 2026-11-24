#!/bin/bash
set -euo pipefail

# Script tăng cường bảo mật SSH cho VPS Ubuntu (chỉ tắt mật khẩu khi đã có authorized_keys cho deploy)

if [ "$(id -u)" -ne 0 ]; then
  echo "Vui lòng chạy script này với quyền root hoặc sudo (sudo bash $0)"
  exit 1
fi

AUTH_KEYS="/home/deploy/.ssh/authorized_keys"

echo "=== [1/4] Kiểm tra khóa Public Key của user 'deploy' ==="
if [ ! -s "$AUTH_KEYS" ]; then
  echo "LỖI: Chưa tìm thấy Public Key trong $AUTH_KEYS!"
  echo "Vui lòng copy file .pub từ máy cá nhân vào $AUTH_KEYS trước để tránh bị khóa ngoài VPS."
  exit 1
fi

chmod 700 /home/deploy/.ssh
chmod 600 "$AUTH_KEYS"
chown -R deploy:deploy /home/deploy/.ssh

echo "=== [2/4] Backup và cấu hình /etc/ssh/sshd_config + sshd_config.d ==="
cp /etc/ssh/sshd_config "/etc/ssh/sshd_config.bak.$(date +%F_%H%M%S)"
mkdir -p /etc/ssh/sshd_config.d

cat <<'EOF' > /etc/ssh/sshd_config.d/99-hardening.conf
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
KbdInteractiveAuthentication no
EOF

sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config

echo "=== [3/4] Kiểm tra cú pháp sshd ==="
sshd -t

echo "=== [4/4] Khởi động lại dịch vụ SSH ==="
systemctl restart ssh || systemctl restart sshd
echo "Hoàn tất! Hãy giữ terminal hiện tại và mở terminal mới test 'ssh root@<VPS_IP>' (phải bị từ chối)."
