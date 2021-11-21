import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherPro/provider/weatherProvider.dart';
import 'package:weatherPro/ui/homeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WeatherProvider>(
        create: (context) => WeatherProvider(),
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                fontFamily: "Oswald"),
            home: HomeScreen()));
  }
}
