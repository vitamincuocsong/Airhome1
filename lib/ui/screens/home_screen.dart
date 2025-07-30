import 'package:flutter/material.dart';
import '../../services/adafruit_service.dart';
import '../widgets/current_data_card.dart';
import '../widgets/forecast_section.dart';
import '../widgets/health_warning_banner.dart';
import '../widgets/history_chart.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AdafruitService adafruitService = AdafruitService();

  double temperature = 0;
  double humidity = 0;
  double co2 = 0;

  List<double> tempHistory = [];
  List<double> humHistory = [];
  List<double> co2History = [];

  bool isLoading = true;

  Timer? periodicTimer;

  @override
  void initState() {
    super.initState();
    loadData(); // Gọi lần đầu
    // Lập lịch tự động mỗi 15 phút
    periodicTimer = Timer.periodic(Duration(minutes: 15), (timer) {
      print("🔄 Cập nhật dữ liệu từ Adafruit lúc ${DateTime.now()}");
      loadData();
    });
  }

  @override
  void dispose() {
    periodicTimer?.cancel();
    super.dispose();
  }

  Future<void> loadData() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Lấy giá trị hiện tại
      final temp = await adafruitService.fetchLatestValue('v1');
      final hum = await adafruitService.fetchLatestValue('v2');
      final co2Val = await adafruitService.fetchLatestValue('v3');

      // Lấy lịch sử
      final history = await adafruitService.fetchEnvironmentHistory(limit: 20);

      setState(() {
        temperature = temp ?? 0;
        humidity = hum ?? 0;
        co2 = co2Val ?? 0;
        tempHistory = history['temperature'] ?? [];
        humHistory = history['humidity'] ?? [];
        co2History = history['co2'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      print("❌ Lỗi khi tải dữ liệu: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 60),
            SizedBox(width: 8), // khoảng cách giữa logo và text
            Text(
              'AirHome',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 254, 255, 255),
              ),
            ),
          ],
        ),

        backgroundColor: const Color.fromARGB(255, 1, 89, 123),
        elevation: 2,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadData,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CurrentDataCard(
                      temperature: temperature,
                      humidity: humidity,
                      co2: co2,
                    ),
                    SizedBox(height: 12),
                    ForecastSection(
                      tempNext: 0, // chưa gọi dự báo, nếu cần sẽ tích hợp sau
                      humidityNext: 0,
                    ),
                    SizedBox(height: 12),
                    HealthWarningBanner(
                      temperature: temperature,
                      humidity: humidity,
                      co2: co2,
                    ),
                    SizedBox(height: 24),
                    Text(
                      "📊 Biểu đồ lịch sử (20 lần gần nhất)",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    HistoryChart(
                      data: tempHistory,
                      label: "Nhiệt độ (°C)",
                      lineColor: Colors.red,
                    ),
                    SizedBox(height: 12),
                    HistoryChart(
                      data: humHistory,
                      label: "Độ ẩm (%)",
                      lineColor: Colors.blue,
                    ),
                    SizedBox(height: 12),
                    HistoryChart(
                      data: co2History,
                      label: "CO₂ (ppm)",
                      lineColor: Colors.green,
                    ),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }
}
