# Bài tập 3: Tăng cường bảo mật SSH

## 1. Các tệp cấu hình & Hướng dẫn
- [`commands.txt`](./commands.txt): Trọn bộ lệnh tạo SSH Key trên Windows PowerShell, đẩy Public Key lên `/home/deploy/.ssh/authorized_keys`, cấu hình `/etc/ssh/sshd_config` và kiểm chứng từ chối `root`.
- [`harden-ssh.sh`](./harden-ssh.sh): Script kiểm tra an toàn (chặn tắt mật khẩu nếu chưa có `authorized_keys`) và áp dụng cấu hình `PermitRootLogin no`, `PasswordAuthentication no` (kèm override thư mục `sshd_config.d` cho Cloud VPS).

## 2. Lưu ý bảo mật quan trọng
- **TUYỆT ĐỐI KHÔNG** đưa Private Key (`id_ed25519_vps`) lên GitHub hoặc gửi qua chat.
- Luôn giữ phiên SSH hiện tại cho tới khi mở được cửa sổ PowerShell thứ 2 đăng nhập thành công bằng `ssh -i ... deploy@<VPS_PUBLIC_IP>`.

## 3. Ảnh minh chứng nộp bài
- Chụp terminal khi chạy `ssh root@<VPS_PUBLIC_IP>` bị từ chối (`Permission denied (publickey)`), lưu tại `homework/session_10/exercise_03/ssh_root_denied.png`.
