
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {

  @override
  MapWidgetWidgetState createState() => MapWidgetWidgetState();
}

class MapWidgetWidgetState extends State<MapWidget> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();


  static const CameraPosition Mylocation = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(13.772263, 100.583822),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  static final Marker _Mylocation = Marker(
    markerId: MarkerId('_Mylocation'),
    infoWindow: InfoWindow(title: 'ตึก B1 คอนโดลุมพีนีวิลล์ ศูนย์วัฒนธรรม'),
    icon: BitmapDescriptor.defaultMarker,
    position:  LatLng(13.772263, 100.583822),

  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
        backgroundColor: Colors.blueAccent,

      ),
      body: GoogleMap(
        mapType: MapType.normal,
        markers: {_Mylocation},
        initialCameraPosition: Mylocation,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To My Location!'),
        icon: const Icon(Icons.house),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(Mylocation));
  }
}
