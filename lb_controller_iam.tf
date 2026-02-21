# 1. Buscar a Policy JSON oficial da AWS para o LB Controller
data "http" "lbc_iam_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json"
}

# 2. Criar a Policy no IAM
resource "aws_iam_policy" "lbc_policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy-devops-lab"
  description = "Permissoes para o AWS LB Controller gerenciar ALBs e Gateways"
  policy      = data.http.lbc_iam_policy.response_body
}

# 3. Criar a Role vinculada à Service Account (IRSA)
module "lbc_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name      = "load-balancer-controller-role"
  role_policy_arns = {
    policy = aws_iam_policy.lbc_policy.arn
  }

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}