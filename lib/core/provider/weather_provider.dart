import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:unitone/core/models/daily_weather.dart';
import 'package:unitone/core/models/weather.dart';
import 'package:unitone/core/models/weather_data.dart';
import 'package:unitone/core/resources/manager_strings.dart';

class WeatherProvider with ChangeNotifier {
  String apiKey = "347e6ae23e75ba25ea60276f7289c226";
  LatLng currentLocation = LatLng(31.515678, 34.428138);
  Weather? weather;
  DailyWeather currentWeather = DailyWeather();
  List<DailyWeather> hourlyWeather = [];
  List<DailyWeather> hourly24Weather = [];
  List<DailyWeather> fiveDayWeather = [];
  List<DailyWeather> sevenDayWeather = [];
  bool isLoading = false;
  bool isRequestError = false;
  bool isLocationError = false;
  bool serviceEnabled = false;
  LocationPermission? permission;

  Future<Position>? requestLocation(BuildContext context) async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(ManagerStrings.locationService),
      ));
      return Future.error(ManagerStrings.locationAreService);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(ManagerStrings.permissionDenied),
        ));
        return Future.error(ManagerStrings.permissionAreDenied);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(ManagerStrings.permissionArePermanentlyDenied),
      ));
      return Future.error(
        ManagerStrings.errorLocationPermissions,
      );
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> getWeatherData(
    BuildContext context, {
    bool isRefresh = false,
  }) async {
    isLoading = true;
    isRequestError = false;
    isLocationError = false;
    if (isRefresh) notifyListeners();

    Position? locData = await requestLocation(context);
    if (locData == null) {
      isLocationError = true;
      notifyListeners();
      return;
    }

    try {
      currentLocation = LatLng(locData.latitude, locData.longitude);
      await getCurrentWeather(currentLocation);
    } catch (e) {
      print(e);
      isLocationError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getCurrentWeather(LatLng location) async {
    Uri url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=${location.latitude}&lon=${location.longitude}&units=metric&appid=$apiKey',
    );
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      weather = Weather.fromJson(extractedData);
    } catch (error) {
      isLoading = false;
      isRequestError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getDailyWeather(LatLng location) async {
    isLoading = true;
    notifyListeners();
    Uri dailyUrl = Uri.parse(
      'https://api.openweathermap.org/data/2.5/onecall?lat=${location.latitude}&lon=${location.longitude}&units=metric&exclude=minutely,current&appid=$apiKey',
    );
    try {
      final response = await http.get(dailyUrl);
      inspect(response.body);
      print(response.body);
      final dailyData = json.decode(response.body) as Map<String, dynamic>;
      print(dailyData);
      currentWeather = DailyWeather.fromJson(dailyData);
      List items = dailyData['daily'];
      List itemsHourly = dailyData['hourly'];
      hourlyWeather = itemsHourly
          .map((item) => DailyWeather.fromHourlyJson(item))
          .toList()
          .skip(1)
          .take(3)
          .toList();
      hourly24Weather = itemsHourly
          .map((item) => DailyWeather.fromHourlyJson(item))
          .toList()
          .skip(1)
          .take(24)
          .toList();
      sevenDayWeather = items
          .map((item) => DailyWeather.fromDailyJson(item))
          .toList()
          .skip(1)
          .take(6)
          .toList();
    } catch (error) {
      print(error);
      isRequestError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchWeatherWithLocation(String location) async {
    Uri url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$location&units=metric&appid=$apiKey',
    );
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      weather = Weather.fromJson(extractedData);
    } catch (error) {
      print(error);
      isRequestError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchWeather(String location) async {
    isLoading = true;
    notifyListeners();
    isRequestError = false;
    isLocationError = false;
    await searchWeatherWithLocation(location);
    if (weather == null) {
      isRequestError = true;
      notifyListeners();
      return;
    }
    await _fetchWeatherData();
  }

  Future<List<WeatherData>> _fetchWeatherData() async {
    const apiUrl =
        'https://api.weatherapi.com/v1/forecast.json?key=347e6ae23e75ba25ea60276f7289c226&q=Gaza&days=5';
    final response = await http.get(Uri.parse(apiUrl));
    print(response);
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final List<dynamic> dailyData = jsonBody['forecast']['forecastday'];

      return dailyData
          .map((data) => WeatherData.fromJson(data['date'], data['day']))
          .toList();
    } else {
      throw Exception(ManagerStrings.failedFetching);
    }
  }
}
