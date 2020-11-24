using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using FrontEndWeb.Models;
using Microsoft.Extensions.Configuration;
using System.Net.Http;
using System.Text.Json.Serialization;
using Newtonsoft.Json;

namespace FrontEndWeb.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly HttpClient _http;
        private readonly IConfiguration _configuration;

        public HomeController(ILogger<HomeController> logger,IConfiguration configuration,IHttpClientFactory factory)
        {
            _logger = logger;
            _http = factory.CreateClient();
            _configuration = configuration;
        }

        public async Task<IActionResult> Index()
        {
            string uri = _configuration["API"];

            var response = await _http.GetAsync(uri);
            IEnumerable<WeatherForecast> weathers = null;

            if (response.IsSuccessStatusCode) 
            {
                var serializedObject = await response.Content.ReadAsStringAsync();
                weathers = JsonConvert.DeserializeObject<IEnumerable<WeatherForecast>>(serializedObject);
                
            }

            return View(weathers);
        }


        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
