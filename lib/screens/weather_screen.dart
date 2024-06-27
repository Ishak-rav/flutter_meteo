import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meteo/screens/map_screen.dart';
import 'package:meteo/services/city_service.dart';
import 'package:meteo/services/meteo_service.dart';
import 'package:meteo/models/meteodata.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  WeatherScreenState createState() => WeatherScreenState();
}

class WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  Future<MeteoData>? _weatherData;

  void _searchWeather() {
    final String cityName = _cityController.text;
    if (cityName.isNotEmpty) {
      setState(() {
        _weatherData =
            CityService.getCityCoordinates(cityName).then((cityData) {
          return MeteoService.getWeatherData(
              cityData['latitude'], cityData['longitude']);
        });
      });
    }
  }

  void _getCurrentLocationWeather() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _weatherData =
          MeteoService.getWeatherData(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Météo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Entrez le nom de la ville',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchWeather,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _getCurrentLocationWeather,
              child: const Text('Utiliser la position actuelle'),
            ),
            const SizedBox(height: 20),
            _weatherData != null
                ? FutureBuilder<MeteoData>(
                    future: _weatherData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Erreur: ${snapshot.error}');
                      } else if (!snapshot.hasData) {
                        return const Text('Aucune donnée');
                      } else {
                        final data = snapshot.data!;
                        return Column(
                          children: [
                            Text('Ville: ${data.name}'),
                            Text('Pays: ${data.country}'),
                            Text('Température: ${data.temperature}°C'),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MapScreen(
                                      latitude: data.latitude,
                                      longitude: data.longitude,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Voir sur la carte'),
                            ),
                          ],
                        );
                      }
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
