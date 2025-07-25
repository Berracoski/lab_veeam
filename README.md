# lab_veeam

This repository automates the deployment of a cross-account Veeam Backup for AWS environment using Terraform. It creates and configures two Amazon VPCs — one in the backup account and another in a secondary account — enabling secure backup workflows between AWS accounts.

## Overview

The Terraform scripts in this repo provision:

- Two isolated VPCs in separate AWS accounts (Backup Account and Secondary Account).
- The secondary account’s VPC restricts access to private subnets only and configures endpoints for selective AWS APIs for secure connectivity.
- IAM roles and policies necessary for cross-account backup permissions between the two environments.
- Network configuration ensuring that backup traffic remains isolated and secure.

This setup leverages Veeam Backup for AWS to perform automated, compliant backup and recovery of workloads across AWS accounts, enhancing disaster recovery and operational resilience.

## Features

- Automated creation of AWS VPCs via Terraform.
- Cross-account IAM role trust and permissions configured for Veeam Backup.
- Restricted subnet access in the secondary account, allowing only necessary AWS API endpoint traffic.
- Infrastructure-as-code approach for repeatable and auditable environment setup.

## Prerequisites

- AWS accounts for the Backup and Secondary environments.
- Terraform installed locally (version compatible with AWS provider).
- AWS CLI configured with appropriate credentials for both accounts.
- Veeam Backup for AWS license and access to configure backup jobs.
- Permissions to create VPCs, endpoints, IAM roles, and policies in both AWS accounts.

## Deployment Instructions

1. Clone the repository:
```bash
git clone https://github.com/Berracoski/lab_veeam.git
cd lab_veeam
```

2. Review and update `terraform.tfvars` and variable files with your AWS account IDs, regions, Veeam license key, and configuration preferences.

3. Authenticate AWS CLI profiles or environment variables for both Backup and Secondary accounts as required.

4. Initialize Terraform:
```bash
terraform init
```
5. Apply the Terraform configuration:
```bash
terraform apply
```

6. Verify the creation of VPCs, endpoints, and IAM roles in both accounts.

7. Configure Veeam Backup for AWS using the deployed infrastructure to enable cross-account backups.

## Usage

Use this infrastructure to:

- Deploy isolated environments for Veeam backup operations with security best practices.
- Manage backups of AWS workloads across multiple accounts.
- Test recovery and compliance scenarios without impacting production workloads.

Refer to official Veeam Backup for AWS documentation for configuring backup jobs and leveraging the deployed infrastructure.

## .gitignore

This repository’s `.gitignore` excludes typical system files and Terraform state backups:

- `.terraform/`
- `*.tfstate`
- `.DS_Store`
- `Thumbs.db`
- Log files

## Contributing

Contributions, issues, and feature requests are welcome.

1. Fork the repository.
2. Create your feature branch (`git checkout -b feature-xyz`).
3. Commit your changes (`git commit -m 'Add new feature'`).
4. Push to your branch (`git push origin feature-xyz`).
5. Open a Pull Request.

## License

MIT License

---

*For more details on Veeam Backup for AWS and AWS cross-account backup setups, see:*

- [Veeam Backup for AWS official documentation](https://helpcenter.veeam.com/docs/vbaws/guide/welcome.html)
