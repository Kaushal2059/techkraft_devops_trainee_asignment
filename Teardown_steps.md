## Teardown

To stop and remove the Docker stack (containers, network) while keeping data:
```bash
docker compose down
```

To also remove the persistent Postgres volume that delets all database data as well
docker compose down -v
```

To fully clean up the VM environment:
```bash
# Remove cron jobs
crontab -r

# Remove scripts
sudo rm -rf /opt/scripts

# Remove logs
sudo rm -f /var/log/infra_health.log /var/log/infra_health_cron.log /var/log/db_backup_cron.log

# Remove backups
sudo rm -rf /var/backups/db

# Revert UFW to defaults (optional — only if decommissioning the whole VM)
sudo ufw reset
```

To revert SSH hardening :
```bash
sudo vim /etc/ssh/sshd_config
# remove or comment out the Port 2222 / PermitRootLogin no / PasswordAuthentication no lines
sudo systemctl enable ssh.socket
sudo systemctl restart ssh
```