import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'Kolkata';
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=${cityName}&appid=${openWeatherApi}'),
      );
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw 'An unexpected Error Occurred';
        // throw data['message'];
      }
      // data['list'][0]['main']['temp'];
      return data;
    } catch (e) {
      throw e.toString();
    }
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
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: const CircularProgressIndicator.adaptive(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          final data = snapshot.data!;

          final currentWeatherData = data['list'][0];

          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];
          final currentHumidity = currentWeatherData['main']['humidity'];

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
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
                                // '${currentTemp - 273.15.toStringAsFixed(2)}',
                                '$currentTemp K',
                                style: TextStyle(
                                    fontSize: 35, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 14),
                              Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 65,
                              ),
                              SizedBox(height: 14),
                              Text(
                                currentSky,
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
                    'Hourly Forecast',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       for (int i = 0; i < 39; i++)
                //         HourlyForecastItem(
                //           time: data['list'][i + 1]['dt'].toString(),
                //           icon: data['list'][i + 1]['weather'][0]['main'] ==
                //                       'Clouds' ||
                //                   data['list'][i + 1]['weather'][0]['main'] ==
                //                       'Rain'
                //               ? Icons.cloud
                //               : Icons.sunny,
                //           temperature:
                //               data['list'][i + 1]['main']['temp'].toString(),
                //         ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final hourlyForecast = data['list'][index + 1];
                      final hourlySky = hourlyForecast['weather'][0]['main'];
                      final time = DateTime.parse(hourlyForecast['dt_txt']);
                      return HourlyForecastItem(
                          time: DateFormat.j().format(time),
                          temperature: hourlyForecast['main']['temp'].toString(),
                          icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                              ? Icons.cloud
                              : Icons.sunny,
                              );
                    },
                  ),
                ),
                SizedBox(height: 12),
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
                      icon: Icons.water_drop,
                      label: 'Humadity',
                      value: currentHumidity.toString(),
                    ),
                    AdditionalInfomationItem(
                        icon: Icons.air,
                        label: 'Wind Speed',
                        value: currentWindSpeed.toString()),
                    AdditionalInfomationItem(
                        icon: Icons.beach_access,
                        label: 'Pressure',
                        value: currentPressure.toString()),
                  ],
                ),
              ]),
            ),
          );
        },
      ),
    );
  }
}

// temperature: '${currentPressure}',
// temperature: currentPressure.toString(),