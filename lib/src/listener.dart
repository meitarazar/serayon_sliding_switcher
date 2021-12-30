part of serayon_sliding_switcher;

/// The [SlidingSwitcherListener] is used by the [SlidingSwitcherWidget] to get
/// updates from it's [SlidingSwitcherController] about the [state] and [direction]
/// value changes.
///
/// You can too implement this interface to listen for [state] and [direction]
/// change events of any [SlidingSwitcherController].
///
/// BUT BE AWARE!
///
/// This interface does not support caller identification, meaning, if you
/// listen to more than one controller you won't know from which controller
/// each call was made.
abstract class SlidingSwitcherListener {
  /// Notify about [SliderState] value change with the old and new values.
  void onChangedState(SliderState oldState, SliderState newState);

  /// Notify about [SlideOutDirection] value change with the old and new values.
  void onChangeDirection(SlideOutDirection oldDirection, SlideOutDirection newDirection);
}