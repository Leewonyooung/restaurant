import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/route_manager.dart';
import 'package:latlong2/latlong.dart' as latlng;

class RestaurantLocation extends StatefulWidget {
  const RestaurantLocation({super.key});

  @override
  State<RestaurantLocation> createState() => _RestaurantLocationState();
}

class _RestaurantLocationState extends State<RestaurantLocation> {

  late MapController mapController;
  var value = Get.arguments ?? '__';

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 50,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          '맛집 위치',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
    ),
    body: Center(
        child: flutterMap(),
      ),
    );
  }
  Widget flutterMap(){
    return FlutterMap(   
      mapController: mapController,
      options: MapOptions(
        initialCenter: latlng.LatLng(double.parse(value[0].toString()), double.parse(value[1].toString())),
        initialZoom: 17,
      ),
       children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 180,
              height: 120,
              point: latlng.LatLng(double.parse(value[0].toString()), double.parse(value[1].toString())),
               child: Column(
                children: [
                  SizedBox(
                    child: Text(
                      value[2],
                      style: const TextStyle(
                        backgroundColor: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                      ),
                    ),
                  ),
                  const Icon(Icons.pin_drop,
                  size: 50,
                  color: Colors.red,
                  )
                ],
               ),
            ),

          ]
        )
      ],
    );
  }
}