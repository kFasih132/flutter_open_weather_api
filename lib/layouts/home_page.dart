import 'package:flutter/material.dart';
import 'package:flutter_weather_app/Model/weather.dart';
import 'package:flutter_weather_app/api/weather_api.dart';
import 'package:flutter_weather_app/layouts/home_body.dart';
import 'package:flutter_weather_app/layouts/ui_logic.dart';

// List of Asian countries for the dropdown menu
const List<String> _asianCountries = [
  'Afghanistan',
  'Bahrain',
  'Bangladesh',
  'Bhutan',
  'Brunei',
  'Cambodia',
  'China',
  'Cyprus',
  'Georgia',
  'India',
  'Indonesia',
  'Iran',
  'Iraq',
  'Israel',
  'Japan',
  'Jordan',
  'Kazakhstan',
  'Kuwait',
  'Kyrgyzstan',
  'Laos',
  'Lebanon',
  'Malaysia',
  'Maldives',
  'Mongolia',
  'Myanmar (Burma)',
  'Nepal',
  'North Korea',
  'Oman',
  'Pakistan',
  'Palestine',
  'Philippines',
  'Qatar',
  'Russia',
  'Saudi Arabia',
  'Singapore',
  'South Korea',
  'Sri Lanka',
  'Syria',
  'Taiwan',
  'Tajikistan',
  'Thailand',
  'Timor-Leste',
  'Turkey',
  'Turkmenistan',
  'United Arab Emirates',
  'Uzbekistan',
  'Vietnam',
  'Yemen',
];

// Main home page widget
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Future to hold the weather data
  Future<Weather>? _weather;
  // Weather API instance
  final WeatherApi _weatherApi = WeatherApi();
  // Currently selected country
  String? _selectedCountry = 'Pakistan';

  // Map to store daily weather data (not used in current code)
  final Map<String, Weather> dailyMap = {};
  // Future for current and daily forecast (not used in current code)
  Future<(Weather currentWeather, List<Weather> dailyForecast)>? _future;

  // Called when the dropdown value changes
  onChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        _selectedCountry = newValue;
        _weather = _weatherApi.fetchCurrentWeather(_selectedCountry!);
      });
    }
  }

  // Called when reload button is pressed
  void onTap() async {
      _weather = _weatherApi.fetchCurrentWeather(_selectedCountry!) ;
      setState(() {});
  }

  // Initialize the weather data when the widget is first created
  @override
  void initState() {
    super.initState();
    _weather = _weatherApi.fetchCurrentWeather(_selectedCountry!) ;
  }
  
  // Build the UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Dropdown for selecting country
        title: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            focusColor: Colors.transparent,
            elevation: 0,
            dropdownColor: const Color.fromARGB(255, 255, 255, 255),
            value: _selectedCountry,
            hint: const Text('Select Country'),
            onChanged: onChanged,
            items:
                _asianCountries.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
          ),
        ),
      ),
      // Body displays weather info or error/loading states
      body: FutureBuilder(
        future: _weather,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // If weather data is available, show it
            Weather weather = snapshot.data!;
            return Center(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: getWeatherGradient(weather.iconCode),
                ),
                child: Center(
                  child: HomeBody(
                    currentWeather: weather,
                    country: _selectedCountry!,
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            // If there is an error, show a reload button with the error message
            return Center(
              child: TextButton(
                onPressed: onTap,
                child: Text(snapshot.error.toString()),
              ),
            );
          } else {
            // While loading, show a reload button
            return Center(
              child: TextButton(onPressed: onTap, child: Text('load again')),
            );
          }
        },
      ),
    );
  }
}

/* 
// Example code for displaying a list of weather data (commented out)
FutureBuilder(
  future: _weatherList,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      List<Weather> weather = snapshot.data!;
      return Center(child: Text(weather.toString()));
    } else if (snapshot.hasError) {
      return Center(
        child: TextButton(
          onPressed: onTap,
          child: Text(snapshot.error.toString()),
        ),
      );
    } else {
      return Center(
        child: TextButton(onPressed: onTap, child: Text('load again')),
      );
    }
  },
),
*/