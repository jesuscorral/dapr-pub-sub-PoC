param name string
param location string
param log_analytics_workspace_id string
param log_analytics_workspace_api_version string

resource containerAppEnv 'Microsoft.App/managedEnvironments@2024-03-01' = {
  name: name
  location: location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: reference(log_analytics_workspace_id, log_analytics_workspace_api_version).customerId
        sharedKey: listKeys(log_analytics_workspace_id, log_analytics_workspace_api_version).primarySharedKey
      }
    }
  }
}

output id string = containerAppEnv.id
 