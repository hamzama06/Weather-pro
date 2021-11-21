import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherPro/api/apiKey.dart';
import 'package:weatherPro/models/dailyForecast.dart';
import 'package:weatherPro/models/weather.dart';

class WeatherProvider extends ChangeNotifier {
  final keyApi = ApiKey.WEATHER_API_KEY;

  bool isCoordinatesEnabled = false;
  bool isFetchingLocation = false;
  double lat, long; // latitude and longitude
  var city;

  // Get current weather state
  Future<Weather> fetchWeatherData() async {
    try {
      final connectionStates = await InternetAddress.lookup('google.com');
      if (connectionStates.isEmpty &&
          connectionStates[0].rawAddress.isNotEmpty) {
        return null;
      }
      final requestUrl =
          "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=$keyApi";
      final response = await http.get(Uri.parse(requestUrl));

      if (response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("error loading data");
      }
    } catch (e) {
      return null;
    }
  }

  // get forecast for 5 days
  Future<List<DailyForecast>> fetchForecastDataList() async {
    try {
      final requestUrl =
          "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$long&appid=$keyApi";
      final response = await http.get(Uri.parse(requestUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)["list"];
        List<DailyForecast> foreCastList = [];
        for (var day in data) {
          if (DailyForecast.fromJson(day).time == "12:00:00") {
            foreCastList.add(DailyForecast.fromJson(day));
          }
        }
        return foreCastList;
      } else {
        throw Exception("error loading data");
      }
    } catch (e) {
      return null;
    }
  }

  setLocation(double latitude, double longitude) {
    this.lat = latitude;
    this.long = longitude;
    notifyListeners();
  }

  Future getCurrentLocation(context) async {
    bool _serviceEnabled;
    LocationPermission permission;
    isFetchingLocation = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    notifyListeners();

    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      isFetchingLocation = false;
      notifyListeners();
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text(
                "Location service",
                style: TextStyle(fontSize: 16),
              ),
              content: Text(
                "Turn on location service for device to determine your location.",
                style: TextStyle(fontSize: 14),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: Text("Cancel")),
                TextButton(
                    onPressed: () {
                      Geolocator.openLocationSettings();
                      Navigator.pop(ctx);
                    },
                    child: Text("Turn on")),
              ],
            );
          });

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        isFetchingLocation = false;
        notifyListeners();
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      isFetchingLocation = false;
      notifyListeners();
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((location) {
      if (location.latitude != null && location.longitude != null) {
        lat = location.latitude;
        long = location.longitude;
        prefs.setDouble("lat", lat);
        prefs.setDouble("long", long);
        isFetchingLocation = false;
        notifyListeners();
      }
    }).onError((error, stackTrace) {
      isFetchingLocation = false;
      notifyListeners();
    });
  }

  persistePrefernces() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("lat")) {
      lat = prefs.getDouble("lat");
      long = prefs.getDouble("long");
      notifyListeners();
    }
  }
}
