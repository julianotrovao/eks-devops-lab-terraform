module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "vpc-devops-lab"
  cidr = "10.0.0.0/16"

  # Distribuição em 3 Zonas de Disponibilidade para Alta Disponibilidade
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  # Habilita NAT Gateway (obrigatório para nós em subnets privadas baixarem imagens)
  enable_nat_gateway     = true
  single_nat_gateway     = true # Para laboratório, use 'true'. Para produção, 'false'.
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  # TAGS CRÍTICAS: O EKS e o Karpenter usam essas tags para descobrir a rede
  public_subnet_tags = {
    "kubernetes.io/cluster/devops-lab" = "shared"
    "kubernetes.io/role/elb"           = "1" # Permite criar LBs públicos
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/devops-lab" = "shared"
    "kubernetes.io/role/internal-elb"  = "1" # Permite criar LBs internos
    "karpenter.sh/discovery"           = "devops-lab" # Tag que o Karpenter usa
  }

  tags = {
    Environment = "dev"
    Project     = "devops-lab"
  }
}