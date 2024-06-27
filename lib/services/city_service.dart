import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CityService {
  static Future<Map<String, dynamic>> getCityCoordinates(
      String cityName) async {
    final apiKey = dotenv.env['CITY_API_KEY'];
    final response = await Dio().get(
      'https://api.api-ninjas.com/v1/city',
      queryParameters: {'name': cityName},
      options: Options(headers: {'X-Api-Key': apiKey}),
    );
    return response.data[0];
  }
}
