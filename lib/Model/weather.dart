import 'dart:convert';



class Weather {
  final double temperature;
  final double tempMin;
  final double tempMax;
  final double feelsLike;
  final int? humidity;
  final double windSpeed;
  final int? visibility;
  final String description;
  final String iconCode;
  final DateTime date;

  Weather({
    required this.temperature,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.windSpeed,
    required this.visibility,
    required this.description,
    required this.iconCode,
    required this.date,required this.feelsLike
  });

  factory Weather.fromMap(Map<String, dynamic> json) {
    return Weather(
      temperature: json['main']['temp'].toDouble(),
      tempMin: json['main']['temp_min'].toDouble(),
      tempMax: json['main']['temp_max'].toDouble(),
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      visibility: json['visibility'],
      description: json['weather'][0]['description'],
      iconCode: json['weather'][0]['icon'],
      feelsLike: json['main']['feels_like'].toDouble(),
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
    );
  }

  factory Weather.fromForecast(Map<String, dynamic> map) {
    return Weather(
      temperature: map['main']['temp'].toDouble(),
      tempMin: map['main']['temp_min'].toDouble(),
      tempMax: map['main']['temp_max'].toDouble(),
      humidity: map['main']['humidity'],
      windSpeed: map['wind']['speed'].toDouble(),
      visibility: map['visibility'],
      description: map['weather'][0]['description'],
      iconCode: map['weather'][0]['icon'],
      feelsLike: map['main']['feels_like'].toDouble(),
      date: DateTime.fromMillisecondsSinceEpoch(map['dt'] * 1000),
    );
  }

  Weather copyWith({
    double? temperature,
    double? tempMin,
    double? tempMax,
    int? humidity,
    double? windSpeed,
    int? visibility,
    String? description,
    String? iconCode,
    DateTime? date,
  }) {
    return Weather(
      temperature: temperature ?? this.temperature,
      tempMin: tempMin ?? this.tempMin,
      tempMax: tempMax ?? this.tempMax,
      humidity: humidity ?? this.humidity,
      windSpeed: windSpeed ?? this.windSpeed,
      visibility: visibility ?? this.visibility,
      description: description ?? this.description,
      iconCode: iconCode ?? this.iconCode,
      date: date ?? this.date,feelsLike: feelsLike ?? this.feelsLike,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'temperature': temperature,
      'tempMin': tempMin,
      'tempMax': tempMax,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'visibility': visibility,
      'description': description,
      'iconCode': iconCode,
      'date': date.millisecondsSinceEpoch,
    };
  }

 
  String toJson() => json.encode(toMap());

 

  @override
  String toString() {
    return 'Weather(temperature: $temperature, tempMin: $tempMin, tempMax: $tempMax, humidity: $humidity, windSpeed: $windSpeed, visibility: $visibility, description: $description, iconCode: $iconCode, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Weather &&
      other.temperature == temperature &&
      other.tempMin == tempMin &&
      other.tempMax == tempMax &&
      other.humidity == humidity &&
      other.windSpeed == windSpeed &&
      other.visibility == visibility &&
      other.description == description &&
      other.iconCode == iconCode &&
      other.date == date;
  }

  @override
  int get hashCode {
    return temperature.hashCode ^
      tempMin.hashCode ^
      tempMax.hashCode ^
      humidity.hashCode ^
      windSpeed.hashCode ^
      visibility.hashCode ^
      description.hashCode ^
      iconCode.hashCode ^
      date.hashCode;
  }
}
