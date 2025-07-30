import 'dart:convert';
import 'package:http/http.dart' as http;

class AdafruitService {
  static const String _aioKey = 'aio_ZVEZ92JRlt2xseOFqE4UHGHhVOtb';
  static const String _username = 'vincentnguyen';
  static const String _baseUrl = 'https://io.adafruit.com/api/v2';

  // Gửi request đến API Adafruit
  Future<http.Response> _sendRequest(String feedKey, {int limit = 1}) async {
    final url = Uri.parse(
      '$_baseUrl/$_username/feeds/$feedKey/data?limit=$limit',
    );
    try {
      final response = await http.get(url, headers: {'X-AIO-Key': _aioKey});
      return response;
    } catch (e) {
      throw Exception('Lỗi kết nối đến Adafruit: $e');
    }
  }

  // Lấy giá trị mới nhất từ 1 feed
  Future<double?> fetchLatestValue(String feedKey) async {
    try {
      final response = await _sendRequest(feedKey, limit: 1);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.isNotEmpty && data[0]['value'] != null) {
          return double.tryParse(data[0]['value'].toString());
        } else {
          throw Exception('Không có dữ liệu hợp lệ từ feed: $feedKey');
        }
      } else {
        throw Exception('Lỗi HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Lỗi fetchLatestValue: $e');
      return null;
    }
  }

  // Lấy danh sách dữ liệu lịch sử
  Future<List<double>> fetchHistory(String feedKey, {int limit = 20}) async {
    try {
      final response = await _sendRequest(feedKey, limit: limit);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((e) => double.tryParse(e['value'].toString()))
            .where((v) => v != null)
            .cast<double>()
            .toList();
      } else {
        throw Exception('Lỗi HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Lỗi fetchHistory: $e');
      return [];
    }
  }

  // Lấy đầy đủ dữ liệu từ các feed môi trường
  Future<Map<String, List<double>>> fetchEnvironmentHistory({
    int limit = 20,
  }) async {
    final temperature = await fetchHistory('v1', limit: limit);
    final humidity = await fetchHistory('v2', limit: limit);
    final co2 = await fetchHistory('v3', limit: limit);

    return {'temperature': temperature, 'humidity': humidity, 'co2': co2};
  }
}
