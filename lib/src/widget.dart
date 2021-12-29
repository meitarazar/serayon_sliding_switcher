part of serayon_sliding_switcher;

class SlidingWidgetSwitcher extends StatefulWidget {
  final Duration duration;
  final Widget firstChild;
  final Widget secondChild;
  final bool canChangeDirection;
  final SlideOutDirection direction;
  final SlidingSwitcherController slidingStateController;

  const SlidingWidgetSwitcher({
    Key? key,
    required this.duration,
    required this.firstChild,
    Widget? secondChild,
    this.canChangeDirection = true,
    required this.direction,
    required this.slidingStateController,
  })  : secondChild = secondChild ?? const SizedBox(),
        super(key: key);

  @override
  State<SlidingWidgetSwitcher> createState() => _SlidingWidgetSwitcherState();
}

class _SlidingWidgetSwitcherState extends State<SlidingWidgetSwitcher> with SingleTickerProviderStateMixin, SlidingSwitcherListener {
  late AnimationController controller;

  late Animation<Offset> translateOutAnimation;
  late Animation<Offset> translateInAnimation;
  late Animation<double> fadeOutAnimation;
  late Animation<double> fadeInAnimation;

  void initAnimations(SlideOutDirection direction) => WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        if (!mounted) return;

        Offset outOffset = _calcOutOffset(context, direction);

        translateOutAnimation = Tween(begin: Offset.zero, end: outOffset).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
          ),
        );

        translateInAnimation = Tween(begin: outOffset, end: Offset.zero).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
          ),
        );
      });

  void animateToNone() {
    if (controller.value > 0.5) {
      controller.animateBack(0.5, duration: widget.duration);
    } else {
      controller.animateTo(0.5, duration: widget.duration);
    }
  }

  @override
  void onChangedState(SliderState newState) {
    switch (controller.status) {
      case AnimationStatus.completed:
      case AnimationStatus.forward:
        if (newState == SliderState.none) {
          animateToNone();
        } else if (newState == SliderState.first) {
          controller.animateBack(0.0, duration: widget.duration);
        }
        break;
      case AnimationStatus.dismissed:
      case AnimationStatus.reverse:
        if (newState == SliderState.none) {
          animateToNone();
        } else if (newState == SliderState.second) {
          controller.animateTo(1.0, duration: widget.duration);
        }
        break;
    }
  }

  @override
  void onChangeDirection(SlideOutDirection newDirection) {
    if (widget.canChangeDirection) {
      initAnimations(newDirection);
    }
  }

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..addListener(() => setState(() {}));

    translateOutAnimation = ConstantTween(Offset.zero).animate(controller);
    translateInAnimation = ConstantTween(Offset.zero).animate(controller);

    fadeOutAnimation = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    fadeInAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    widget.slidingStateController._registerListener(this);

    super.initState();

    initAnimations(widget.direction);
  }

  @override
  void didUpdateWidget(covariant SlidingWidgetSwitcher oldWidget) {
    if (widget.direction != oldWidget.direction) initAnimations(widget.direction);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.slidingStateController._removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform.translate(
          offset: translateOutAnimation.value,
          child: Opacity(
            opacity: fadeOutAnimation.value,
            child: widget.firstChild,
          ),
        ),
        Transform.translate(
          offset: translateInAnimation.value,
          child: Opacity(
            opacity: fadeInAnimation.value,
            child: widget.secondChild,
          ),
        ),
      ],
    );
  }
}
