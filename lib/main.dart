import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/services/weather_provider.dart';
import 'package:weather/view/home_page.dart';
void main() {
  runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) =>WeatherProvider())
  ],
  child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

