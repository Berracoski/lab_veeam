## IAM Role for Cross-Account Access
resource "aws_iam_role" "veeam_for_aws_cross_account_role" {
  provider = aws.at-root
  name     = "veeam-for-aws-access-role-at-account"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : [
            "batchoperations.s3.amazonaws.com",
            "ec2.amazonaws.com"
          ]
        }
      },
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "AWS" : "arn:aws:iam::528775625753:role/aws-appliance-veeam-VeeamImpersonationRoleV1-AI9KMCR6T5BK" ## Replace with Veeam created role
        }
      }
    ]
  })
  description = "IAM role for for Veeam for AWS cross-account access"
}

## Policy for Worker
resource "aws_iam_policy" "worker_backup_account" {
  provider    = aws.at-root
  name        = "veeam-worker-cross-account-policy"
  description = "Policy for Worker in another account be able to make backups"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ebs:ListChangedBlocks",
          "ebs:ListSnapshotBlocks",
          "ec2:AllocateAddress",
          "ec2:AssignPrivateIpAddresses",
          "ec2:AssociateAddress",
          "ec2:AssociateIamInstanceProfile",
          "ec2:AttachNetworkInterface",
          "ec2:AttachVolume",
          "ec2:CopySnapshot",
          "ec2:CreateKeyPair",
          "ec2:CreateNetworkInterface",
          "ec2:CreateSnapshot",
          "ec2:CreateSnapshots",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:DeleteKeyPair",
          "ec2:DeleteNetworkInterface",
          "ec2:DeleteSnapshot",
          "ec2:DeleteTags",
          "ec2:DeleteVolume",
          "ec2:DescribeAccountAttributes",
          "ec2:DescribeAddresses",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeConversionTasks",
          "ec2:DescribeImages",
          "ec2:DescribeInstanceAttribute",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceStatus",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeKeyPairs",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeRegions",
          "ec2:DescribeRouteTables",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSnapshotAttribute",
          "ec2:DescribeSnapshots",
          "ec2:DescribeSubnets",
          "ec2:DescribeTags",
          "ec2:DescribeVolumeAttribute",
          "ec2:DescribeVolumes",
          "ec2:DescribeVpcEndpoints",
          "ec2:DescribeVpcs",
          "ec2:DetachVolume",
          "ec2:DisassociateAddress",
          "ec2:GetEbsDefaultKmsKeyId",
          "ec2:ModifyInstanceAttribute",
          "ec2:ModifyNetworkInterfaceAttribute",
          "ec2:ModifySnapshotAttribute",
          "ec2:ModifyVolume",
          "ec2:RunInstances",
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:TerminateInstances",
          "ec2messages:AcknowledgeMessage",
          "ec2messages:DeleteMessage",
          "ec2messages:FailMessage",
          "ec2messages:GetEndpoint",
          "ec2messages:GetMessages",
          "ec2messages:SendReply",
          "events:DeleteRule",
          "events:DescribeRule",
          "events:ListTargetsByRule",
          "events:PutRule",
          "events:PutTargets",
          "events:RemoveTargets",
          "iam:AddRoleToInstanceProfile",
          "iam:AttachRolePolicy",
          "iam:CreateInstanceProfile",
          "iam:CreateRole",
          "iam:DeleteInstanceProfile",
          "iam:DeleteRole",
          "iam:DeleteRolePolicy",
          "iam:DetachRolePolicy",
          "iam:GetContextKeysForPrincipalPolicy",
          "iam:GetInstanceProfile",
          "iam:GetRole",
          "iam:ListAccountAliases",
          "iam:ListAttachedRolePolicies",
          "iam:ListInstanceProfiles",
          "iam:ListInstanceProfilesForRole",
          "iam:ListRolePolicies",
          "iam:PassRole",
          "iam:PutRolePolicy",
          "iam:RemoveRoleFromInstanceProfile",
          "iam:SimulatePrincipalPolicy",
          "kinesis:CreateStream",
          "kinesis:DeleteStream",
          "kinesis:DescribeStream",
          "kinesis:PutRecord",
          "kms:CreateGrant",
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:Encrypt",
          "kms:GenerateDataKeyWithoutPlaintext",
          "kms:GetKeyPolicy",
          "kms:ListAliases",
          "kms:ListKeys",
          "kms:ReEncryptFrom",
          "kms:ReEncryptTo",
          "s3:CreateJob",
          "s3:DeleteObject",
          "s3:DeleteObjectVersion",
          "s3:DescribeJob",
          "s3:GetBucketLocation",
          "s3:GetBucketObjectLockConfiguration",
          "s3:GetBucketVersioning",
          "s3:GetObject",
          "s3:GetObjectRetention",
          "s3:GetObjectVersion",
          "s3:ListAllMyBuckets",
          "s3:ListBucket",
          "s3:ListBucketVersions",
          "s3:PutObject",
          "s3:PutObjectRetention",
          "s3:RestoreObject",
          "servicequotas:ListServiceQuotas",
          "sns:CreateTopic",
          "sns:DeleteTopic",
          "sns:ListSubscriptionsByTopic",
          "sns:ListTopics",
          "sns:SetTopicAttributes",
          "sns:Subscribe",
          "sns:Unsubscribe",
          "sqs:CreateQueue",
          "sqs:DeleteMessage",
          "sqs:DeleteQueue",
          "sqs:ListQueues",
          "sqs:ReceiveMessage",
          "sqs:SendMessage",
          "sqs:SetQueueAttributes",
          "ssm:DescribeAssociation",
          "ssm:DescribeDocument",
          "ssm:DescribeInstanceInformation",
          "ssm:GetCommandInvocation",
          "ssm:GetDeployablePatchSnapshotForInstance",
          "ssm:GetDocument",
          "ssm:GetManifest",
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:ListAssociations",
          "ssm:ListInstanceAssociations",
          "ssm:PutComplianceItems",
          "ssm:PutConfigurePackageResult",
          "ssm:PutInventory",
          "ssm:SendCommand",
          "ssm:UpdateAssociationStatus",
          "ssm:UpdateInstanceAssociationStatus",
          "ssm:UpdateInstanceInformation",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ],
        "Resource" : "*"
      }
    ]
    }
  )
}

## Attach the policy to the role
resource "aws_iam_role_policy_attachment" "worker_backup_account_attachment" {
  provider   = aws.at-root
  role       = aws_iam_role.veeam_for_aws_cross_account_role.name
  policy_arn = aws_iam_policy.worker_backup_account.arn
}


## Instance Profile
resource "aws_iam_instance_profile" "veeam_instance_profile" {
  provider = aws.at-root
  name     = "veeam-for-aws-instance-profile"
  role     = aws_iam_role.veeam_for_aws_cross_account_role.name
}