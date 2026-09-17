# Tutorial 7 — Monitoring & Observability

Code and configuration from Tutorial 7 of *DevOps Learning Roadmap* by KC Ramo (Technovize Publishing).

**44 files.** Run everything from inside this directory.

## Contents

**Snippets & config** (17)

- `text-01.txt`
- `text-02.txt`
- `text-03.txt`
- `text-04.txt`
- `text-05.txt`
- `text-06.txt`
- `text-07.txt`
- `text-08.txt`
- `text-09.txt`
- `text-10.txt`
- `text-11.txt`
- `text-12.txt`
- `text-13.txt`
- `text-14.txt`
- `text-15.txt`
- `text-16.txt`
- `text-17.txt`

**YAML / manifests** (12)

- `docker-compose.yml`
- `k8s/monitoring/service-monitor.yaml`
- `monitoring/alertmanager-config.yaml`
- `monitoring/alerts/application.yaml`
- `monitoring/dashboards/app-overview-configmap.yaml`
- `monitoring/fluent-bit-config.yaml`
- `monitoring/otel-collector-config.yaml`
- `monitoring/prometheus-values.yaml`
- `prometheus.yml`
- `yaml-01.yaml`
- `yaml-02.yaml`
- `yaml-03.yaml`

**Shell scripts** (6)

- `bash-01.sh`
- `bash-02.sh`
- `bash-03.sh`
- `bash-04.sh`
- `bash-05.sh`
- `bash-06.sh`

**Python** (5)

- `python-01.py`
- `python-02.py`
- `python-03.py`
- `python-04.py`
- `python-05.py`

**JSON** (2)

- `json-01.json`
- `json-02.json`

**ASCII diagrams** (1)

- `diagrams/diagram-01.txt`

**Config** (1)

- `ini-01.ini`

## Notes

- Shell scripts are extracted from the book's command listings. Lines that were sample *output* in the book are commented out; the commands themselves are live. Read a script before you run it.
- Files that the book named explicitly (for example `Dockerfile`, `staging.tfvars`, `prometheus.yml`) keep that name. Everything else is numbered in the order it appears in the tutorial.
- Anything that creates cloud resources costs money if you leave it running. Destroy what you create at the end of each session.
