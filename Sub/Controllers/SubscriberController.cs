using System.Text.Json;
using Dapr;
using Microsoft.AspNetCore.Mvc;

namespace Sub.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class SubscriberController : ControllerBase
    {
        private readonly ILogger<SubscriberController> _logger;

        public SubscriberController(ILogger<SubscriberController> logger)
        {
            _logger = logger;
        }

        [Topic("dapr.pubsub.jcp", "parameterstopic1")]
        [HttpPost("parametersreceived")]
        public async Task<IActionResult> ParametersReceived([FromBody] string jsonElement)
        {

            var parameters = JsonSerializer.Deserialize<Dictionary<string, object>>(jsonElement);

            if (parameters == null)
            {
                return BadRequest();
            }
            var first = parameters.First();
            Console.WriteLine($"Received parameters {first.Key} = {first.Value}");

            return Ok();
        }
    }
}
