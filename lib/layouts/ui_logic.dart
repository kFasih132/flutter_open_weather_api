import 'package:flutter/material.dart';

String getWeatherIcon(String iconCode) {
  switch (iconCode) {
    case '01d':
      return '☀️';
    case '01n':
      return '🌙';
    case '02d':
    case '02n':
      return '⛅';
    case '03d':
    case '03n':
    case '04d':
    case '04n':
      return '☁️';
    case '09d':
    case '09n':
      return '🌧️';
    case '10d':
    case '10n':
      return '🌦️';
    case '11d':
    case '11n':
      return '⛈️';
    case '13d':
    case '13n':
      return '❄️';
    case '50d':
    case '50n':
      return '🌫️';
    default:
      return '🌈';
  }
}

LinearGradient getWeatherGradient(String iconCode) {
  if (iconCode.startsWith('01')) { // Clear Sky
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF6DD5ED), Color(0xFF2193B0)], // Vibrant blues
    );
  } else if (iconCode.startsWith('02')) { // Few Clouds
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFBBD2C5), Color(0xFF536976)], // Light grey to deeper grey-blue
    );
  } else if (iconCode.startsWith('03') || iconCode.startsWith('04')) { // Scattered/Overcast Clouds
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF9796F0), Color(0xFFFBC7D4)], // Soft purples to pinks/greys
    );
  } else if (iconCode.startsWith('09') || iconCode.startsWith('10')) { // Drizzle/Rain
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF64B3F4), Color(0xFFC2E59C)], // Muted blues to soft greens (evokes wetness)
    );
  } else if (iconCode.startsWith('11')) { // Thunderstorm
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF434343), Color(0xFF000000)], // Dark grays to black (ominous)
    );
  } else if (iconCode.startsWith('13')) { // Snow
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFE0F7FA), Color(0xFFB0BEC5)], // Very light blue to light grey
    );
  } else if (iconCode.startsWith('50')) { // Mist
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFECE9E6), Color(0xFFFFFFFF)], // Very light greys to white (hazy)
    );
  } else { // Default (e.g., for '🌈')
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFFFA726), Color(0xFFFB8C00)], // Warmer orange tones for the default
    );
  }
}



