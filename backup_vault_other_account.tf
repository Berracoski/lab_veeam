resource "aws_backup_vault" "lab_vault" {
  provider = aws.at-root
  name     = "lab-backup-vault"
}

resource "aws_backup_vault" "lab_vault_backup" {
  name = "lab-backup-vault-backup-account"
}