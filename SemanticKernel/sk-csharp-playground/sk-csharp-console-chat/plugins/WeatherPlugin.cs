using System.ComponentModel;
using Microsoft.SemanticKernel;
using Microsoft.SemanticKernel.AI.ChatCompletion;

namespace Plugins;

/// <summary>
/// A Sematic Kernel skill that interacts with ChatGPT
/// </summary>
internal class WeatherPlugin
{
    //private readonly HttpClient _httpClient;
    const string _weatherApiUrl = "https://localhost:7060/weatherforecast";

    //public WeatherPlugin(HttpClient client)
    //{
    //    _httpClient = client;
    //}

    [KernelFunction("GetWeatherForecast")]
    [Description("Gets the weather forecast for tomorrow")]
    public async Task<string> GetWeatherForecast() 
    {
        HttpClient client = new();

        var request = new HttpRequestMessage(HttpMethod.Get, _weatherApiUrl);
        var response = await client.SendAsync(request);
        response.EnsureSuccessStatusCode();
        var result = await response.Content.ReadAsStringAsync();
        return result;
    }
}

record WeatherForecast(DateOnly Date, int TemperatureC, string? Summary)
{
    public int TemperatureF => 32 + (int)(TemperatureC / 0.5556);
}
