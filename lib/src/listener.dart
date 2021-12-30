part of serayon_sliding_switcher;

abstract class SlidingSwitcherListener {
  void onChangedState(SliderState oldState, SliderState newState);

  void onChangeDirection(SlideOutDirection oldDirection, SlideOutDirection newDirection);
}