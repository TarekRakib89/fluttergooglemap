import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController googleMapController;
  Location location = Location();
  LocationData? currentLocation;
  late StreamSubscription locationSubscription;

  Future<void> getCurrentLocation() async {
    Location location = Location();
    currentLocation = await location.getLocation();
    setState(() {});

    Timer.periodic(const Duration(minutes: 10), (Timer timer) {
      locationSubscription = location.onLocationChanged.listen((locationData) {
        currentLocation = locationData;
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(
                  currentLocation!.longitude!,
                  currentLocation!.longitude!,
                ),
                zoom: 17),
          ),
        );
        if (mounted) {
          setState(() {});
        }
        //
      });
    });
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: currentLocation == null
          ? const Text("Loding...")
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                zoom: 14,
                target: LatLng(
                  currentLocation!.longitude!,
                  currentLocation!.longitude!,
                ),
              ),
              onMapCreated: (GoogleMapController controller) {
                googleMapController = controller;
                getCurrentLocation();
              },
              zoomControlsEnabled: false,
              zoomGesturesEnabled: false,
              compassEnabled: false,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: {
                Marker(
                  markerId: const MarkerId('initialPosition'),
                  position: const LatLng(24.5659, 91.4920),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueYellow),
                  infoWindow: const InfoWindow(
                      title: 'This is title', snippet: 'Thi si snippet'),
                ),
                Marker(
                  markerId: const MarkerId('initialPosition'),
                  position: const LatLng(24.3997, 91.5813),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueYellow),
                  infoWindow: const InfoWindow(
                      title: 'This is title', snippet: 'Thi si snippet'),
                ),
              },
              polylines: {
                Polyline(
                    polylineId: PolylineId('basic-line'),
                    color: Colors.blue,
                    width: 6,
                    visible: true,
                    endCap: Cap.buttCap,
                    jointType: JointType.mitered,
                    patterns: [
                      PatternItem.gap(10),
                      PatternItem.dash(10),
                      PatternItem.dot,
                      PatternItem.dash(10),
                    ],
                    points: [
                      const LatLng(24.5659, 91.4920),
                      LatLng(
                        currentLocation!.longitude!,
                        currentLocation!.longitude!,
                      ),
                      const LatLng(24.3997, 91.5813),
                    ]),
              },
            ),
    );
  }

  @override
  void dispose() {
    locationSubscription.cancel();
    super.dispose();
  }
}
