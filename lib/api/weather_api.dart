import 'package:flutter_weather_app/Model/weather.dart';
import 'package:flutter_weather_app/api/api_service.dart';
import 'package:flutter_weather_app/api_key.dart';
import 'package:intl/intl.dart';

/// WeatherApi class handles fetching current weather and forecast data
class WeatherApi extends ApiService {
  /// Base API URL for weather data
  @override
  String get apiUrl => 'data/2.5/';

  /// Path for current weather endpoint
  final String _weatherPath = 'weather';

  /// Path for forecast weather endpoint
  final String _forecastWeatherPath = 'forecast';

  /// Constructs query string with city name, metric units, and API key
  String queryWithCityName(String city) =>
      '?q=$city&units=metric&appid=$getApiKey';

  /// Fetches current weather for a given city
  Future<Weather>? fetchCurrentWeather(String city) async {
    // Fetches weather data from API
    Map<String, dynamic> weatherMap = await fetch(
      '$_weatherPath${queryWithCityName(city)}',
    );
    // Parses and returns Weather object
    return Weather.fromMap(weatherMap);
  }

  /// Fetches 5-day weather forecast for a given city
  Future<List<Weather>>? fetchWeatherForecast(String city) async {
    // Fetches forecast data from API
    Map weatherMap = await fetch(
      '$_forecastWeatherPath${queryWithCityName(city)}',
    );
    // Extracts list of forecast entries
    List weatherList = weatherMap['list'];
    // Map to store one forecast per day
    final Map<String, Weather> dailyMap = {};
    List<Weather> dailyForecast = [];

    // Iterates over forecast entries
    for (var item in weatherList) {
      final weather = Weather.fromForecast(item);
      // Formats date to 'yyyy-MM-dd'
      final day = DateFormat('yyyy-MM-dd').format(weather.date);

      // Adds only the first forecast for each day
      if (!dailyMap.containsKey(day)) {
        dailyMap[day] = weather;
      }
    }

    // Converts map values to list and sorts by date
    dailyForecast =
        dailyMap.values.toList()..sort((a, b) => a.date.compareTo(b.date));

    // Limits forecast to 5 days
    if (dailyForecast.length > 5) {
      dailyForecast = dailyForecast.sublist(0, 5);
    }
    return dailyForecast;
  }
}
