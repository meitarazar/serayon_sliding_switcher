part of serayon_sliding_switcher;

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
    outOffset = outTopLeft.zeroY;
  } else if (direction == SlideOutDirection.top) {
    outOffset = outTopLeft.zeroX;
  } else if (direction == SlideOutDirection.right) {
    outOffset = outBottomRight.zeroY;
  } else if (direction == SlideOutDirection.bottom) {
    outOffset = outBottomRight.zeroX;
  }
  /*else if (direction == SlideOutDirection.start) {
    if (directionality == TextDirection.ltr) {
      outOffset = Offset.fromDirection(pi, outTopLeft.dx); // left is start of ltr
    } else {
      outOffset = Offset.fromDirection(0.0, outBottomRight.dx); // right is start of rtl
    }
  } else if (direction == SlideOutDirection.end) {
    if (directionality == TextDirection.ltr) {
      outOffset = Offset.fromDirection(0.0, outBottomRight.dx); // right is end of ltr
    } else {
      outOffset = Offset.fromDirection(pi, outTopLeft.dx); // left is end of rtl
    }
  }*/

  // this 'if' statement is more complex than the upper start/end separate cases... but it's less rows...
  // start  ltr | <   >
  // -------------------
  // 0      0   | X
  // 0      1   |     X
  // 1      0   |     X
  // 1      1   | X
  else if ((direction == SlideOutDirection.start) ^ (Directionality.of(context) == TextDirection.ltr)) {
    outOffset = outBottomRight.zeroY;
  } else {
    outOffset = outTopLeft.zeroY;
  }

  return outOffset;
}

_RenderCoordinates _getRenderCoordinates(RenderObject? renderObject) {
  Size containerSize;
  Offset positionOnScreen;

  if (renderObject is RenderBox) {
    containerSize = renderObject.size;
    positionOnScreen = renderObject.localToGlobal(Offset.zero);
  } else {
    containerSize = renderObject?.paintBounds.size ?? Size.zero;
    Vector3 position3D = renderObject?.getTransformTo(null).getTranslation() ?? Vector3.zero();
    positionOnScreen = Offset(position3D.x, position3D.y);
  }

  return _RenderCoordinates(containerSize, positionOnScreen);
}

extension _Intersect on Offset {
  /// Zeroing the dx value without changing the dy
  Offset get zeroX => Offset(0.0, dy);

  /// Zeroing the dy value without changing the dx
  Offset get zeroY => Offset(dx, 0.0);
}

/// Holds the container size and the position on the screen of the rendered object
class _RenderCoordinates {
  /// The rendered container size
  final Size size;

  /// The rendered container position on screen
  final Offset position;

  /// Creates a RenderCoordinates. The first argument sets [size], the rendered container size,
  /// and the second sets [position], the position of the rendered container on screen.
  _RenderCoordinates(this.size, this.position);
}
