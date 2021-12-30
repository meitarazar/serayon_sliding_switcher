library serayon_sliding_switcher;

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

part 'src/utils.dart';

part 'src/controller.dart';

part 'src/listener.dart';

part 'src/widget.dart';

enum SliderState { none, first, second }

enum SlideOutDirection { left, right, start, end, up, down }

extension Name on SlideOutDirection {
  String get name {
    switch(this) {
      case SlideOutDirection.left:
        return 'Left';
      case SlideOutDirection.right:
        return 'Right';
      case SlideOutDirection.start:
        return 'Start';
      case SlideOutDirection.end:
        return 'End';
      case SlideOutDirection.up:
        return 'Up';
      case SlideOutDirection.down:
        return 'Down';
    }
  }
}
