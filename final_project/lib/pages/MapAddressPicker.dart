import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class MapAddressPicker extends StatefulWidget {
  final LatLng initialPosition;

  const MapAddressPicker({super.key, required this.initialPosition});

  @override
  State<MapAddressPicker> createState() => _MapAddressPickerState();
}

class _MapAddressPickerState extends State<MapAddressPicker> {
  late GoogleMapController _mapController;
  late LatLng _selectedPosition;
  String _selectedAddress = "Fetching address...";

  @override
  void initState() {
    super.initState();
    _selectedPosition = widget.initialPosition;
    _fetchAddressFromCoordinates(_selectedPosition);
  }

  Future<void> _fetchAddressFromCoordinates(LatLng position) async {
    try {
      // Reverse geocoding to fetch the address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          _selectedAddress =
              "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        });
      }
    } catch (e) {
      setState(() {
        _selectedAddress = "Unable to fetch address";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick Address"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context, {
                'address': _selectedAddress,
                'location': _selectedPosition,
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.initialPosition,
              zoom: 15,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            onCameraMove: (position) {
              setState(() {
                _selectedPosition = position.target;
                _selectedAddress = "Updating address...";
              });
            },
            onCameraIdle: () {
              _fetchAddressFromCoordinates(_selectedPosition);
            },
            markers: {
              Marker(
                markerId: const MarkerId("selected-location"),
                position: _selectedPosition,
              ),
            },
          ),
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  _selectedAddress,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}