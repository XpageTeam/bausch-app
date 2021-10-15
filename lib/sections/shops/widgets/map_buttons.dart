import 'package:bausch/sections/shops/widgets/current_location_button.dart';
import 'package:bausch/sections/shops/widgets/zoom_buttons.dart';
import 'package:flutter/material.dart';

class MapButtons extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onCurrentLocation;
  const MapButtons({
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onCurrentLocation,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(),
        ZoomButtons(
          zoomIn: onZoomIn,
          zoomOut: onZoomOut,
        ),
        CurrentLocationButton(
          onPressed: onCurrentLocation,
        ),
      ],
    );
  }
}
