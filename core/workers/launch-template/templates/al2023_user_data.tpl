#!/bin/bash
set -e
${pre_bootstrap_user_data ~}

# AL2023 uses nodeadm for bootstrapping
cat > /tmp/nodeadm-config.yaml << EOF
---
apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  cluster:
    name: ${cluster_name}
    apiServerEndpoint: ${cluster_endpoint}
    certificateAuthority: ${cluster_auth_base64}
    cidr: ${cluster_service_ipv4_cidr}
EOF

# Apply the nodeadm configuration
nodeadm init --config-source file:///tmp/nodeadm-config.yaml ${bootstrap_extra_args}

${post_bootstrap_user_data ~}
