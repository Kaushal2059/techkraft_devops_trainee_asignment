# IT Infrastructure & DevOps Trainee Practical Assignment

## Task 1: System Provisioning & Linux Administration

### Steps
1. Created `trainee` user with sudo privileges:

commands used:
- sudo adduser trainee
- sudo usermod -aG sudo trainee

2. Generated an SSH key pair on host, copied public key to `trainee`'s `~/.ssh/authorized_keys`.
3. Hardened `/etc/ssh/sshd_config`by adding the following lines
   - `Port 2222`
   - `PermitRootLogin no`
   - `PasswordAuthentication no`
   - `PubkeyAuthentication yes`
4. Disabled `ssh.socket` (Ubuntu 22.04 socket activation overrides `sshd_config`'s `Port` directive otherwise):
- commands used:
    - sudo systemctl stop ssh.socket
    - sudo systemctl disable ssh.socket
    - sudo systemctl restart ssh.service

5. Configured UFW to allow only SSH (2222), HTTP (80), HTTPS (443):

- Commands used:
    - sudo ufw allow 2222/tcp
    - sudo ufw allow 80/tcp
    - sudo ufw allow 443/tcp
    - sudo ufw enable


### Verification
- `ssh -p 2222 trainee@192.168.221.145` connects via key, no password prompt.
![ssh-confirmation](docs/screenshots/ssh-login-confirmation.png)
- `ssh -p 2222 root@192.168.221.145` is rejected (root login disabled).
![root-deny-confirmation](docs/screenshots/root-deny.png)
- `sudo ufw status verbose` confirms only 2222/80/443 allowed:
![UFW-Status](docs/screenshots/ufw-status.png)

## Task 2: Containerization & Web Services

### Stack
- **nginx** (reverse proxy) listens on host port 80, forwards to the Flask app
- **app** (Flask backend) internal port 5000, not exposed to host directly
- **db** (PostgreSQL) persistent volume `db_data`, includes a healthcheck so `app` waits until the database is actually ready to accept connections, not just started

### Steps
1. Installed Docker Engine + Compose plugin from Docker's official apt repo.
2. Built a minimal Flask app (`app/app.py`) returning a confirmation message.
3. Wrote `nginx/nginx.conf` to reverse-proxy all requests to the Flask app container by service name.
4. Wrote `docker-compose.yml` defining all three services, with:
   - A named volume for Postgres data persistence
   - A bind-mounted `nginx.conf`
   - A `healthcheck` on `db` using `pg_isready`, and `depends_on: condition: service_healthy` on `app`

### Verification

- docker compose up -d --build
- docker ps


![Docker containers running](docs/screenshots/docker-ps.png)

Routing verified via:

curl http://localhost/

and via browser at `http://192.168.221.142/`:

![Browser output via reverse proxy](docs/screenshots/browser-output.png)

## Task 3: Automation & Shell Scripting

### Script: `/opt/scripts/infra_health_check.sh`
Checks CPU, RAM, and root disk usage, verifies Docker is running and the app container is up. If disk usage exceeds 85% or the app container is stopped, prints a `[WARNING]` and appends a timestamped entry to `/var/log/infra_health.log`.

### Cron job
Runs every 15 minutes via `trainee`'s crontab:

*/15 * * * * /opt/scripts/infra_health_check.sh >> /var/log/infra_health_cron.log 2>&1


### Verification
- Manual run confirmed CPU/RAM/disk stats print correctly.
- Stopping the app container and re-running triggered a `[WARNING]` and a log entry in `/var/log/infra_health.log`.
- Cron job confirmed firing by temporarily setting it to run every minute and checking `/var/log/infra_health_cron.log` for output.

![Health check script output](docs/screenshots/health-check-log.png)

## Task 4: Monitoring, Backups & Disaster Recovery

## Task 5: Git & Documentation