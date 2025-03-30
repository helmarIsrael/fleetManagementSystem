import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:location/location.dart';
import 'package:fleetmanagementsystem/functions/functions.dart';

class WorkersAndJobsPage extends StatefulWidget {
  @override
  State<WorkersAndJobsPage> createState() => _WorkersAndJobsPageState();
}


class _WorkersAndJobsPageState extends State<WorkersAndJobsPage> {

  List<dynamic>? workerLocation;
  LatLng? _currentLocation;
  final Location _location = Location();
 @override
  void initState() {
    super.initState();
    loadData();
    _userCurrentLocation();
    _initializeLocation();
  }


  void loadData() async {
    List<dynamic> fetchedData = await fetchWorkerLocation(); // Wait for the Future
    setState(() {
      workerLocation = fetchedData; // Update state
    });
  }

  Future<void> _initializeLocation() async{
    if (!await _checkRequestedPermission()) return;
    _location.onLocationChanged.listen((LocationData locationData) {
      if (locationData.latitude != null && locationData.longitude != null) {
        setState(() {
          _currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
        });
      }
    });
  }

  Future<bool> _checkRequestedPermission() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied){
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  void _userCurrentLocation() async {
    Location location = Location();
    location.getLocation().then((LocationData locationData) {
      _currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
      setState(() {
        if (_currentLocation != null) {
          _mapController.move(_currentLocation!, 15);
        } else {
          _currentLocation = LatLng(0, 0);
        }
      });
      
    });
   
  }
  
  @override
  void dispose() {
    super.dispose();
  }

  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
            title: const Text('Fleet Management System'),
          ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation ?? const LatLng(0, 0),
              initialZoom: 2,
              minZoom: 0,
              maxZoom: 18
            ),
            children: [
               TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                maxZoom: 19,
              ),
              CurrentLocationLayer(
                style: LocationMarkerStyle(
                  marker: DefaultLocationMarker(
                    child: Icon(Icons.location_pin, color: Colors.red),
                  ),
                  markerSize: Size(35, 35),
                  markerDirection: MarkerDirection.heading
                ),
              ),
              
            ],
          ),
        ],
      )
    );
  }
}