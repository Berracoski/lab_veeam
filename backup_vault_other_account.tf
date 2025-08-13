resource "aws_backup_vault" "lab_vault" {
  provider = aws.at-root
  name     = "lab-backup-vault"
}