# Tutorial 6 — Infrastructure as Code with Terraform & CloudFormation

Code and configuration from Tutorial 6 of *DevOps Learning Roadmap* by KC Ramo (Technovize Publishing).

**41 files.** Run everything from inside this directory.

## Contents

**Terraform / HCL** (20)

- `alb.tf`
- `backend.tf`
- `database.tf`
- `main.tf`
- `modules/vpc/variables.tf`
- `networking.tf`
- `outputs.tf`
- `providers.tf`
- `staging.tfvars`
- `terraform-01.tf`
- `terraform-02.tf`
- `terraform-03.tf`
- `terraform-04.tf`
- `terraform-05.tf`
- `terraform-06.tf`
- `terraform-07.tf`
- `terraform-08.tf`
- `terraform-09.tf`
- `terraform-10.tf`
- `variables.tf`

**Shell scripts** (15)

- `bash-01.sh`
- `bash-02.sh`
- `bash-03.sh`
- `bash-04.sh`
- `bash-05.sh`
- `bash-06.sh`
- `bash-07.sh`
- `bash-08.sh`
- `bash-09.sh`
- `bash-10.sh`
- `bash-11.sh`
- `bash-12.sh`
- `bash-13.sh`
- `bash-14.sh`
- `bash-15.sh`

**YAML / manifests** (3)

- `cloudformation/vpc.yaml`
- `yaml-01.yaml`
- `yaml-02.yaml`

**ASCII diagrams** (1)

- `diagrams/diagram-01.txt`

**Go** (1)

- `test/vpc_test.go`

**Snippets & config** (1)

- `text-01.txt`

## Notes

- Shell scripts are extracted from the book's command listings. Lines that were sample *output* in the book are commented out; the commands themselves are live. Read a script before you run it.
- Files that the book named explicitly (for example `Dockerfile`, `staging.tfvars`, `prometheus.yml`) keep that name. Everything else is numbered in the order it appears in the tutorial.
- Anything that creates cloud resources costs money if you leave it running. Destroy what you create at the end of each session.
