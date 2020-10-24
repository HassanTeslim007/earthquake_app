import 'file:///C:/Users/Hassan%20Teslim/AndroidStudioProjects/earthquake_app/lib/Screens/detailsPage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreenCode(),
  ));
}

class SplashScreenCode extends StatefulWidget {
  @override
  _SplashScreenCodeState createState() => _SplashScreenCodeState();
}

class _SplashScreenCodeState extends State<SplashScreenCode> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        seconds: 10,
        navigateAfterSeconds: new Earthquakes(),
        title: new Text(
          'Earthquakes Around The World...',
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
        ),
        image: new Image.asset('assets/earthquake.png'),
        backgroundColor: Colors.white70,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 200.0,
        loaderColor: Colors.brown);
  }
}

class Earthquakes extends StatefulWidget {
  @override
  _EarthquakesState createState() => _EarthquakesState();
}

class _EarthquakesState extends State<Earthquakes> {
  List results = [];
  String date;

  Future getQuakeDetails() async {
    http.Response response = await http.get(
        "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_day.geojson");
    setState(() {
      var data = jsonDecode(response.body);
      results = data["features"];
    });
  }

  @override
  void initState() {
    super.initState();
    getQuakeDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 70, ),
        child: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 10),
            child: Row(
              children: [
                Text(
                  "World".toUpperCase(),
                  style: TextStyle(color: Colors.brown[400], fontSize: 35, fontWeight: FontWeight.bold),
                ),
                Text(
                  "quakes".toUpperCase(),
                  style: TextStyle(color: Colors.brown[900], fontSize: 35,),
                ),
              ],
            ),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
      ),
      body: results.length == 0
          ? SpinKitDualRing(color: Colors.brown, size: 50.0, duration: Duration(milliseconds: 2000),)
          : Padding(
              padding: EdgeInsets.all(10),
              child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return Divider(
                      thickness: 1,
                      color: Colors.brown,
                    );
                  },
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(
                        results[index]["properties"]["time"] * 1000);
                    DateTime now = DateTime.parse("$dateTime");
                    String time =
                        DateFormat("EEE, MMM d yyyy, h:mm a ").format(now);
                    var title = results[index]["properties"]["title"];
                    var latitude = results[index]["geometry"]["coordinates"][0];
                    var longitude =
                        results[index]["geometry"]["coordinates"][1];
                    var id = results[index]["id"];
                    var place = results[index]["properties"]["place"];
                    var mag = results[index]["properties"]["mag"].toString();
                    var url = results[index]["properties"]["url"];
                    var indicator = results[index]["properties"]["mag"];
                    return ListTile(
                        title: Text(
                          "$place",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown),
                        ),
                        subtitle: Text(time.toString()),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Detailspage(
                                        title: title,
                                        latitude: latitude,
                                        longitude: longitude,
                                        id: id,
                                        place: place,
                                        mag: mag,
                                        url: url,
                                      )));
                        },
                        trailing: CircularStepProgressIndicator(
                          totalSteps: 10,
                          currentStep: indicator.toInt(),
                          selectedColor: indicator < 5
                              ? Colors.blueAccent[200]
                              : indicator >= 5 && indicator < 7
                                  ? Colors.redAccent[400]
                                  : Colors.redAccent[700],
                          unselectedColor: Colors.brown.withOpacity(0.3),
                          padding: 0,
                          width: 50,
                          child: Center(
                            child: Text(
                              "$mag",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ));
                  }),
            ),
    );
  }
}
