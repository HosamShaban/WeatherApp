import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:unitone/core/models/daily_weather.dart';
import 'package:unitone/core/provider/weather_provider.dart';
import 'package:unitone/core/resources/manager_weather.dart';

class SevenDayForecast extends StatelessWidget {
  Widget dailyWidget(DailyWeather weather) {
    final dayOfWeek = DateFormat('EEE').format(weather.date!);
    return Container(
      margin: const EdgeInsets.only(right: 8.0),
      child: Column(
        children: [
          FittedBox(
            child: Text(
              dayOfWeek,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MapString.mapStringToIcon('${weather.condition}', 35),
          ),
          Text('${weather.condition}'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 15.0, left: 20.0),
          child: Text(
            'Next 7 Days',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(16.0),
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            child:
                Consumer<WeatherProvider>(builder: (context, weatherProv, _) {
              return Column(
                children: [
                  Consumer<WeatherProvider>(
                    builder: (context, weatherProv, _) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Today',
                                  style: TextStyle(fontSize: 15),
                                ),
                                Text(
                                  '${weatherProv.weather!.temp.toStringAsFixed(1)}°',
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                MapString.mapInputToWeather(
                                  context,
                                  weatherProv.weather!.currently,
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: MapString.mapStringToIcon(
                                weatherProv.weather!.currently,
                                45,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8.0),
                  SizedBox(
                    height: 350.0,
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: weatherProv.sevenDayWeather.length,
                      itemBuilder: (context, index) {
                        DailyWeather weather =
                            weatherProv.sevenDayWeather[index];
                        return dailyWidget(weather);
                      },
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
