part of serayon_sliding_switcher;

class SlidingSwitcherWidget extends StatefulWidget {
  final SlidingSwitcherController slidingStateController;
  final Duration duration;
  final bool canChangeDirection;
  final Widget firstChild;

  final Widget? secondChild;
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
  late AnimationController _controller;

  late Animation<Offset> _translateOutAnimation;
  late Animation<Offset> _translateInAnimation;
  late Animation<double> _fadeOutAnimation;
  late Animation<double> _fadeInAnimation;

  late SlideOutDirection _direction;
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

  void _updateController() {
    widget.slidingStateController.addListener(this);

    // when changing the controller, we must accept the new direction
    _direction = widget.slidingStateController.direction;
    _updateAnimations();
  }

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
