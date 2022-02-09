variable "iac" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa.gov.it-infrastructure"
      branch_name     = "main"
      pipelines_path  = "pipeline"
      yml_prefix_name = null
    }
    pipeline = {
      enable_code_review = true
      enable_deploy      = true
    }
  }
}

module "iac_deploy" {
  source = "./modules/azuredevops_build_definition_deploy"

  project_id                   = azuredevops_project.this.id
  repository                   = var.iac.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.github_pr.id

  ci_trigger_use_yaml = true


  variables        = {}
  variables_secret = {}

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.github_ro.id,
    azuredevops_serviceendpoint_aws.serviceendpoint.id,
  ]
}