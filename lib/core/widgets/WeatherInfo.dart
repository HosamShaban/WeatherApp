import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitone/core/provider/weather_provider.dart';
import 'package:unitone/core/resources/manager_colors.dart';
import 'package:unitone/core/resources/manager_styles.dart';
import 'package:unitone/core/resources/manager_weather.dart';

class WeatherInfo extends StatelessWidget {
  Widget _weatherInfoBuilder({
    required String header,
    required String body,
    required String icon,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          icon,
          style: getRegularTextStyle(
            color: ManagerColors.blue,
            fontSize: 40,
          ),
        ),
        const SizedBox(width: 16.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              child: Text(
                header,
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
              ),
            ),
            FittedBox(
              child: Text(
                body,
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(builder: (context, weatherProv, _) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _weatherInfoBuilder(
                header: 'Precipitation',
                body: '${weatherProv.currentWeather.precip}%',
                icon: ' 🌧️',
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                height: 65.0,
                child: const VerticalDivider(
                  color: Colors.black,
                  indent: 10.0,
                  endIndent: 10.0,
                ),
              ),
              _weatherInfoBuilder(
                header: 'UV Index',
                body: UvIndex.mapUviValueToString(
                    uvi: weatherProv.currentWeather.uvi),
                icon: '☀️',
              ),
            ],
          ),
        ),
      );
    });
  }
}
