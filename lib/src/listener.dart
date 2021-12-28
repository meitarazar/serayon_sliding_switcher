part of serayon_sliding_switcher;

abstract class SlidingSwitcherListener {
  void onChangedState(SliderState newState);

  void onChangeDirection(SlideOutDirection newDirection);
}