import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app/secreat.dart';
import 'package:weather_app/widgets/additional_information_item.dart';
import 'package:weather_app/widgets/hourly_forcast_itme.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double temp = 0;

  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future getCurrentWeather() async {
    try {
      String cityName = 'Kolkata';
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=${cityName}&appid=${openWeatherApi}'),
      );
      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An unexpected error occurred';
      }

      setState(() {
        temp = data['list'][0]['main']['temp'];
      });
    } catch (e) {
      throw e.toString();
    }
    // print(res.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // print('Azmattullah');
              // getCurrentWeather();
              // setState(() {});
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: temp == 0
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(children: [
                // main card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 12,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10,
                          sigmaY: 10,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '$temp K',
                                style: TextStyle(
                                    fontSize: 35, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 14),
                              Icon(
                                Icons.cloud,
                                size: 65,
                              ),
                              SizedBox(height: 14),
                              Text(
                                'Rain',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                // weather forecast cards
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Weather Forecast',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      HourlyForecastItem(
                        time: '12:05',
                        icon: Icons.cloud,
                        temperature: '301.22',
                      ),
                      HourlyForecastItem(
                        time: '12:05',
                        icon: Icons.cloud,
                        temperature: '301.22',
                      ),
                      HourlyForecastItem(
                        time: '12:05',
                        icon: Icons.cloud,
                        temperature: '301.22',
                      ),
                      HourlyForecastItem(
                        time: '12:05',
                        icon: Icons.cloud,
                        temperature: '301.22',
                      ),
                      HourlyForecastItem(
                        time: '12:05',
                        icon: Icons.cloud,
                        temperature: '301.22',
                      ),
                    ],
                  ),
                ),
                // additional information
                SizedBox(height: 12),
                // weather forecast cards
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Additional Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfomationItem(
                        icon: Icons.water_drop, label: 'Humadity', value: '95'),
                    AdditionalInfomationItem(
                        icon: Icons.air, label: 'Wind Speed', value: '7.89'),
                    AdditionalInfomationItem(
                        icon: Icons.beach_access,
                        label: 'Pressure',
                        value: '1006'),
                  ],
                ),
              ]),
            ),
    );
  }
}
