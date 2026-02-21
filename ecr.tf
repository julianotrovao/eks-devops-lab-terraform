resource "aws_ecr_repository" "frontend" {
  name                 = "alomundo-frontend"
  image_tag_mutability = "IMMUTABLE" # Segurança: não permite sobrescrever a mesma tag

  image_scanning_configuration {
    scan_on_push = true # Escaneia vulnerabilidades automaticamente
  }
}

output "repository_url" {
  value = aws_ecr_repository.frontend.repository_url
}