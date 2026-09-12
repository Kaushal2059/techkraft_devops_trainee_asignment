# IT Infrastructure & DevOps Trainee Practical Assignment

## Task 1: System Provisioning & Linux Administration

### Steps
1. Created `trainee` user with sudo privileges:

commands used:
sudo adduser trainee
sudo usermod -aG sudo trainee

2. Generated an SSH key pair on host, copied public key to `trainee`'s `~/.ssh/authorized_keys`.
3. Hardened `/etc/ssh/sshd_config`by adding the following lines
   - `Port 2222`
   - `PermitRootLogin no`
   - `PasswordAuthentication no`
   - `PubkeyAuthentication yes`
4. Disabled `ssh.socket` (Ubuntu 22.04 socket activation overrides `sshd_config`'s `Port` directive otherwise):
commands used:
sudo systemctl stop ssh.socket
sudo systemctl disable ssh.socket
sudo systemctl restart ssh.service

5. Configured UFW to allow only SSH (2222), HTTP (80), HTTPS (443):

Commands used:
sudo ufw allow 2222/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable


### Verification
- `ssh -p 2222 trainee@<vm-ip>` connects via key, no password prompt.
![ssh-confirmation](docs/screenshots/ssh-login-confirmation.png)
- `ssh -p 2222 root@<vm-ip>` is rejected (root login disabled).
![root-deny-confirmation](docs/screenshots/root-deny.png)
- `sudo ufw status verbose` confirms only 2222/80/443 allowed:
![UFW-Status](docs/screenshots/ufw-status.png)

## Task 2: Containerization & Web Services

## Task 3: Automation & Shell Scripting

## Task 4: Monitoring, Backups & Disaster Recovery

## Task 5: Git & Documentation