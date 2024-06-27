import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/meteodata.dart';

class MeteoService {
  static Future<MeteoData> getWeatherData(double lat, double lon) async {
    final apiKey = dotenv.env['METEO_API_KEY'];
    final response = await Dio().get(
      'https://api.openweathermap.org/data/2.5/weather',
      queryParameters: {
        'lat': lat,
        'lon': lon,
        'appid': apiKey,
        'units': 'metric'
      },
    );
    return MeteoData.fromJson(response.data);
  }
}
