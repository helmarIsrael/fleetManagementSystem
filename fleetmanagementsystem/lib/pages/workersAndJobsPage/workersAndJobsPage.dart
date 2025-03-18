import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class WorkersAndJobsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    
    return Scaffold(
      appBar: AppBar(
            title: const Text('Fleet Management System'),
          ),
      body: OSMFlutter( 
        controller:MapController(
          initMapWithUserPosition: UserTrackingOption(
            enableTracking: true,),
        ),
        osmOption: OSMOption(
              userTrackingOption: UserTrackingOption(
              enableTracking: true,
              unFollowUser: false,
            ),
            zoomOption: ZoomOption(
                  initZoom: 8,
                  minZoomLevel: 3,
                  maxZoomLevel: 19,
                  stepZoom: 1.0,
            ),
            userLocationMarker: UserLocationMaker(
                personMarker: MarkerIcon(
                    icon: Icon(
                        Icons.location_history_rounded,
                        color: Colors.red,
                        size: 48,
                    ),
                ),
                directionArrowMarker: MarkerIcon(
                    icon: Icon(
                        Icons.double_arrow,
                        size: 48,
                    ),
                ),
            ),
            roadConfiguration: RoadOption(
                    roadColor: Colors.yellowAccent,
            ),
            
        )
    ),
    );
  }
}