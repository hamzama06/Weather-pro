import 'package:flutter/material.dart';
import 'package:weatherPro/models/weather.dart';

class WeatherStateCard extends StatelessWidget {
  final Weather weatherData;

  WeatherStateCard({@required this.weatherData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 200,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
      padding: EdgeInsets.all(10),
      child: Stack(
        children: [
          Positioned(
              right: 45,
              top: 72,
              child: Image.network(
                weatherData.iconUrl,
                fit: BoxFit.fill,
                width: 60,
                height: 60,
              )),
          SizedBox(
            height: 10,
          ),
          Positioned(
            top: 8,
            right: 0,
            left: 0,
            child: Center(
              child: Text(
                weatherData.description,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          Positioned(
            top: 12,
            right: 0,
            left: 0,
            child: Center(
              child: Text(
                "${weatherData.temperature}°",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 90,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            right: 0,
            left: 0,
            child: Center(
              child: Text(
                "${weatherData.maxTemperature}°/${weatherData.minTemperature}°",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
