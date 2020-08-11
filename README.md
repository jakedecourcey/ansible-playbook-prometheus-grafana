# Prometheus + Grafana
---
This playbook installs and configures Prometheus and Grafana on a target server.

Usage
---
This deployment is designed to take advantage of Prometheus's file system scraper. To add new targets to Prometheus, either add them to an existing file in `roles/prometheus/files/hosts` or create a new file to represent a new location. Removing a files from that directory will remove  The main dashboard is called "Home" and should show a mixture of up and down locations currently.

Execute Playbook Example
---
`ansible-playbook -i inventory playbook.yml`
