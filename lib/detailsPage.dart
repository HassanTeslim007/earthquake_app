import 'dart:collection';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


class Detailspage extends StatefulWidget {
  final String title;
  final double latitude;
  final double longitude;
  final String id;
  final String place;
  final String mag;
  final String url;

  Detailspage({this.title, this.latitude, this.longitude, this.id, this.place, this.mag, this.url});

  @override
  _DetailspageState createState() => _DetailspageState();
}

class _DetailspageState extends State<Detailspage> {
  Set<Marker> markers = HashSet<Marker>();
  GoogleMapController _mapController;

  void _onMapCreated(GoogleMapController controller){
    _mapController = controller;
    setState(() {
      markers.add(
          Marker(
              markerId: MarkerId("id"),
              position: LatLng(
                widget.longitude,
                widget.latitude,
              ),
              infoWindow: InfoWindow(
                  title: "${widget.place}",
                  snippet: "magnitude: ${widget.mag}",
                  onTap: _launchURL
              ),
          )
      );

    });
  }

  void _launchURL() async {
    String url = '${widget.url}';
    // if (await canLaunch(url)) {
    //   await launch(url, forceWebView: true);
    // } else {
    //   print('Could not launch $url');
    // }
    try{
      if (await canLaunch(url)) {
          await launch(url, forceWebView: true, enableJavaScript: true);
      }
    }catch(e){
      log(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.title}"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
                target: LatLng(
                  widget.longitude,
                  widget.latitude,
                ),
                zoom: 10),
            onMapCreated: _onMapCreated,
            markers: markers,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              alignment: Alignment.bottomLeft,
              child: Text(
                "${widget.longitude}, ${widget.latitude}",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 50.0, right: 50, left: 20) ,
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              label: Text("Details"),
              onPressed: _launchURL,
              backgroundColor: Colors.lightBlue,
              icon:  Icon(Icons.more),
            ),
          )
        ],
      ),
    );
  }
}
