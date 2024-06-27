class MeteoData {
  final String name;
  final String country;
  final double temperature;
  final double latitude;
  final double longitude;

  MeteoData({
    required this.name,
    required this.country,
    required this.temperature,
    required this.latitude,
    required this.longitude,
  });

  factory MeteoData.fromJson(Map<String, dynamic> json) {
    return MeteoData(
      name: json['name'],
      country: json['sys']['country'],
      temperature: json['main']['temp'],
      latitude: json['coord']['lat'],
      longitude: json['coord']['lon'],
    );
  }
}
