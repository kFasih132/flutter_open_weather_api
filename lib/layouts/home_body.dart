import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_weather_app/Model/weather.dart';
import 'package:flutter_weather_app/api/weather_api.dart';
import 'package:flutter_weather_app/layouts/ui_logic.dart';
import 'package:intl/intl.dart';

/// Main widget for the home body displaying weather info.
class HomeBody extends StatefulWidget {
  const HomeBody({
    super.key,
    required this.currentWeather,
    required this.country,
    // required this.dailyForecast,
  });
  final Weather currentWeather;
  // final List<Weather> dailyForecast;
  final String country;

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size
    var size = MediaQuery.sizeOf(context);
    var Size(:height, :width) = size;
    var sizeContext = min(height, width);

    // Main scrollable content
    return SizedBox.expand(
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        slivers: [
          // Current weather update section
          SliverToBoxAdapter(
            child: CurrentUpdate(
              size: sizeContext,
              currentWeather: widget.currentWeather,
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: sizeContext * 0.06)),

          // Daily forecast section
          SliverToBoxAdapter(child: DaysForecast(country: widget.country)),
          SliverToBoxAdapter(child: SizedBox(height: sizeContext * 0.06)),

          // Weather details grid (wind, visibility, humidity)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid.extent(
              maxCrossAxisExtent: 240,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                WindWidget(
                  windSpeed: widget.currentWeather.windSpeed.toString(),
                  upperColor: Color(0xff212636),
                  lowerColor: Color(0xff0e0e12),
                ),
                VisibilityWidget(
                  visibility: '${widget.currentWeather.visibility! / 1000}',
                  upperColor: Color(0xff212636),
                  lowerColor: Color(0xff0e0e12),
                ),
                HumidityWidget(
                  humidity: widget.currentWeather.humidity.toString(),
                  upperColor: Color(0xff212636),
                  lowerColor: Color(0xff0e0e12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget to display the current weather update.
class CurrentUpdate extends StatelessWidget {
  const CurrentUpdate({
    super.key,
    required this.size,
    required this.currentWeather,
  });
  final double size;
  final Weather currentWeather;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 100),
        // Weather description
        Center(
          child: Text(
            currentWeather.description,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: size * 0.02),
        // Temperature and icon row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              currentWeather.temperature.round().toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Colors.white,
                fontSize: size * 0.25,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 16),
            Text(
              getWeatherIcon(currentWeather.iconCode),
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: size * 0.12,
              ),
            ),
            SizedBox(width: 22),
          ],
        ),
        // Feels like temperature
        Center(
          child: Text(
            'Feels like ${currentWeather.feelsLike.round()}°',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: size * 0.055,
            ),
          ),
        ),
        SizedBox(height: 6),
        // High and low temperatures
        Center(
          child: Text(
            'High ${currentWeather.tempMax.round()}° . Low ${currentWeather.tempMin.round()}°',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: size * 0.033,
            ),
          ),
        ),
      ],
    );
  }
}

/// Widget to display the daily weather forecast.
class DaysForecast extends StatefulWidget {
  const DaysForecast({super.key, required this.country});
  final String country;

  @override
  State<StatefulWidget> createState() => _DaysForecastState();
}

class _DaysForecastState extends State<DaysForecast> {
  Future<List<Weather>>? _future;
  final WeatherApi _weatherApi = WeatherApi();

  @override
  void initState() {
    super.initState();
    // Fetch forecast data on init
    _future = _weatherApi.fetchWeatherForecast(widget.country);
    setState(() {});
  }

  /// Refreshes the forecast data.
  void onTap() async {
    _future = _weatherApi.fetchWeatherForecast(widget.country);
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant DaysForecast oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Refetch if country changes
    oldWidget.country != widget.country ? onTap() : null;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: width,
        height: 160,
        child: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show loading indicator
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              // Show forecast list
              List<Weather> dailyForecast = snapshot.data!;
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemExtent: 80,
                itemCount: dailyForecast.length,
                itemBuilder: (context, index) {
                  final forecast = dailyForecast[index];
                  return Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Day of the week
                        Text(
                          DateFormat('E').format(forecast.date),
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        // Weather icon
                        Text(
                          getWeatherIcon(forecast.iconCode),
                          style: const TextStyle(fontSize: 30),
                        ),
                        const SizedBox(height: 8),
                        // Temperature
                        Text(
                          '${forecast.temperature.round()}°',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              // Show error and reload button
              return Center(
                child: TextButton(
                  onPressed: onTap,
                  child: Text(snapshot.error.toString()),
                ),
              );
            } else {
              // Show reload button
              return Center(
                child: TextButton(onPressed: onTap, child: Text('load again')),
              );
            }
          },
        ),
      ),
    );
  }
}

/// Widget to display an icon and text in a row.
class IconText extends StatelessWidget {
  const IconText({super.key, required this.iconData, required this.text});
  final IconData iconData;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(iconData, color: Colors.white),
        SizedBox(width: 6),
        Text(text, style: TextStyle(color: Colors.white, fontSize: 16)),
      ],
    );
  }
}

/// Widget to display wind speed in a styled container.
class WindWidget extends StatelessWidget {
  const WindWidget({
    super.key,
    required this.windSpeed,
    required this.upperColor,
    required this.lowerColor,
  });
  final String windSpeed;
  final Color upperColor;
  final Color lowerColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(shape: BoxShape.circle, color: lowerColor),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: ShapeDecoration(
            color: upperColor,
            shape: StarBorder(points: 3, pointRounding: 0.7, rotation: 70),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16),
              IconText(iconData: Icons.air_outlined, text: 'Wind'),
              SizedBox(height: 16),
              Text(
                '$windSpeed km/h',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget to display visibility in a styled container.
class VisibilityWidget extends StatelessWidget {
  const VisibilityWidget({
    super.key,
    required this.visibility,
    required this.upperColor,
    required this.lowerColor,
  });
  final String visibility;
  final Color upperColor;
  final Color lowerColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(shape: BoxShape.circle, color: lowerColor),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: ShapeDecoration(
            color: upperColor,
            shape: StarBorder(
              points: 12.8,
              pointRounding: 0.63,
              rotation: 70,
              innerRadiusRatio: 0.82,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16),
              IconText(iconData: Icons.visibility_outlined, text: 'visibility'),
              SizedBox(height: 16),
              Text(
                '$visibility km',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget to display humidity in a styled container.
class HumidityWidget extends StatelessWidget {
  const HumidityWidget({
    super.key,
    required this.humidity,
    required this.upperColor,
    required this.lowerColor,
  });
  final String humidity;
  final Color upperColor;
  final Color lowerColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: lowerColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: ShapeDecoration(
            color: upperColor,
            shape: StarBorder.polygon(
              sides: 7.00,
              rotation: 243.16,
              pointRounding: 0.38,
              squash: 0.48,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16),
              IconText(iconData: Icons.foggy, text: 'humidity'),
              SizedBox(height: 16),
              Text(
                '$humidity %',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
