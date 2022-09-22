import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MapScreenState();
  }
}

class MapScreenState extends State<MapScreen> {
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
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .50,
              width: MediaQuery.of(context).size.width,
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
              height: (MediaQuery.of(context).size.height * .35) - 50,
              width: MediaQuery.of(context).size.width,
              child: TextField(
                keyboardType: TextInputType.multiline,
                controller: noteTextEditingController,
                decoration: InputDecoration(
                    label: Text("Note"), hintText: "Insert Your Note Please"),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: (MediaQuery.of(context).size.height * .15) - 50,
        width: MediaQuery.of(context).size.width,
        child: TextButton(onPressed: () {}, child: Text("Done")),
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
}