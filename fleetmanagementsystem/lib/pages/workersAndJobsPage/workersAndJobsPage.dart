import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

class WorkersAndJobsPage extends StatefulWidget {
  @override
  State<WorkersAndJobsPage> createState() => _WorkersAndJobsPageState();
}

class _WorkersAndJobsPageState extends State<WorkersAndJobsPage> {
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
              initialCenter: LatLng(0, 0),
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