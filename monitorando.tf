# Namespace para monitoramento
resource "kubernetes_namespace" "monitoring" {
  metadata { name = "monitoring" }
}

# Helm Release para o Grafana
resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  set {
    name  = "adminPassword"
    value = "admin123" # Troque em produção
  }
}

# Grafana Agent (Coleta logs/métricas/OTLP e envia para Loki/Mimir)
resource "helm_release" "grafana_agent" {
  name       = "grafana-agent"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana-agent-operator"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
}

# Loki (Logs)
resource "helm_release" "loki" {
  name       = "loki"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki-stack"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
}