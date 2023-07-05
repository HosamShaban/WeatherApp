import 'package:flutter/material.dart';
import 'package:unitone/core/resources/manager_colors.dart';
import 'package:unitone/core/resources/manager_fonts.dart';
import 'package:unitone/core/resources/manager_styles.dart';

class UvIndex {
  static String mapUviValueToString({required dynamic uvi}) {
    String uvIndex;
    if (uvi <= 2) {
      return uvIndex = 'Low';
    } else if (uvi <= 5) {
      return uvIndex = 'Medium';
    } else if (uvi <= 7) {
      return uvIndex = 'High';
    } else if (uvi <= 10) {
      return uvIndex = 'Very High';
    } else if (uvi >= 11) {
      return uvIndex = 'Extreme';
    } else {
      uvIndex = 'Unknown';
    }
    return uvIndex;
  }
}

class MapString {
  static Widget mapInputToWeather(BuildContext context, String input) {
    String text;
    switch (input) {
      case 'Thunderstorm':
        text = 'Thunderstorm';
        break;
      case 'Drizzle':
        text = 'Drizzly';
        break;
      case 'Rain':
        text = 'Raining';
        break;
      case 'Snow':
        text = 'Snowing';
        break;
      case 'fog':
        text = 'Foggy';
        break;
      case 'Clear':
        text = "Sunny";
        break;
      case 'Clouds':
        text = "Cloudy";
        break;
      default:
        text = "No Info";
    }
    return Text(
      text,
      style: getMediumTextStyle(
          fontSize: ManagerFontSize.s16, color: ManagerColors.textColor),
    );
  }

  static Text mapStringToIcon(String input, double iconSize) {
    String icon;
    switch (input) {
      case 'Thunderstorm':
        icon = '🌩';
        break;
      case 'Rain':
        icon = '🌧';
        break;
      case 'Drizzle':
        icon = '🌦️';
        break;
      case 'Snow':
        icon = '❄️ ⛄️️';
        break;
      case 'fog':
        icon = '🌫';
        break;
      case 'Clear':
        icon = '☀️';
        break;
      case 'Clouds':
        icon = '☁️';
        break;
      default:
        icon = '🤷‍';
    }
    return Text(icon,
        style:
            getMediumTextStyle(fontSize: iconSize, color: ManagerColors.blue));
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
