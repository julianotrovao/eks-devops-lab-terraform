# Instalando o Loki (Logs)
resource "helm_release" "loki" {
  name       = "loki"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki-stack"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  set {
    name  = "loki.persistence.enabled"
    value = "true"
  }
  set {
    name  = "loki.persistence.size"
    value = "10Gi"
  }
}

# Configurando o Grafana com Data Sources Automáticos
resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  values = [
    <<-EOT
    datasources:
      datasources.yaml:
        apiVersion: 1
        datasources:
        - name: Loki
          type: loki
          access: proxy
          url: http://loki.monitoring.svc.cluster.local:3100
        - name: Prometheus
          type: prometheus
          access: proxy
          url: http://prometheus-server.monitoring.svc.cluster.local
    EOT
  ]

  set {
    name  = "adminPassword"
    value = "admin123"
  }
}