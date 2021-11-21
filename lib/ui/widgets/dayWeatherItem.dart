import 'package:flutter/material.dart';
import 'package:weatherPro/models/dailyForecast.dart';

class DayWeatherItem extends StatelessWidget {
  final DailyForecast itemData;
  DayWeatherItem({@required this.itemData});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: Container(
        height: 55,
        padding: EdgeInsets.all(5),
        child: Row(
          children: [
            Expanded(
              child: Text(
                itemData.dayName,
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Image.network(itemData.iconUrl),
            SizedBox(
              width: 10,
            ),
            Text(
              "${itemData.temperature}°",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "${itemData.humidity}%",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
