part of serayon_sliding_switcher;

/// Using a [BuildContext] to get the screen's [Size] and the current [RenderObject]'s
/// container [Size] and [Offset] on the screen.
///
/// And, using the [SlideOutDirection] to return an out-of-screen [Offset]
/// in the desired direction. The provided [Offset] will move the whole [RenderObject]
/// outside of the screen, no matter the direction.
Offset _calcOutOffset(BuildContext context, SlideOutDirection direction) {
  Size screenSize = MediaQueryData.fromWindow(WidgetsBinding.instance!.window).size;

  // getting the position and size of the rendered object
  _RenderCoordinates coordinates = _getRenderCoordinates(context.findRenderObject());

  // pre-calculating the out of screen positions in all directions
  Offset outTopLeft = Offset(-coordinates.position.dx - coordinates.size.width, -coordinates.position.dy - coordinates.size.height);
  Offset outBottomRight = Offset(screenSize.width - coordinates.position.dx, screenSize.height - coordinates.position.dy);

  // selecting the correct out direction
  Offset outOffset;
  if (direction == SlideOutDirection.left) {
    outOffset = outTopLeft.withZeroY;
  } else if (direction == SlideOutDirection.up) {
    outOffset = outTopLeft.withZeroX;
  } else if (direction == SlideOutDirection.right) {
    outOffset = outBottomRight.withZeroY;
  } else if (direction == SlideOutDirection.down) {
    outOffset = outBottomRight.withZeroX;
  }

  // this 'else if' statement is a bit complex... but it's very short :D
  // it comes after all the others to make sure that what's left are only start/end values
  //
  // Here's a truth table to explain it:
  //
  // start  ltr | <   >
  // -------------------
  // T      T   | X        // left  in ltr is the start
  // T      F   |     X    // right in rtl is the start
  // F      T   |     X    // right in rtl is the end
  // F      F   | X        // left  in ltr is the end
  //
  // which means that when they are different we go right, and that's XOR
  else if ((direction == SlideOutDirection.start) ^ (Directionality.of(context) == TextDirection.ltr)) {
    outOffset = outBottomRight.withZeroY;
  } else {
    outOffset = outTopLeft.withZeroY;
  }

  return outOffset;
}

/// Takes a [RenderObject] and extract it's container [Size] and [Offset]
/// on the screen as a [_RenderCoordinates] object.
_RenderCoordinates _getRenderCoordinates(RenderObject? renderObject) {
  Size containerSize;
  Offset positionOnScreen;

  // if it's a RenderBox we're in luck, that the easy one
  if (renderObject is RenderBox) {
    containerSize = renderObject.size;
    positionOnScreen = renderObject.localToGlobal(Offset.zero);
  }

  // if it's not, well... that's going to be ugly...
  else {
    containerSize = renderObject?.paintBounds.size ?? Size.zero;
    Vector3 position3D = renderObject?.getTransformTo(null).getTranslation() ?? Vector3.zero();
    positionOnScreen = Offset(position3D.x, position3D.y);
  }

  return _RenderCoordinates(containerSize, positionOnScreen);
}

/// A simple extension for taking only the [dx] or [dy] value with the other one being zero.
extension _Intersect on Offset {
  /// Zeroing the [dx] value without changing the [dy].
  Offset get withZeroX => Offset(0.0, dy);

  /// Zeroing the [dy] value without changing the [dx].
  Offset get withZeroY => Offset(dx, 0.0);
}

/// Holds the container [size] and the [position] on the screen of the [RenderObject].
class _RenderCoordinates {
  /// The [RenderObject] container size.
  final Size size;

  /// The [RenderObject] container position on screen.
  final Offset position;

  /// Creates a [_RenderCoordinates] object.
  ///
  /// The first argument sets [size], the [RenderObject] container size,
  /// and the second sets [position], the position of the [RenderObject] container on screen.
  _RenderCoordinates(this.size, this.position);
}
