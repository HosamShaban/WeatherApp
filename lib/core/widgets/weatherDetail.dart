import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitone/core/resources/manager_styles.dart';

import '../provider/weather_provider.dart';

class WeatherDetail extends StatelessWidget {
  Widget _gridWeatherBuilder(String header, String body, String icon) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(15),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              icon,
              style: getMediumTextStyle(
                color: Colors.blue,
                fontSize: 30,
              ),
            ),
            const SizedBox(width: 15.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  child: Text(
                    header,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
                FittedBox(
                  child: Text(
                    body,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 15),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(builder: (context, weatherProv, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'Today Details',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            child: GridView(
              padding: const EdgeInsets.all(15),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250,
                childAspectRatio: 2 / 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              children: [
                _gridWeatherBuilder(
                    '${weatherProv.weather!.humidity}%', 'Humidity', '💧'),
                _gridWeatherBuilder(
                    '${weatherProv.weather!.windSpeed} km/h', 'Wind', '💨'),
                _gridWeatherBuilder(
                    '${weatherProv.weather!.feelsLike.toStringAsFixed(1)}°C',
                    'Feels Like',
                    '🌡️'),
                _gridWeatherBuilder(
                    '${weatherProv.weather!.pressure} hPa', 'Pressure', '⭕️'),
              ],
            ),
          ),
        ],
      );
    });
  }
}
