part of serayon_sliding_switcher;

/// A widget wrapper with the ability to swap between two different
/// child widgets or hide them both by sliding them out of the screen and back.
///
/// This widget uses a [SlidingSwitcherController] that handles the change
/// events of [SliderState] and [SlideOutDirection].
///
/// With [SliderState] controlling the visibility of the children:
/// - [SliderState.none] - No child is visible
/// - [SliderState.first] - The first child is visible
/// - [SliderState.second] - The second child is visible
///
/// And the [SlideOutDirection] controlling when the child widgets will enter/exit from/to:
/// - [SlideOutDirection.left] - The left
/// - [SlideOutDirection.up] - The top
/// - [SlideOutDirection.right] - The right
/// - [SlideOutDirection.down] - The bottom
/// - [SlideOutDirection.start] - The left on LTR, and the right on RTL
/// - [SlideOutDirection.end] - The right on LTR, and the left on RTL
///
/// The widget can adapt to realtime direction changing, and re-calculate the
/// distances to exit/enter the screen completely, a behaviour you can disable
/// by changing the [canChangeDirection] property, which is true by default.
///
/// The [firstChild] property must be provided and not be null, but the [secondChild]
/// property can be omitted. This widget have 3 states, in which one of them hide them
/// both, so you don't need to omit the [secondChild] to have a state when no child
/// is shown, but, using the [SlidingSwitcherController.toggleState] method, you can
/// easily switch between visible and hidden if you provide only the [firstChild].
class SlidingSwitcherWidget extends StatefulWidget {
  /// The sliding controller managing this [SlidingSwitcherWidget]
  final SlidingSwitcherController slidingStateController;

  /// The animation duration for all exit/enter/swap animations.
  final Duration duration;

  /// Sets the ability of [SlidingSwitcherController] to change the
  /// [SlidingSwitcherWidget] direction across it's lifetime.
  final bool canChangeDirection;

  /// The first child present in the [SliderState.first] of this
  /// [SlidingSwitcherWidget].
  final Widget firstChild;

  /// The second child present in the [SliderState.second] of this
  /// [SlidingSwitcherWidget].
  final Widget? secondChild;

  /// Creates a [SlidingSwitcherWidget].
  ///
  /// The [firstChild] property must be provided and not be null, but
  /// the second child can be emitted if not necessary.
  ///
  /// The default animation duration is 350 millis, you can use the
  /// property [duration] to change it.
  ///
  /// The default behaviour of changing direction is enabled, you can
  /// use the property [canChangeDirection] to control that behaviour.
  const SlidingSwitcherWidget({
    Key? key,
    required this.slidingStateController,
    this.duration = const Duration(milliseconds: 350),
    this.canChangeDirection = true,
    required this.firstChild,
    this.secondChild,
  }) : super(key: key);

  @override
  State<SlidingSwitcherWidget> createState() => _SlidingSwitcherWidgetState();
}

class _SlidingSwitcherWidgetState extends State<SlidingSwitcherWidget> with SingleTickerProviderStateMixin, SlidingSwitcherListener {
  /// The animation controller to coordinate this charade.
  late AnimationController _controller;

  /// The translate animation for the first child.
  late Animation<Offset> _translateOutAnimation;

  /// The translate animation for the second child.
  late Animation<Offset> _translateInAnimation;

  /// The fade animation for the first child.
  late Animation<double> _fadeOutAnimation;

  /// The fade animation for the second child.
  late Animation<double> _fadeInAnimation;

  /// The cached direction in case the widget don't support
  /// direction changing.
  late SlideOutDirection _direction;

  /// Update the translate animations based on the current [RenderObject]
  /// to get the children widget out of the screen completely.
  void _updateAnimations() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      // not mounted, [RenderObject] won't be valid
      if (!mounted) return;

      // calculating the out-of-screen [Offset] using the cached direction
      Offset outOffset = _calcOutOffset(context, _direction);

      _translateOutAnimation = Tween(begin: Offset.zero, end: outOffset).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
        ),
      );

      _translateInAnimation = Tween(begin: outOffset, end: Offset.zero).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
        ),
      );
    });
  }

  /// Adds itself to the current [SlidingSwitcherController]'s listeners,
  /// and updates the translate animations.
  void _updateController() {
    widget.slidingStateController.addListener(this);

    // when changing the controller, we must accept the new direction
    _direction = widget.slidingStateController.direction;
    _updateAnimations();
  }

  /// Takes a [target] value to animate to, and doing that using the full
  /// animation duration instead of the resulted fraction.
  void _animateToTarget(double target) {
    // if we already here... why we need to move?
    if (_controller.value == target) return;

    if (_controller.value > target) {
      _controller.animateBack(target, duration: widget.duration);
    } else {
      _controller.animateTo(target, duration: widget.duration);
    }
  }

  @override
  void onChangedState(SliderState oldState, SliderState newState) {
    // we're still at the same state, no need to update
    if (oldState == newState) return;

    switch (newState) {
      case SliderState.none:
        // animating to [SliderState.none] is going half way
        //   to the point when no child is visible on screen
        _animateToTarget(0.5);
        break;
      case SliderState.first:
        _animateToTarget(0.0);
        break;
      case SliderState.second:
        // we want to make the slide out animation look
        //   slower when the second child is not present
        if (widget.secondChild == null) {
          _animateToTarget(0.5);
        } else {
          _animateToTarget(1.0);
        }
        break;
    }
  }

  @override
  void onChangeDirection(SlideOutDirection oldDirection, SlideOutDirection newDirection) {
    // update the translate animations only if the widget allows direction changing
    if (widget.canChangeDirection) {
      _direction = newDirection;
      _updateAnimations();
    }
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..addListener(() => setState(() {}));

    _translateOutAnimation = ConstantTween(Offset.zero).animate(_controller);
    _translateInAnimation = ConstantTween(Offset.zero).animate(_controller);

    _fadeOutAnimation = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _fadeInAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    super.initState();

    _updateController();
  }

  @override
  void didUpdateWidget(covariant SlidingSwitcherWidget oldWidget) {
    if (widget.slidingStateController != oldWidget.slidingStateController) {
      // if we have a new controller remove itself from the old one
      oldWidget.slidingStateController.removeListener(this);
      _updateController();
    }

    // the only baked duration is in the animation controller
    else if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.slidingStateController.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.translate(
          offset: _translateOutAnimation.value,
          child: Opacity(
            opacity: _fadeOutAnimation.value,
            child: widget.firstChild,
          ),
        ),
        Transform.translate(
          offset: _translateInAnimation.value,
          child: Opacity(
            opacity: _fadeInAnimation.value,
            child: widget.secondChild,
          ),
        ),
      ],
    );
  }
}
