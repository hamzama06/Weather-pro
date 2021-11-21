import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherPro/models/dailyForecast.dart';
import 'package:weatherPro/models/weather.dart';
import 'package:weatherPro/provider/weatherProvider.dart';
import 'package:weatherPro/ui/widgets/dayWeatherItem.dart';
import 'package:weatherPro/ui/widgets/loading.dart';
import 'package:weatherPro/ui/widgets/weatherStateCard.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            toolbarHeight: 52,
            elevation: 0,
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                  icon: Icon(Icons.location_on),
                  onPressed: () {
                    Provider.of<WeatherProvider>(context, listen: false)
                        .getCurrentLocation(context);
                  })
            ]),
        body: homeScreen());
  }

  Widget homeScreen() {
    Size size = MediaQuery.of(context).size;
    var weather = Provider.of<WeatherProvider>(context);

    return FutureBuilder<Weather>(
      future: weather.fetchWeatherData(),
      builder: (_, snapshot) {
        return Stack(
          children: [
            Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                  color: Colors.black87,
                  image: DecorationImage(
                    image: AssetImage(snapshot.hasData
                        ? getBackgroundImage(
                            snapshot.data.weather, snapshot.data.description)
                        : "assets/images/clear_sky.jpg"),
                    fit: BoxFit.fill,
                    colorFilter: new ColorFilter.mode(
                        Colors.black.withOpacity(0.5), BlendMode.dstATop),
                  )),
            ),
            snapshot.connectionState == ConnectionState.done
                ? snapshot.hasData
                    ? Container(
                        width: size.width,
                        height: size.height,
                        child: Column(
                         children: [
                           SizedBox(
                             height: 60,
                           ),
                           Align(
                               alignment: Alignment.centerLeft,
                               child:
                                   buildCountryWidget(snapshot.data.location)),
                            SizedBox(
                             height: 30,
                           ),        
                           Center(
                               child: WeatherStateCard(
                             weatherData: snapshot.data,
                           )),
                           SizedBox(
                             height: 16,
                           ),
                           buildInfoWidget(
                             snapshot.data.windSpeed,
                             snapshot.data.humidity,
                             snapshot.data.pressure,
                           ),
                           SizedBox(
                             height: 30,
                           ),
                           Expanded(
                             child: Container(
                               padding: EdgeInsets.symmetric(horizontal: 10),
                               width: size.width,
                               color: Colors.white.withOpacity(0.15),
                               child: FutureBuilder<List<DailyForecast>>(
                                 future: weather.fetchForecastDataList(),
                                 builder: (ctx, forecastData) {
                                   if (!forecastData.hasData)
                                     return Center(
                                       child: CircularProgressIndicator(),
                                     );
                        
                                   return ListView.builder(
                                     itemCount: forecastData.data.length,
                                     padding: EdgeInsets.zero,
                                     itemBuilder: (_, indx) {
                                       return Padding(
                                         padding: const EdgeInsets.symmetric(
                                             horizontal: 2),
                                         child: Column(
                                           children: [
                                             DayWeatherItem(
                                               itemData:
                                                   forecastData.data[indx],
                                             ),
                                             Divider(
                                                 color: Colors.grey[300],
                                                 height: 0.8,
                                                 thickness: 0.8)
                                           ],
                                         ),
                                       );
                                     },
                                   );
                                 },
                               ),
                             ),
                           )
                         ],
                          ),
                      )
                    : Center(
                        child: Text(
                          "No data",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                : snapshot.connectionState == ConnectionState.waiting
                    ? Center(child: Loading())
                    : Center(
                        child: Text("Failed fetching data",
                            style: TextStyle(color: Colors.white)),
                      )
          ],
        );
      },
    );
  }

  Widget buildCountryWidget(
    String city,
  ) {
    DateTime now = DateTime.now();
    int day = now.day;
    int month = now.month;
    int year = now.year;
    String dayName = getDayName(now.weekday);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            city,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            "$dayName $day-$month-$year",
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  String getDayName(int weekDay) {
    String dayName = "";
    switch (weekDay) {
      case 1:
        dayName = "Monday";
        break;
      case 2:
        dayName = "Tuesday";
        break;
      case 3:
        dayName = "Wednesday";
        break;
      case 4:
        dayName = "Thursday";
        break;
      case 5:
        dayName = "Friday";
        break;
      case 6:
        dayName = "Saturday";
        break;
      case 7:
        dayName = "Sunday";
        break;
    }
    return dayName;
  }

  Widget buildInfoWidget(windSpeed, humidity, pressure) {
    return Container(
     // height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
       
        children: [
          Column(
            children: [
              Text(
                "wind",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              Text(
                "$windSpeed km/h",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ],
          ),
          SizedBox(
            width: 10,
          ),
          Center(
              child: Container(
            height: 32,
            width: 1.5,
            color: Colors.white,
          )),
          SizedBox(
            width: 10,
          ),
          Column(
            children: [
              Text(
                "humidity",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              Text(
                "$humidity%",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ],
          ),
          SizedBox(
            width: 10,
          ),
          Center(
              child: Container(
            height: 32,
            width: 1.5,
            color: Colors.white,
          )),
          SizedBox(
            width: 10,
          ),
          Column(
            children: [
              Text(
                "pressure",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              Text(
                pressure.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ],
          )
        ],
      ),
    );
  }

  String getBackgroundImage(String weatherState, String description) {
    if (weatherState == null) {
      return "assets/images/clear_sky.jpg";
    }
    String imageUrl = "assets/images/clear_sky.jpg";

    if (weatherState == "Clear") {
      imageUrl = "assets/images/clear_sky_2.jpg";
    } else if (weatherState == "Thunderstorm") {
      imageUrl = "assets/images/thunderstorm.jpg";
    } else if (weatherState == "Drizzle") {
     imageUrl = "assets/images/rainy_1.jpg";
    } else if (weatherState == "Rain") {
       imageUrl = "assets/images/rainy_2.jpg";
    } else if (weatherState == "Snow") {
       imageUrl = "assets/images/snowy_1.jpg";

    } else if (weatherState == "Clouds") {
      if (description == "few clouds") {
        imageUrl = "assets/images/cloudy_4.jpg";
      } else if (description == "scattered clouds") {
        imageUrl = "assets/images/cloudy_3.jpg";
      } else if (description == "broken clouds") {
        imageUrl = "assets/images/cloudy_1.jpg";
      } else {
        imageUrl = "assets/images/cloudy_5.jpg";
      }
    } else if (weatherState == "Fog" ||
        weatherState == "Haze" ||
        weatherState == "Mist") {
      imageUrl = "assets/images/fog.jpg";
    } else if (weatherState == "Smoke" ||
        weatherState == "Ash" ||
        weatherState == "Dust") {
      imageUrl = "assets/images/smoke.jpg";
    }else if (weatherState == "Squall") {
      imageUrl = "assets/images/thunderstorm.jpg";
    }else if (weatherState == "Sand") {
      imageUrl = "assets/images/sand.jpg";
    } else if (weatherState == "Tornado") {
      imageUrl = "assets/images/tornado.jpg";
    }

    return imageUrl;
  }
}
