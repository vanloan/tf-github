resource "aws_s3_bucket" "test" {
  bucket = "loanvt-test"
}

locals {
  environment = "dev"

  github_repo = [
    "repo:vanloan/tf-github:*"
  ]
}

data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]
}

resource "aws_iam_role" "github" {
  name = "GithubActionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::351049001406:oidc-provider/token.actions.githubusercontent.com"
        }
        Condition = {
          "StringEquals" = {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
          },
          "ForAllValues:StringLike" = {
            "token.actions.githubusercontent.com:sub" = local.github_repo
          }
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github" {
  role       = aws_iam_role.github.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

import {
  to = aws_iam_openid_connect_provider.github
  id = "arn:aws:iam::351049001406:oidc-provider/token.actions.githubusercontent.com"
}

import {
  to = aws_iam_role.github
  id = "GithubActionRole"
}

import {
  to = aws_iam_role_policy_attachment.github
  id = "GithubActionRole/arn:aws:iam::aws:policy/AdministratorAccess"
}
