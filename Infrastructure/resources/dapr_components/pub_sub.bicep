param containerAppEnvironmentName string
param serviceBusName string
param publisher_container_app_name string

resource existing_environment 'Microsoft.App/managedEnvironments@2024-03-01' existing = {
  name: containerAppEnvironmentName
}

resource existing_service_bus 'Microsoft.ServiceBus/namespaces@2024-01-01' existing = {
  name: serviceBusName
}

resource serviceBusNamespaceAuthRule 'Microsoft.ServiceBus/namespaces/authorizationRules@2024-01-01' existing = {
  parent: existing_service_bus
  name: 'RootManageSharedAccessKey'
}

resource pub_sub_component 'Microsoft.App/managedEnvironments/daprComponents@2023-05-01' = {
  name: 'dapr.pubsub.jcp'
  parent: existing_environment
  properties: {
    componentType: 'pubsub.azure.servicebus'
    version: 'v1'
    initTimeout: '5s'
    ignoreErrors: false
    secrets: [
      {
        name: 'sb-root-connectionstring'
        value: serviceBusNamespaceAuthRule.listKeys().primaryConnectionString
      }
    ]
    metadata: [
      // TODO - Revisar!!! 
      {
        name: 'connectionString'
        secretRef: 'sb-root-connectionstring'
      }
    ]
    scopes: [
      publisher_container_app_name
    ]
  }
}
