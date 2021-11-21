import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherPro/provider/weatherProvider.dart';
import 'package:weatherPro/ui/weatherScreen.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<WeatherProvider>(context, listen: false).persistePrefernces();
  }

  @override
  Widget build(BuildContext context) {
    WeatherProvider weatherProvider = Provider.of<WeatherProvider>(context);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: weatherProvider.lat == null
            ? Stack(
                children: [
                  Container(
                    width: size.width,
                    height: size.height,
                    decoration: BoxDecoration(
                        color: Colors.black87,
                        image: DecorationImage(
                          image: AssetImage("assets/images/clear_sky.jpg"),
                          fit: BoxFit.fill,
                          colorFilter: new ColorFilter.mode(
                              Colors.black.withOpacity(0.5), BlendMode.dstATop),
                        )),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/ic_logo.png"),
                                  fit: BoxFit.fill,
                                )),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Container(
                              width: 180,

                              child: ElevatedButton.icon(
                                  onPressed: () {
                                    Provider.of<WeatherProvider>(context,
                                            listen: false)
                                        .getCurrentLocation(context)
                                        .then((location) {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => WeatherScreen()));
                                    });
                                  },
                                  style: ButtonStyle(
                                    side: MaterialStateProperty.all<BorderSide>(
                                        BorderSide(
                                            color: Colors.white, width: 0.8)),
                                  ),
                                  icon: Icon(
                                    Icons.location_on,
                                    size: 20,
                                  ),
                                  label: Center(
                                    child: Text("Get my location now"),
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "*required to enable location service(gps)",
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          if (weatherProvider.isFetchingLocation)
                            CircularProgressIndicator()
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : WeatherScreen());
  }
}
