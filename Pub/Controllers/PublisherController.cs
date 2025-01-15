using System.Text.Json;
using System.Text.Json.Serialization;
using Dapr.Client;
using Microsoft.AspNetCore.Mvc;

namespace Pub.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class PublisherController : ControllerBase
    {
        private readonly DaprClient _daprClient;
        private readonly ILogger<PublisherController> _logger;

        public PublisherController(DaprClient daprClient,
                                   ILogger<PublisherController> logger)
        {
            _logger = logger;
            _daprClient = daprClient;
        }

        [HttpPost(Name = "SendParametersToServiceBus")]
        public async Task<IActionResult> SendParametersToServiceBus()
        {
            var parameters = new Dictionary<string, object>
            {
                { "name", "John" },
                { "age", 30 }
            };

            string parmsSerialized = JsonSerializer.Serialize(parameters);

            Console.WriteLine($"Publishing parameters: {parmsSerialized}");

            var topicName = "parameterstopic1";
            var subscriptionName = "dapr.pubsub.jcp";

            await _daprClient.PublishEventAsync(subscriptionName, topicName, parmsSerialized); // "dapr.pubsub.jcp" es el nombre del componente de pubsub en el archivo components
            // await _daprClient.PublishEventAsync(subscriptionName, "topic.1", parmsSerialized); // TODO - Prueba para service bus local
            Console.WriteLine($"Parameters sent to Service Bus, topic name: {topicName}, subscription name: {subscriptionName}");

            return Ok();
        }
    }
}
