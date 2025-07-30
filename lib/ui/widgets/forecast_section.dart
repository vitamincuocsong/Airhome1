import 'package:flutter/material.dart';

class ForecastSection extends StatelessWidget {
  final double tempNext;
  final double humidityNext;

  ForecastSection({required this.tempNext, required this.humidityNext});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "🔮 Dự báo sau 1 giờ:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("🌡 Nhiệt độ: ${tempNext.toStringAsFixed(1)}°C"),
            Text("💧 Độ ẩm: ${humidityNext.toStringAsFixed(1)}%"),
          ],
        ),
      ),
    );
  }
}
