## Service user for lab
resource "aws_iam_user" "lab_user" {
  name = "lab-user"
}

## Access and Secret keys for the lab user
resource "aws_iam_access_key" "lab_user_key" {
  user = aws_iam_user.lab_user.name
}

## Policys for install and configure in Veeam
## https://helpcenter.veeam.com/docs/vbaws/guide/req_permissions.html?ver=9#veeam-backup-for-aws-user-account-permissions
resource "aws_iam_policy" "plugin_full_list" {
  name        = "Plug-In-Full-List"
  description = "Policy for lab user to manage VPC and EC2 resources"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "cloudwatch:DeleteAlarms",
          "cloudwatch:PutMetricAlarm",
          "ec2:AllocateAddress",
          "ec2:AssociateAddress",
          "ec2:AssociateIamInstanceProfile",
          "ec2:AttachInternetGateway",
          "ec2:AttachVolume",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:CreateInternetGateway",
          "ec2:CreateKeyPair",
          "ec2:CreateRoute",
          "ec2:CreateSecurityGroup",
          "ec2:CreateSnapshot",
          "ec2:CreateSubnet",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:CreateVpc",
          "ec2:DeleteInternetGateway",
          "ec2:DeleteSecurityGroup",
          "ec2:DeleteSnapshot",
          "ec2:DeleteSubnet",
          "ec2:DeleteVolume",
          "ec2:DeleteVpc",
          "ec2:DescribeAddresses",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeIamInstanceProfileAssociations",
          "ec2:DescribeImages",
          "ec2:DescribeInstanceAttribute",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeInternetGateways",
          "ec2:DescribeKeyPairs",
          "ec2:DescribeManagedPrefixLists",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeRegions",
          "ec2:DescribeRouteTables",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSnapshots",
          "ec2:DescribeSubnets",
          "ec2:DescribeVolumeAttribute",
          "ec2:DescribeVolumes",
          "ec2:DescribeVpcs",
          "ec2:DetachInternetGateway",
          "ec2:DetachVolume",
          "ec2:DisassociateAddress",
          "ec2:DisassociateIamInstanceProfile",
          "ec2:GetManagedPrefixListEntries",
          "ec2:ModifyInstanceAttribute",
          "ec2:ModifyNetworkInterfaceAttribute",
          "ec2:ModifySubnetAttribute",
          "ec2:ModifyVpcAttribute",
          "ec2:ReleaseAddress",
          "ec2:RunInstances",
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:TerminateInstances",
          "iam:AddRoleToInstanceProfile",
          "iam:AttachRolePolicy",
          "iam:CreateInstanceProfile",
          "iam:CreatePolicy",
          "iam:CreatePolicyVersion",
          "iam:CreateRole",
          "iam:CreateServiceLinkedRole",
          "iam:DeleteInstanceProfile",
          "iam:DeletePolicy",
          "iam:DeletePolicyVersion",
          "iam:DeleteRole",
          "iam:DeleteRolePolicy",
          "iam:DetachRolePolicy",
          "iam:GetAccountSummary",
          "iam:GetContextKeysForPrincipalPolicy",
          "iam:GetInstanceProfile",
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:GetRole",
          "iam:ListAttachedRolePolicies",
          "iam:ListInstanceProfiles",
          "iam:ListInstanceProfilesForRole",
          "iam:ListPolicyVersions",
          "iam:ListRolePolicies",
          "iam:PassRole",
          "iam:PutRolePolicy",
          "iam:RemoveRoleFromInstanceProfile",
          "iam:SimulatePrincipalPolicy",
          "iam:UpdateAssumeRolePolicy",
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:Encrypt",
          "kms:ListAliases",
          "kms:ListKeys",
          "s3:CreateBucket",
          "s3:DeleteBucket",
          "s3:DeleteObject",
          "s3:DeleteObjectVersion",
          "s3:GetBucketLocation",
          "s3:GetBucketObjectLockConfiguration",
          "s3:GetBucketVersioning",
          "s3:GetObject",
          "s3:GetObjectRetention",
          "s3:GetObjectVersion",
          "s3:ListAllMyBuckets",
          "s3:ListBucket",
          "s3:ListBucketVersions",
          "s3:PutBucketAcl",
          "s3:PutBucketObjectLockConfiguration",
          "s3:PutBucketVersioning",
          "s3:PutObject",
          "s3:PutObjectRetention",
          "servicequotas:ListServiceQuotas",
          "ssm:DescribeInstanceInformation",
          "ssm:GetCommandInvocation",
          "ssm:GetParameter",
          "ssm:SendCommand",
          "sts:GetCallerIdentity"
        ],
        "Resource" : "*"
      }
    ]
    }
  )
}

## Attach the policy to the lab user
resource "aws_iam_user_policy_attachment" "lab_user_policy_attachment" {
  user       = aws_iam_user.lab_user.name
  policy_arn = aws_iam_policy.plugin_full_list.arn
}