[settings.kubernetes]
"cluster-name" = "${cluster_name}"
"api-server" = "${cluster_endpoint}"
"cluster-certificate" = "${cluster_auth_base64}"
[settings.kernel]
lockdown = "${kernel_lockdown}"
%{ if length(registry_mirrors) > 0 }
[settings.container-registry.mirrors]
"docker.io" = ${jsonencode(registry_mirrors)}
%{ endif }
${bootstrap_extra_args ~}
