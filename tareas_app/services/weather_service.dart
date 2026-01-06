import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  // Ahora devolvemos un MAPA con muchos datos, no solo la temperatura
  static Future<Map<String, dynamic>> getWeather(String city) async {
    try {
      // 1. GEOCODIFICACIÓN (Buscar latitud/longitud de la ciudad)
      final geoUrl = Uri.parse(
          'https://geocoding-api.open-meteo.com/v1/search?name=$city&count=1&language=es&format=json');

      final geoResponse = await http.get(geoUrl);
      if (geoResponse.statusCode != 200) return {};

      final geoData = jsonDecode(geoResponse.body);
      if (!geoData.containsKey('results') || geoData['results'].isEmpty) return {};

      final lat = geoData['results'][0]['latitude'];
      final lon = geoData['results'][0]['longitude'];
      final cityName = geoData['results'][0]['name']; // Nombre oficial

      // 2. CLIMA DETALLADO (Pedimos sensación, humedad, viento y min/max)
      final weatherUrl = Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,relative_humidity_2m,apparent_temperature,wind_speed_10m,weather_code&daily=temperature_2m_max,temperature_2m_min&timezone=auto');

      final weatherResponse = await http.get(weatherUrl);

      if (weatherResponse.statusCode == 200) {
        final data = jsonDecode(weatherResponse.body);
        final current = data['current'];
        final daily = data['daily'];

        return {
          'temp': "${current['temperature_2m']}°C",
          'feels_like': "${current['apparent_temperature']}°C", // Sensación térmica
          'humidity': "${current['relative_humidity_2m']}%",    // Humedad
          'wind': "${current['wind_speed_10m']} km/h",          // Viento
          'max': "${daily['temperature_2m_max'][0]}°C",         // Máxima hoy
          'min': "${daily['temperature_2m_min'][0]}°C",         // Mínima hoy
          'city': cityName,
          'valid': true,
        };
      } else {
        return {'valid': false};
      }
    } catch (e) {
      print("Error clima: $e");
      return {'valid': false};
    }
  }
}
