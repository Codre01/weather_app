import 'package:flutter/material.dart';
import 'package:flutter_weather_app/model/weather_model.dart';
import 'package:flutter_weather_app/service/weather_service.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService("3b866f050353fbd206720e5d39fe165b");
  Weather? _weather;
  String _selectedCity = 'Lagos';
  List<String> _selectedCities = ['Lagos'];
  List<Weather> _weatherList = [];

  _fetchWeather(String cityName) async {
    try {
      if (cityName == 'Current Location') {
        final city = await _weatherService.getCurrentCity();
        final weather = await _weatherService.getWeather(city);
        setState(() {
          _weather = weather;
        });
      } else {
        final weather = await _weatherService.getWeather(cityName);
        setState(() {
          _weather = weather;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case "mist":
      case "haze":
      case "smoke":
      case "dust":
      case "fog":
        return 'assets/cloud.json';
      case 'rain':
      case "drizzle":
      case 'shower':
        return 'assets/rain.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

   @override
  void initState() {
    super.initState();
    _loadSelectedCities();
  }

  _loadSelectedCities() async {
    final prefs = await SharedPreferences.getInstance();
    final cities = prefs.getStringList('selectedCities');
    if (cities != null) {
      setState(() {
        _selectedCities = cities;
      });
    }
    _fetchWeather(_selectedCity);
  }

  _saveSelectedCities() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('selectedCities', _selectedCities);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _selectedCities.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Weather App'),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: (String result) {
                setState(() {
                  if (!_selectedCities.contains(result) && _selectedCities.length < 3) {
                    _selectedCities.add(result);
                  }
                  _selectedCity = result;
                  _fetchWeather(_selectedCity);
                  _saveSelectedCities();
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'Current Location',
                  child: Text('Current Location'),
                ),
                const PopupMenuItem<String>(
                  value: 'Lagos',
                  child: Text('Lagos'),
                ),
                const PopupMenuItem<String>(
                  value: 'Abuja',
                  child: Text('Abuja'),
                ),
                const PopupMenuItem<String>(
                  value: 'Ibadan',
                  child: Text('Ibadan'),
                ),
                const PopupMenuItem<String>(
                  value: 'Awka',
                  child: Text('Awka'),
                ),
                const PopupMenuItem<String>(
                  value: 'Kano',
                  child: Text('Kano'),
                ),
                const PopupMenuItem<String>(
                  value: 'Ibadan',
                  child: Text('Ibadan'),
                ),
                const PopupMenuItem<String>(
                  value: 'Ibadan',
                  child: Text('Ibadan'),
                ),
                const PopupMenuItem<String>(
                  value: 'Port Harcourt',
                  child: Text('Port Harcourt'),
                ),
                const PopupMenuItem<String>(
                  value: 'Benin City',
                  child: Text('Benin City'),
                ),
                const PopupMenuItem<String>(
                  value: 'Minna',
                  child: Text('Minna'),
                ),
                const PopupMenuItem<String>(
                  value: 'Agege',
                  child: Text('Agege'),
                ),
                const PopupMenuItem<String>(
                  value: 'Surulere',
                  child: Text('Surelere'),
                ),
                const PopupMenuItem<String>(
                  value: 'Ikeja',
                  child: Text('Ikeja'),
                ),
                const PopupMenuItem<String>(
                  value: 'Onitsha',
                  child: Text('Onitsha'),
                ),
                const PopupMenuItem<String>(
                  value: 'Ikoyi',
                  child: Text('Ikoyi'),
                ),
                const PopupMenuItem<String>(
                  value: 'Suleja',
                  child: Text('Suleja'),
                ),
                const PopupMenuItem<String>(
                  value: 'Ogbomoso',
                  child: Text('Ogbomoso'),
                ),
                const PopupMenuItem<String>(
                  value: 'Oshodi',
                  child: Text('Oshodi'),
                ),
              ],
            ),
          ],
          bottom: TabBar(
            tabs: _selectedCities.map((city) {
              return Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(city),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          if (_selectedCities.length > 1) {
                            _selectedCities.remove(city);
                          }
                          _saveSelectedCities();
                        });
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
            onTap: (index) {
              setState(() {
                _selectedCity = _selectedCities[index];
                _fetchWeather(_selectedCity);
              });
            },
          ),
        ),
        backgroundColor: Color(0xFAFAFAFA),
        body: TabBarView(
          
          children: _selectedCities.map((city) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    _weather?.cityName ?? "loading city...",
                    style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Roboto"),
                  ),
                  Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
                  Column(
                    children: [
                      Text(
                        '${_weather?.temperature.round()}°C',
                        style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w400,
                            fontFamily: "BebasNeue"),
                      ),
                      Text(
                        _weather?.mainCondition ?? "...",
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}