import 'package:earthquake_app/detailsPage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:developer';
import 'package:splashscreen/splashscreen.dart';

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
        title: new Text('Earthquakes Around The World...',
          style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25.0
          ),),
        image: new Image.asset('assets/earthquake.png'),
        backgroundColor: Colors.white70,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 200.0,
        loaderColor: Colors.blueAccent
    );
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
      print(results);
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
      appBar: AppBar(
        title: Text(
          "Earthquakes".toUpperCase(),
        ),
        centerTitle: true,
      ),
      body: results.length == 0
          ? SpinKitChasingDots(color: Colors.lightBlue, size: 50.0)
          : ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(
                    results[index]["properties"]["time"] * 1000);
                DateTime now = DateTime.parse("$dateTime");
                String time =
                    DateFormat("EEE, MMM d yyyy, h:mm a ").format(now);
                var title = results[index]["properties"]["title"];
                var latitude = results[index]["geometry"]["coordinates"][0];
                var longitude = results[index]["geometry"]["coordinates"][1];
                var id = results[index]["id"];
                var place = results[index]["properties"]["place"];
                var mag = results[index]["properties"]["mag"].toString();
                var url = results[index]["properties"]["url"];

                return Card(
                  child: ListTile(
                    leading: Text(
                      "${index + 1}",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    title: Text(
                      "$place",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    trailing: Text(
                      "$mag",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                );
              }),
    );
  }
}
