part of serayon_sliding_switcher;

class SlidingSwitcherWidget extends StatefulWidget {
  final SlidingSwitcherController slidingStateController;
  final Duration duration;
  final bool canChangeDirection;
  final Widget firstChild;
  final Widget secondChild;

  const SlidingSwitcherWidget({
    Key? key,
    required this.slidingStateController,
    this.duration = const Duration(milliseconds: 350),
    this.canChangeDirection = true,
    required this.firstChild,
    Widget? secondChild,
  })  : secondChild = secondChild ?? const SizedBox(),
        super(key: key);

  @override
  State<SlidingSwitcherWidget> createState() => _SlidingSwitcherWidgetState();
}

class _SlidingSwitcherWidgetState extends State<SlidingSwitcherWidget> with SingleTickerProviderStateMixin, SlidingSwitcherListener {
  late AnimationController _controller;

  late Animation<Offset> _translateOutAnimation;
  late Animation<Offset> _translateInAnimation;
  late Animation<double> _fadeOutAnimation;
  late Animation<double> _fadeInAnimation;

  void _updateAnimations() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (!mounted) return;

      Offset outOffset = _calcOutOffset(context, widget.slidingStateController.direction);

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
    _updateAnimations();
  }

  void _animateToTarget(double target) {
    if (_controller.value > target) {
      _controller.animateBack(target, duration: widget.duration);
    } else {
      _controller.animateTo(target, duration: widget.duration);
    }
  }

  @override
  void onChangedState(SliderState oldState, SliderState newState) {
    if (oldState == newState) return;

    switch (newState) {
      case SliderState.none:
        _animateToTarget(0.5);
        break;
      case SliderState.first:
        _animateToTarget(0.0);
        break;
      case SliderState.second:
        _animateToTarget(1.0);
        break;
    }
  }

  @override
  void onChangeDirection(SlideOutDirection oldDirection, SlideOutDirection newDirection) {
    if (widget.canChangeDirection) {
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
      oldWidget.slidingStateController.removeListener(this);
      _updateController();
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
