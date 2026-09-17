# Tutorial 3 — Configuration Management with Ansible, Puppet & Chef

Code and configuration from Tutorial 3 of *DevOps Learning Roadmap* by KC Ramo (Technovize Publishing).

**42 files.** Run everything from inside this directory.

## Contents

**YAML / manifests** (13)

- `inventory/aws_ec2.yml`
- `kitchen.yml`
- `playbook.yml`
- `playbooks/provision_appserver.yml`
- `playbooks/setup_webserver.yml`
- `roles/common/tasks/main.yml`
- `yaml-01.yaml`
- `yaml-02.yaml`
- `yaml-03.yaml`
- `yaml-04.yaml`
- `yaml-05.yaml`
- `yaml-06.yaml`
- `yaml-07.yaml`

**Snippets & config** (11)

- `templates/nginx.conf-2.j2`
- `templates/nginx.conf.j2`
- `text-01.txt`
- `text-02.txt`
- `text-03.txt`
- `text-04.txt`
- `text-05.txt`
- `text-06.txt`
- `text-07.txt`
- `text-08.txt`
- `text-09.txt`

**Shell scripts** (8)

- `bash-01.sh`
- `bash-02.sh`
- `bash-03.sh`
- `bash-04.sh`
- `bash-05.sh`
- `bash-06.sh`
- `bash-07.sh`
- `bash-08.sh`

**Puppet manifests** (3)

- `manifests/site.pp`
- `manifests/webserver.pp`
- `modules/myapp/manifests/init.pp`

**Ruby** (3)

- `cookbooks/myapp/attributes/default.rb`
- `cookbooks/myapp/recipes/default.rb`
- `test/integration/default/default_test.rb`

**ASCII diagrams** (2)

- `diagrams/diagram-01.txt`
- `diagrams/diagram-02.txt`

**Config** (2)

- `ansible.cfg`
- `inventory/hosts.ini`

## Notes

- Shell scripts are extracted from the book's command listings. Lines that were sample *output* in the book are commented out; the commands themselves are live. Read a script before you run it.
- Files that the book named explicitly (for example `Dockerfile`, `staging.tfvars`, `prometheus.yml`) keep that name. Everything else is numbered in the order it appears in the tutorial.
- Anything that creates cloud resources costs money if you leave it running. Destroy what you create at the end of each session.
