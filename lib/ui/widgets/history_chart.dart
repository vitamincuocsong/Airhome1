import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HistoryChart extends StatelessWidget {
  final List<double> data;
  final String label;
  final Color lineColor;

  HistoryChart({
    required this.data,
    required this.label,
    required this.lineColor,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Expanded(
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true),
                    borderData: FlBorderData(show: true),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 24,
                          getTitlesWidget: (value, meta) {
                            int index = value.toInt();
                            return Text(
                              index < data.length ? '${index + 1}' : '',
                              style: TextStyle(fontSize: 10),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          data.length,
                          (i) => FlSpot(i.toDouble(), data[i]),
                        ),
                        isCurved: true,
                        color: lineColor, // ✅ Dùng đúng thuộc tính
                        barWidth: 3,
                        belowBarData: BarAreaData(
                          show: true,
                          color: lineColor.withOpacity(0.3),
                        ),
                        dotData: FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
