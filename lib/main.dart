import 'package:flutter/material.dart';

import 'Screens/dashboard.dart';

void main() => runApp(const DaApp());

class DaApp extends StatelessWidget {
  const DaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      title: 'My First Flutter App',
      home: Dashboard(),
    );
  }
}
