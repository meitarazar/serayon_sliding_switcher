library serayon_sliding_switcher;

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

part 'src/utils.dart';

part 'src/controller.dart';

part 'src/listener.dart';

part 'src/widget.dart';

enum SliderState { none, first, second }

enum SlideOutDirection { left, right, start, end, top, bottom }
