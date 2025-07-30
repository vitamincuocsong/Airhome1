import 'package:flutter/material.dart';

class CurrentDataCard extends StatelessWidget {
  final double temperature;
  final double humidity;
  final double co2;

  CurrentDataCard({
    required this.temperature,
    required this.humidity,
    required this.co2,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "🌡 Nhiệt độ: ${temperature.toStringAsFixed(1)}°C",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "💧 Độ ẩm: ${humidity.toStringAsFixed(1)}%",
              style: TextStyle(fontSize: 16),
            ),
            Text("🫁 CO₂: ${co2.toInt()} ppm", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
