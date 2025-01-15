param location string = resourceGroup().location

var containerAppEnvironmentName = 'jcp01-pub-sub-env'
var publisher_container_app_name = 'pub'
var daprPort = 3500 // Dapr sidecar port configured in Pub project client.UseHttpEndpoint("http://localhost:3500");

module application_insight_deployment './resources/application_insights.bicep' = {
  name: 'application_insights'
  params: {
    location: location
    resource_name_prefix: 'jcp'
  }
}

module containerAppEnv './resources/container_app_env.bicep' = {
  name: 'containerAppEnv'
  params: {
    name: containerAppEnvironmentName
    location: location
    log_analytics_workspace_id: application_insight_deployment.outputs.log_analytics_workspace_resource_id
    log_analytics_workspace_api_version: application_insight_deployment.outputs.log_analytics_workspace_resource_api_version
  }
}

module serviceBusDeployment './resources/service_bus.bicep' = {
  name: 'service_bus'
  params: {
    location: location
    resource_name_prefix: 'pubsubjcp'
  }
}

module pub_sub_component 'resources/dapr_components/pub_sub.bicep' = {
  name: 'pub_sub_component'
  dependsOn: [
    containerAppEnv
  ]
  params: {
    containerAppEnvironmentName: containerAppEnvironmentName
    serviceBusName: serviceBusDeployment.outputs.service_bus_namespace_name
    publisher_container_app_name: publisher_container_app_name
  }
}

module pub_container_app 'resources/container_app.bicep' = {
  name: 'pub_container_app'
  params: {
    containerAppName: publisher_container_app_name
    location: location
    container_app_env_id: containerAppEnv.outputs.id
    imageName: 'docker.io/jesuscorral/pub:jcp08'
    daprPort: daprPort
  }
}
