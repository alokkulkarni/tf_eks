resource "kubectl_manifest" "service_account" {
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
    labels: 
        k8s-app: cluster-autoscaler
        k8s-addon: cluster-autoscaler.addons.k8s.io
    name: cluster-autoscaler
    namespace: kube-system
    annotations:
        eks.amazonaws.com/role-arn: ${aws_iam_role.my_eks_autoscaler_role.arn}
YAML
}

resource "kubectl_manifest" "role" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
    name: cluster-autoscaler
    namespace: kube-system
    labels:
        k8s-app: cluster-autoscaler
        k8s-addon: cluster-autoscaler.addons.k8s.io
rules:
    - apiGroups: [""]
      resources: ["configmaps"]
      verbs: ["create","list","watch"]
    - apiGroups: [""]
      resources: ["configmaps"]
      resourceNames: ["cluster-autoscaler-status", "cluster-autoscaler-priority-expander"]
      verbs: ["delete", "get", "update", "watch"]
YAML
}

resource "kubectl_manifest" "role_binding" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
    name: cluster-autoscaler
    namespace: kube-system
    labels:
        k8s-app: cluster-autoscaler
        k8s-addon: cluster-autoscaler.addons.k8s.io
roleRef:
    apiGroup: rbac.authorization.k8s.io
    kind: Role
    name: cluster-autoscaler
subjects:
    - kind: ServiceAccount
      name: cluster-autoscaler
      namespace: kube-system
YAML
}

resource "kubectl_manifest" "cluster_role" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
    name: cluster-autoscaler
    labels:
        k8s-app: cluster-autoscaler
        k8s-addon: cluster-autoscaler.addons.k8s.io
rules:
    - apiGroups: [""]
      resources: ["events", "endpoints"]
      verbs: ["create", "patch"]
    - apiGroups: [""]
      resources: ["pods/eviction"]
      verbs: ["create"]
    - apiGroups: [""]
      resources: ["pods/status"]
      verbs: ["update"]
    - apiGroups: [""]
      resources: ["endpoints"]
      resourceNames: ["cluster-autoscaler"]
      verbs: ["get", "update"]
    - apiGroups: [""]
      resources: ["nodes"]
      verbs: ["watch", "list", "get", "update"]
    - apiGroups: [""]
      resources:
          - "namespaces"
          - "pods"
          - "services"
          - "replicationcontrollers"
          - "persistentvolumeclaims"
          - "persistentvolumes"
      verbs: ["watch", "list", "get"]
    - apiGroups: ["extensions"]
      resources: ["replicasets", "daemonsets"]
      verbs: ["watch", "list", "get"]
    - apiGroups: ["policy"]
      resources: ["poddisruptionbudgets"]
      verbs: ["watch", "list"]
    - apiGroups: ["apps"]
      resources: ["statefulsets", "replicasets", "daemonsets"]
      verbs: ["watch", "list", "get"]
    - apiGroups: ["storage.k8s.io"]
      resources: ["storageclasses", "csinodes", "csidrivers", "csistoragecapacities"]
      verbs: ["watch", "list", "get"]
    - apiGroups: ["batch", "extensions"]
      resources: ["jobs"]
      verbs: ["get", "list", "watch", "patch"]
    - apiGroups: ["coordination.k8s.io"]
      resources: ["leases"]
      verbs: ["create"]
    - apiGroups: ["coordination.k8s.io"]
      resourceNames: ["cluster-autoscaler"]
      resources: ["leases"]
      verbs: ["get", "update"]
YAML
}

resource "kubectl_manifest" "cluster_role_binding" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
    name: cluster-autoscaler
    labels:
        k8s-app: cluster-autoscaler
        k8s-addon: cluster-autoscaler.addons.k8s.io
roleRef:
    apiGroup: rbac.authorization.k8s.io
    kind: ClusterRole
    name: cluster-autoscaler
subjects:
    - kind: ServiceAccount
      name: cluster-autoscaler
      namespace: kube-system
YAML
}