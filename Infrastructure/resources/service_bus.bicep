param resource_name_prefix string
param location string

resource serviceBus 'Microsoft.ServiceBus/namespaces@2024-01-01' = {
  name: '${resource_name_prefix}01sb'
  location: location
  sku: {
    name:  'Standard'
  }
  properties: {}
}

resource servicebustopic 'Microsoft.ServiceBus/namespaces/topics@2024-01-01' = {
  parent: serviceBus
  name: 'parameterstopic1'
  properties: {
    enablePartitioning: false
    defaultMessageTimeToLive: 'P14D'
    maxSizeInMegabytes: 1024
    requiresDuplicateDetection: false
    duplicateDetectionHistoryTimeWindow: 'PT10M'
    enableBatchedOperations: true
    status: 'Active'
  }
}

// resource serviceBusQueue 'Microsoft.ServiceBus/namespaces/queues@2024-01-01' = {
//   parent: serviceBus
//   name: service_bus_queue_name
//   properties: {
//     lockDuration: 'PT5M'
//     maxSizeInMegabytes: 1024
//     requiresDuplicateDetection: false
//     requiresSession: false
//     defaultMessageTimeToLive: 'P14D'
//     deadLetteringOnMessageExpiration: true
//     duplicateDetectionHistoryTimeWindow: 'PT10M'
//     maxDeliveryCount: 10
//   }
// }
output service_bus_namespace_name string = serviceBus.name
