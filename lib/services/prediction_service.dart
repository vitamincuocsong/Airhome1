import 'dart:convert';
import 'package:http/http.dart' as http;

class PredictionService {
  final String apiUrl = "https://your-server.com/predict";

  Future<Map<String, double>> getForecast(
    double temp,
    double hum,
    double co2,
  ) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"temp": temp, "hum": hum, "co2": co2}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {"temp_next": data["temp_next"], "hum_next": data["hum_next"]};
    } else {
      throw Exception("Không thể lấy dữ báo từ API");
    }
  }
}
