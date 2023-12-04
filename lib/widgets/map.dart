
import 'dart:async';

import 'package:turf/helpers.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:latlong2/latlong.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../utils/essentials.dart';
import '../utils/logger.dart';

class MapBoxMapWidget extends StatefulWidget {

  const MapBoxMapWidget( {Key? key }) : super(key: key) ;






  @override
  State<MapBoxMapWidget> createState() => _MapBoxMapWidgetState();
}

class _MapBoxMapWidgetState extends State<MapBoxMapWidget>  with SingleTickerProviderStateMixin{
  final log = logger(MapBoxMapWidget);
  LatLng latLng = getLatLngFromSharedPrefs();
  MapboxMap? _mapController;
  PointAnnotationManager? pointAnnotationManager;
  PointAnnotation? pointAnnotation;
  late CameraOptions _initialCameraPosition;
  late StreamSubscription<geolocator.Position> _positionStream;





void initLocation()async{



}



  @override
  void initState(){

    super.initState();

    double coordinateX = latLng.longitude;
    double coordinateY = latLng.latitude;


    _initialCameraPosition = CameraOptions(
      center: Point(
          coordinates: Position(
            coordinateX,
            coordinateY,
          )).toJson(),
      zoom: 15.0,
      anchor: ScreenCoordinate(x: coordinateX, y: coordinateY),

    );


  }

  _onMapCreated(MapboxMap mapboxMap) {
    _mapController = mapboxMap;
    _mapController?.location
        .updateSettings(LocationComponentSettings(enabled: true));
    _mapController?.location
        .updateSettings(LocationComponentSettings(pulsingEnabled: true));
    _mapController?.location
        .updateSettings(LocationComponentSettings(showAccuracyRing: true));
    mapboxMap.annotations.createPointAnnotationManager().then((value) async {
      pointAnnotationManager = value;
      final ByteData bytes =
      await rootBundle.load("assets/config/custom-icon.png");
      final Uint8List list = bytes.buffer.asUint8List();
      createOneAnnotation(list);
      var options = <PointAnnotationOptions>[];
      for (var i = 0; i < 5; i++) {
        options.add(PointAnnotationOptions(
            geometry: createRandomPoint().toJson(), image: list));
      }
      pointAnnotationManager?.createMulti(options);

      var carOptions = <PointAnnotationOptions>[];
      for (var i = 0; i < 20; i++) {
        carOptions.add(PointAnnotationOptions(
            geometry: createRandomPoint().toJson(), iconImage: "assets/config/tracking.png"));
      }
      pointAnnotationManager?.createMulti(carOptions);
      pointAnnotationManager
          ?.addOnPointAnnotationClickListener(AnnotationClickListener());
    });
  }

  void createOneAnnotation(Uint8List list) {
    pointAnnotationManager
        ?.create(PointAnnotationOptions(
        geometry: Point(
            coordinates: Position(
              latLng.longitude+34,
              latLng.latitude- 43,
            )).toJson(),
        textField: "custom-icon",
        textOffset: [0.0, -2.0],
        textColor: Colors.red.value,
        iconSize: 1.3,
        iconOffset: [0.0, -5.0],
        symbolSortKey: 10,
        image: list))
        .then((value) => pointAnnotation = value);
  }





  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);

  }
  @override
  void dispose() {
    _mapController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return
      Stack(
        children: [
          SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.8,
              child: MapWidget(
                key: const ValueKey("mapWidget"),
                resourceOptions:ResourceOptions(accessToken:dotenv.env['MAPBOX_ACCESS_TOKEN']!),
                cameraOptions: _initialCameraPosition,
                onMapCreated: _onMapCreated,



              )
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              heroTag: 'Animate',
              onPressed: () {
                double x = latLng.longitude;
                double y = latLng.latitude;
                _mapController?.flyTo(
                    CameraOptions(
                        center:  Point(
                            coordinates: Position(
                              x,
                              y,
                            )).toJson(),
                        anchor: ScreenCoordinate(x: x, y: y),
                        zoom: 17,
                        bearing: 0,
                        pitch: 30),
                    MapAnimationOptions(duration: 2000, startDelay: 0));
              },
              child: const Icon(Icons.my_location),
            ),
          ),

        ],
      );
  }

}

class AnnotationClickListener extends OnPointAnnotationClickListener {
  final log = logger(AnnotationClickListener);
  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    log.i("onAnnotationClick, id: ${annotation.id}");
  }
}
