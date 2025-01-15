param containerAppName string
param location string
param container_app_env_id string
param imageName string
param daprPort int

resource containerApp 'Microsoft.App/containerApps@2024-03-01' = {
  name: containerAppName
  location: location
  properties: {
    managedEnvironmentId: container_app_env_id
    configuration: {
      dapr: {
        enabled: true
        appId: containerAppName
        appPort: daprPort
      }
      ingress: {
        external: true
        targetPort: 8080
        transport: 'auto'
      }
    }
    template: {
      containers: [
        {
          name: containerAppName
          image: imageName
          resources: {
            cpu: 2
            memory: '4.0Gi'
          }
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 2
      }
    }
  }
}

