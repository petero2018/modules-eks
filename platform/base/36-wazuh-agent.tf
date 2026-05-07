module "wazuh_agent" {
  count  = var.wazuh_agent_config.enable_agent ? 1 : 0
  source = "git@github.com:powise/terraform-modules//security/wazuh-agent?ref=wazuh-agent-0.8.2"

  eks_cluster = var.eks_cluster
  environment = var.wazuh_environment

  host_package_manager_type = var.wazuh_agent_config.host_package_manager_type

  tags = merge(var.tags, {
    # override standard tags for this security-centric resource
    team    = "security"
    impact  = "medium"
    service = "wazuh"
  })
}
