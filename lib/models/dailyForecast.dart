


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class DailyForecast{
   
  String day; 
  final double temp;
  final tempMin;
  final tempMax;
  final weather;
  final humidity;
  final pressure;
  final windSpd;
  String icon;

  DailyForecast({
   @required this.day, 
   @required this.temp,
   @required this.tempMin,
   @required this.tempMax,
   @required this.weather,
   @required this.humidity,
   @required this.pressure,
   @required this.windSpd,
   @required this.icon,
    });

    factory DailyForecast.fromJson(Map<String, dynamic> json){
      return DailyForecast(
      day: json["dt_txt"],
      temp: json["main"]["temp"],
      tempMin: json["main"]["temp_min"],
      tempMax: json["main"]["temp_max"],
      weather: json["weather"][0]["main"],
      humidity: json["main"]["humidity"],
      pressure: json["main"]["pressure"],
      windSpd: json["wind"]["speed"],
      icon: json["weather"][0]["icon"]
    );
    }

      int convertTemp(double tmp){   // convert temperature from Kelvin (K) to celecius (C°)
      return (temp - 273).toInt();   

  }

  int get temperature{  // temperature in c°
       return convertTemp(temp);
  } 

    int get maxTemperature{  // max temperature in c° 
       return convertTemp(tempMax);
  }

   int get minTemperature{ // min temperature in c°
       return convertTemp(tempMin);
  }

  int get windSpeed{ // wind speed in km/h
       return windSpd * 3600~/1000; 
  } 

  String get time{
    return day.split(" ")[1];
  }

   String get iconUrl{
    return 'http://openweathermap.org/img/w/$icon.png';
  }

  String get dayName{
       // String date = day.split(" ")[0];
        DateTime date = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(day);
        String dayName = DateFormat('EEEE').format(date);
        return dayName;
         }

    


}