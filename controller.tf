resource "helm_release" "aws_lb_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  set {
    name  = "clusterName"
    value = "devops-lab"
  }
  set {
    name  = "serviceAccount.create"
    value = "true"
  }
  # Nota: É necessário anexar a IAM Policy específica do LB Controller à ServiceAccount
}