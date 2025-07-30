import 'package:flutter/material.dart';

class HealthWarningBanner extends StatelessWidget {
  final double temperature;
  final double humidity;
  final double co2;

  HealthWarningBanner({
    required this.temperature,
    required this.humidity,
    required this.co2,
  });

  String getWarning() {
    if (temperature > 35) return "⚠️ Nguy cơ say nắng!";
    if (humidity > 80) return "⚠️ Nguy cơ viêm da, nấm!";
    if (co2 > 1000) return "⚠️ Không khí ô nhiễm!";
    return "✅ Môi trường ổn định.";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      color: Colors.orangeAccent,
      child: Text(
        getWarning(),
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
