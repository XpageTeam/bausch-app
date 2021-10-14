import 'package:bausch/sections/shops/widgets/current_location_button.dart';
import 'package:bausch/sections/shops/widgets/zoom_button.dart';
import 'package:flutter/material.dart';

class MapButtons extends StatelessWidget {
  final VoidCallback? onZoomIn;
  final VoidCallback? onZoomOut;
  final VoidCallback? onCurrentLocation;
  const MapButtons({
    this.onZoomIn,
    this.onZoomOut,
    this.onCurrentLocation,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ZoomButton(
          zoomIn: onZoomIn,
          zoomOut: onZoomOut,
        ),
        const SizedBox(
          height: 152,
        ),
        CurrentLocationButton(
          onPressed: onCurrentLocation,
        ),
      ],
    );
  }
}
