import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:login/model/order.dart';
import 'package:login/screens/login.dart';
import 'package:login/screens/order_details_page.dart';
import 'package:login/screens/order_page.dart';
import 'package:login/utl/ConstantValue.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapScreen extends StatefulWidget {
  double totalPrice;

  MapScreen(this.totalPrice);

  @override
  State<StatefulWidget> createState() {
    return MapScreenState(totalPrice);
  }
}

class MapScreenState extends State<MapScreen> {
  double totalPrice;
  MapScreenState(this.totalPrice);

  List<Marker> markers = [];
  TextEditingController noteTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0B47A9),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .50,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(20),
              child: GoogleMap(
                  markers: markers.toSet(),
                  onTap: onMapTap,
                  mapType: MapType.hybrid,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(31.9732595, 35.9121911), zoom: 15)),
            ),
            SizedBox(
              height: (MediaQuery.of(context).size.height * .35) - 40.0,
              width: MediaQuery.of(context).size.width-40.0,
              child: TextField(
                keyboardType: TextInputType.multiline,
                controller: noteTextEditingController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.note),
                    label: Text("Leave a Note"),
                    hintText: "Insert Your Note Please",
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 1))),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: (MediaQuery.of(context).size.height * .15) - 60.0,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xFF0B47A9),
        ),
        child: TextButton(
            onPressed: () async {
              Position postiton = await _determinePosition();
              AddOrder(postiton.longitude, postiton.latitude);
            },
            child: Text("Done", style: TextStyle(
              color: Colors.white,
            ))),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  onMapTap(LatLng latLng) {
    if (markers.isEmpty) {
      markers.add(Marker(markerId: MarkerId("1"), position: latLng));
    } else {
      markers[0] = Marker(markerId: MarkerId("1"), position: latLng);
    }
    setState(() {});
  }

  Future AddOrder(double lng, double lat) async {
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString(ConstantValue.ID) ?? "";

    if (userId == "") {
      Timer(
          Duration(seconds: 3),
          () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) => Login())));
    }
    final response = await http.post(Uri.parse("${ConstantValue.URL}AddOrder.php"),
        body: {
      "Longitude": lng.toString(),
      "Latitude": lat.toString(),
      "Note": noteTextEditingController.text,
      "TotalPrice": totalPrice.toString(),
      "Id_users": userId,
    });

    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      var result = jsonBody['result'];
      if (result) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Your Order is on the way"),
                content: Text("Thank You"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                              MyOrderPage()));
                    },
                    child: Text("OK",style: TextStyle(color: Color(0xFF0B47A9)),),
                  )
                ],
              );
            });
      }
    }
  }

  Future deleteCart() async {
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString(ConstantValue.ID) ?? "";
    if (userId == "") {
      Timer(
          Duration(seconds: 3),
              () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) => Login())));
    }
    final response = await http.post(
        Uri.parse("${ConstantValue.URL}deleteCart.php"),
        body: {"Id_users": userId});
    if (response.statusCode == 200) {
      return (jsonDecode(response.body));
    }
  }
}
