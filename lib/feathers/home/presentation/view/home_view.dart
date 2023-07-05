import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:unitone/core/provider/weather_provider.dart';
import 'package:unitone/core/widgets/fadeIn.dart';
import 'package:unitone/core/widgets/locationError.dart';
import 'package:unitone/core/widgets/mainWeather.dart';
import 'package:unitone/core/widgets/requestError.dart';
import 'package:unitone/core/widgets/searchBar.dart';
import 'package:unitone/core/widgets/weatherDetail.dart';

import 'widget/daily_wither.dart';

class HomeView extends StatefulWidget {
  static const routeName = '/homeScreen';

  const HomeView({Key? key}) : super(key: key);
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  Future<void> _getData() async {
    final weatherData = Provider.of<WeatherProvider>(context, listen: false);
    weatherData.getWeatherData(context);
  }

  @override
  Widget build(BuildContext context) {
    final themeContext = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Consumer<WeatherProvider>(
          builder: (context, weatherProv, _) {
            if (weatherProv.isRequestError) return RequestError();
            if (weatherProv.isLocationError) return LocationError();
            return Column(
              children: [
                SearchBar(),
                Center(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: 2,
                    effect: ExpandingDotsEffect(
                      activeDotColor: themeContext.primaryColor,
                      dotHeight: 10,
                      dotWidth: 10,
                    ),
                  ),
                ),
                Expanded(
                  child: PageView(
                    physics: const BouncingScrollPhysics(),
                    controller: _pageController,
                    children: [
                      ListView(
                        padding: const EdgeInsets.all(10),
                        children: [
                          FadeIn(
                            curve: Curves.easeIn,
                            duration: const Duration(milliseconds: 250),
                            child: MainWeather(),
                          ),
                          const DailyWeatherWidget(),
                        ],
                      ),
                      ListView(
                        padding: const EdgeInsets.all(10),
                        children: [
                          const SizedBox(height: 16.0),
                          FadeIn(
                            curve: Curves.easeIn,
                            duration: const Duration(milliseconds: 500),
                            child: WeatherDetail(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
