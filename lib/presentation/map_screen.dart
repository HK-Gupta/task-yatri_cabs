import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// State for managing current location
class LocationState {
  final LatLng currentLocation;
  final bool isLoading;

  LocationState({required this.currentLocation, this.isLoading = true});

  LocationState copyWith({LatLng? currentLocation, bool? isLoading}) {
    return LocationState(
      currentLocation: currentLocation ?? this.currentLocation,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Notifier to manage location updates
class LocationNotifier extends StateNotifier<LocationState> {
  final Location _location = Location();

  LocationNotifier()
      : super(LocationState(currentLocation: const LatLng(28.614, 77.199))) {
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _location.onLocationChanged.listen((LocationData current) {
      final newLocation =
      LatLng(current.latitude ?? 28.614, current.longitude ?? 77.199);
      state = state.copyWith(currentLocation: newLocation, isLoading: false);
    });
  }
}

// Provider for LocationNotifier
final locationProvider =
StateNotifierProvider<LocationNotifier, LocationState>((ref) {
  return LocationNotifier();
});

// MapScreen Widget
class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationState = ref.watch(locationProvider);
    final locationNotifier = ref.read(locationProvider.notifier);

    Completer<GoogleMapController> gMapController = Completer<GoogleMapController>();

    if (locationState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          gMapController.complete(controller);
        },
        initialCameraPosition: CameraPosition(
          target: locationState.currentLocation,
          zoom: 13,
        ),
        markers: {
          Marker(
            markerId: const MarkerId("Current Position"),
            position: locationState.currentLocation,
          ),
        },
      ),
    );
  }
}
