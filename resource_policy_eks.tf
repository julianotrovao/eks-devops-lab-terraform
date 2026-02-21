resource "aws_iam_policy" "eks_ecr_read" {
  name        = "EKS-Read-Specific-ECR"
  description = "Permite que o EKS leia apenas o repo de treinamento"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability"
        ]
        Effect   = "Allow"
        # Aqui usamos a referência ao seu data source:
        Resource = data.aws_ecr_repository.frontend.arn
      },
      {
        Action   = "ecr:GetAuthorizationToken"
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}