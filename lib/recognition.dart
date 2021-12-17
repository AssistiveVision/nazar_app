//import 'dart:js';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//import 'package:object_detection/ui/camera_view_singleton.dart';

/// Represents the recognition output from the model
class Recognition {
  /// Index of the result
  int _id;

  /// Label of the result
  String _label;

  /// Confidence [0.0, 1.0]
  double _score;

  /// Location of bounding box rect
  ///
  /// The rectangle corresponds to the raw input image
  /// passed for inference
  Rect _location = Rect.fromLTWH(0.0, 0.0, 0.0, 0.0);
  Size _screenSize = Size(0.0,0.0);

  Recognition(this._id, this._label, this._score, this._location, this._screenSize) ;

  int get id => _id;

  String get label => _label;

  double get score => _score;

  Rect get location => _location;
  Size get screenSize => _screenSize;

  /// Returns bounding box rectangle corresponding to the
  /// displayed image on screen
  ///
  /// This is the actual location where rectangle is rendered on
  /// the screen

  Rect get renderLocation {
    // ratioX = screenWidth / imageInputWidth
    // ratioY = ratioX if image fits screenWidth with aspectRatio = constant

    double ratioX = _screenSize.width/300;
    double ratioY = ratioX;

    double transLeft = max(0.1, location.left * ratioX);
    double transTop = max(0.1, location.top * ratioY);
    double transWidth = min(
        location.width * ratioX, screenSize.width);
    double transHeight = min(
        location.height * ratioY, screenSize.width*ratioX);

    Rect transformedRect =
    Rect.fromLTWH(transLeft, transTop, transWidth, transHeight);
    return transformedRect;
  }

  @override
  String toString() {
    return 'Recognition(id: $id, label: $label, score: $score, location: $location)';
  }
}