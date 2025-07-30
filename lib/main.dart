import 'package:flutter/material.dart';
import 'ui/screens/home_screen.dart';

void main() {
  runApp(EnvironmentMonitorApp());
}

class EnvironmentMonitorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Giám sát môi trường',
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomeScreen(),
    );
  }
}
