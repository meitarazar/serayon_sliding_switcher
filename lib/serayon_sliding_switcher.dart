library serayon_sliding_switcher;

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

part 'src/controller.dart';

part 'src/listener.dart';

part 'src/utils.dart';

part 'src/widget.dart';

/// An enum that's used by the [SlidingSwitcherController] to define
/// the sliding state of it's managed [SlidingSwitcherWidget]s.
enum SliderState {
  /// The state when no child is visible.
  none,

  /// The state when only the first child is visible.
  first,

  /// The state when only the second child is visible.
  second,
}

/// An enum that's used by the [SlidingSwitcherController] to define
/// the sliding direction of it's managed [SlidingSwitcherWidget]s.
enum SlideOutDirection {
  /// The direction to exit/enter the screen to/from the left.
  left,

  /// The direction to exit/enter the screen to/from the right.
  right,

  /// The direction to exit/enter the screen to/from the left on ltr layouts,
  /// and to/from the right on rtl layouts.
  start,

  /// The direction to exit/enter the screen to/from the right on ltr layouts,
  /// and to/from the left on rtl layouts.
  end,

  /// The direction to exit/enter the screen to/from the top.
  up,

  /// The direction to exit/enter the screen to/from the bottom.
  down,
}

/// A simple class for getting the display name of each
/// [SlideOutDirection] value.
extension Name on SlideOutDirection {
  /// The capitalized display-name of the [SlideOutDirection] enum value.
  String get displayName {
    switch (this) {
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
