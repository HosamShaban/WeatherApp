// import 'package:flutter_weather_icons/flutter_weather_icons.dart';

class WeatherData {
  final String date;
  final double maxTemp;
  final double minTemp;
  // final IconData weatherIcon;
  final String condition;

  WeatherData({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    // required this.weatherIcon,
    required this.condition,
  });

  factory WeatherData.fromJson(String date, Map<String, dynamic> json) {
    return WeatherData(
      date: date,
      maxTemp: json['maxtemp_c'] as double,
      minTemp: json['mintemp_c'] as double,
      condition: json['condition']['text'] as String,
    );
  }
}
