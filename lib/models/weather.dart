

import 'package:flutter/foundation.dart';

class Weather {

  final location;
  double temp;
  final double tempMin;
  final double tempMax;
  final weather;
  final description;
  final humidity;
  final pressure;
  final double windSp;
  String icon;
  

  Weather({@required this.location, 
  @required this.temp,
   @required this.tempMin,
   @required this.tempMax,
   @required this.weather,
   @required this.description,
   @required this.humidity,
   @required this.pressure,
   @required this.windSp, 
   @required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json){
    return Weather(
      location: json["name"],
      temp: json["main"]["temp"],
      tempMin: json["main"]["temp_min"],
      tempMax: json["main"]["temp_max"],
      weather: json["weather"][0]["main"],
      description: json["weather"][0]["description"],
      humidity: json["main"]["humidity"],
      pressure: json["main"]["pressure"],
      windSp: json["wind"]["speed"],
      icon: json["weather"][0]["icon"]
    );
  }

  int convertTemp(double tmp){   // convert temperature from Kelvin (K) to celecius (C°)
      return (tmp - 273).toInt();   

  }

  int get temperature{
       return convertTemp(temp);
  }  

  int get maxTemperature{
       return convertTemp(tempMax);
  }

   int get minTemperature{
       return convertTemp(tempMin);
  }

  int get windSpeed{
       return windSp * 3600~/1000; 
  } 

  String get iconUrl{
    return 'https://openweathermap.org/img/w/$icon.png';
  }
}