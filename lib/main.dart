import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitone/core/provider/weather_provider.dart';
import 'package:unitone/core/resources/manager_colors.dart';
import 'package:unitone/core/resources/manager_strings.dart';
import 'package:unitone/feathers/home/presentation/view/home_view.dart';
import 'package:unitone/feathers/weekly/presentation/view/weekly_weather_view.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WeatherProvider(),
      child: MaterialApp(
        title: ManagerStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(
              color: ManagerColors.blue,
            ),
            elevation: 0,
          ),
          scaffoldBackgroundColor: ManagerColors.white,
          primaryColor: ManagerColors.blue,
        ),
        home: HomeView(),
        routes: {
          WeeklyView.routeName: (myCtx) => WeeklyView(),
        },
      ),
    );
  }
}
