@description('Specifies the location for resources')
param location string
@description('Full prefix for resource naming, including the environment, location and deployment prefixes')
param resource_name_prefix string


var application_insights_suffix = 'ain'
var workspace_suffix = 'la'

resource workspace_resource 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: '${resource_name_prefix}-${workspace_suffix}'
  location: location
  properties: {
    sku: {
      name: 'pergb2018'
    }
    retentionInDays: 30
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
      
    }
    workspaceCapping: {
      dailyQuotaGb: -1
    }
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'    
  }
}
output log_analytics_workspace_resource_id string = workspace_resource.id
output log_analytics_workspace_resource_api_version string = workspace_resource.apiVersion



resource components_sds_arm_ain_name_resource 'Microsoft.Insights/components@2020-02-02' = {
  name: '${resource_name_prefix}-${application_insights_suffix}'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Flow_Type: 'Redfield'
    Request_Source: 'IbizaAIExtension'
    RetentionInDays: 90
    WorkspaceResourceId: workspace_resource.id
    IngestionMode: 'LogAnalytics'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
    
  }
  dependsOn: [workspace_resource]
}

output instrumentation_key_connection_string string = components_sds_arm_ain_name_resource.properties.ConnectionString
output instrumentation_key string = components_sds_arm_ain_name_resource.properties.InstrumentationKey
