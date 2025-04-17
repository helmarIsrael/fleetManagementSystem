import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fleetmanagementsystem/functions/functions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WorkersAndJobsPage extends StatefulWidget {
  @override
  State<WorkersAndJobsPage> createState() => _WorkersAndJobsPageState();
}

class _WorkersAndJobsPageState extends State<WorkersAndJobsPage> {
  List<dynamic>? workerLocation;
  List<dynamic>? clientLocation;
  LatLng? _currentLocation;
  final Location _location = Location();
  List<Polyline> _polylineRoutes = [];

  @override
  void initState() {
    super.initState();
    loadData();
    _userCurrentLocation();
    _initializeLocation();
  }

  List<Marker> _markerGenerator(List<dynamic> locationLists, Color color) {
    List<Marker> markerLayers = [];
    for (int i = 0; i < locationLists.length; i++) {
      markerLayers.add(
        Marker(
          point: LatLng(locationLists[i][1], locationLists[i][2]),
          width: 50,
          height: 50,
          child: GestureDetector(
            onTap: () {
              if (color == Colors.red) {
                Map<String, dynamic> data = {
                  "clientId": locationLists[i][0],
                  "latitude": locationLists[i][1],
                  "longitude": locationLists[i][2],
                };
                _openDetailsBottomModalSheet(data);
              } else if (color == Colors.blue) {
                _openDetailsBottomModalSheet({});
              }
            },
            child: Icon(Icons.location_pin, size: 40, color: color),
          ),
          rotate: true,
        ),
      );
    }
    return markerLayers;
  }

  void loadData() async {
    List<dynamic> fetchedData = await fetchWorkerLocation();
    List<dynamic> fetchedDataClient =
        await fetchClientLocation(); // Wait for the Future
    if (mounted) {
      setState(() {
        workerLocation = fetchedData;
        clientLocation = fetchedDataClient; // Update state
      });
    }
  }

  Future<void> _initializeLocation() async {
    if (!await _checkRequestedPermission()) return;
    _location.onLocationChanged.listen((LocationData locationData) {
      if (locationData.latitude != null && locationData.longitude != null) {
        if (mounted) {
          setState(() {
            _currentLocation = LatLng(
              locationData.latitude!,
              locationData.longitude!,
            );
          });
        }
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
    if (permissionGranted == PermissionStatus.denied) {
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
      _currentLocation = LatLng(
        locationData.latitude!,
        locationData.longitude!,
      );
      if (mounted) {
        setState(() {
          if (_currentLocation != null) {
            _mapController.move(_currentLocation!, 15);
          } else {
            _currentLocation = LatLng(0, 0);
          }
        });
      }
    });
  }

  Future<void> _openDetailsBottomModalSheet(Map<String, dynamic> data) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          child: FutureBuilder(
            future: fetchClientAndWorkerDistance(data),
            builder: (context, snapshot) {
              // While the future is loading, show a circular progress indicator.
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              // In case of an error, show an error message.
              else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              // If data is fetched, display it in your list
              else if (snapshot.hasData) {
                final package = snapshot.data as List<dynamic>;
                _polylineRoutes.clear();
                fetchAndCreateRoute(data, package);
                return ListView.builder(
                  itemCount: package.length,
                  itemBuilder: (context, index) {
                    final worker = package[index];
                    return Card(
                      child: ListTile(
                        title: Text(worker['worker_id']),
                        subtitle: Text(
                          'Distance: ${worker['distance']} meters',
                        ),
                      ),
                    );
                  },
                );
              }
              // Fallback (should rarely reach here)
              else {
                return Center(child: Text('No data available.'));
              }
            },
          ),
        );
      },
    );
  }

  List<LatLng> _decodePolyline(String encodedPolyline) {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPoints = polylinePoints.decodePolyline(
      encodedPolyline,
    );

    List<LatLng> route =
        decodedPoints
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();
    return route;
  }

  Future<void> fetchAndCreateRoute(
    Map<String, dynamic> client,
    List<dynamic> worker,
  ) async {
    for (int i = 0; i < worker.length; i++) {
      final url = "http://router.project-osrm.org/route/v1/driving/";
      print("client: ${client['longitude']},${client['latitude']}");
      print("worker: ${worker[i]['longitude']},${worker[i]['latitude']}");
      final response = await http.get(
        Uri.parse(
          '$url${client['longitude']},${client['latitude']};${worker[i]['longitude']},${worker[i]['latitude']}',
        ),
      );
      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        final encodedPolyline = decodedResponse['routes'][0]['geometry'];
        _polylineRoutes.add(
          Polyline(
            points: _decodePolyline(encodedPolyline),
            strokeWidth: 5,
            color: getRandomColor(),
          ),
        );
      } else {
        print(
          'Request failed with status: ${response.statusCode}, ${response.body}',
        );
      }
      print("empty? ${_polylineRoutes.isEmpty}");
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fleet Management System')),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation ?? const LatLng(0, 0),
              initialZoom: 2,
              minZoom: 0,
              maxZoom: 18,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                maxZoom: 19,
              ),
              if (workerLocation != null)
                MarkerLayer(
                  markers: [
                    ..._markerGenerator(workerLocation!, Colors.blue),
                    ..._markerGenerator(clientLocation!, Colors.red),
                  ],
                ),
              if (_polylineRoutes.isNotEmpty)
                PolylineLayer(polylines: _polylineRoutes),
            ],
          ),
        ],
      ),
    );
  }
}
