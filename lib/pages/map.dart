
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPickerPage extends StatefulWidget {
  @override
  _MapPickerPageState createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  LatLng? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Picker'),
      ),
      body: GoogleMap(
  initialCameraPosition: CameraPosition(
    target: LatLng(37.7749, -122.4194), // Initial map location (San Francisco)
    zoom: 12,
  ),
  onTap: (LatLng latLng) {
    setState(() {
      _pickedLocation = latLng;
    });
  },
  markers: _pickedLocation != null
      ? {
          Marker(
            markerId: MarkerId('picked_location'),
            position: _pickedLocation!,
          ),
        }
      : {},
),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle the picked location, e.g., save it or use it for further processing
          if (_pickedLocation != null) {
            print('Picked Location: ${_pickedLocation!.latitude}, ${_pickedLocation!.longitude}');
            Navigator.pop(context, _pickedLocation);
          }
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
