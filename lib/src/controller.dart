part of serayon_sliding_switcher;

/// Controls a sliding switcher widget.
///
/// A single controller can be used to control multiple sliding widgets,
/// and typically stored as member variables in [State] objects.
///
/// A sliding switcher controller holds the current state of the
/// [SliderState] and [SlideOutDirection] values for all of the managed widgets,
/// and notifies them for each change of the [state] and [direction] values separately.
///
/// You can listen to those change events too by implementing the
/// [SlidingSwitcherListener] interface and register your listener using [addListener].
/// To remove a listener simply use [removeListener].
///
/// The [toggleState] method has a single purpose, to toggle between [SliderState.first]
/// and [SliderState.second], if the current state is [SliderState.none] the state will
/// be set to be [SliderState.first].
class SlidingSwitcherController {
  SliderState _state;
  SlideOutDirection _direction;
  final List<SlidingSwitcherListener> _listeners;

  /// Creates a [SlidingSwitcherController] with a default [SliderState.first] and a [SlideOutDirection.start].
  SlidingSwitcherController({SliderState initState = SliderState.first, SlideOutDirection initDirection = SlideOutDirection.start})
      : _state = initState,
        _direction = initDirection,
        _listeners = [];

  /// On value read, get the current [SliderState] value.
  ///
  /// On value write, set a new [SliderState] value and update all managed widgets and listeners.
  SliderState get state => _state;

  set state(SliderState state) {
    SliderState oldState = _state;
    _state = state;

    _updateStateListeners(oldState);
  }

  /// On value read, get the current [SlideOutDirection] value.
  ///
  /// On value write, set a new [SlideOutDirection] value and update all managed widgets and listeners.
  SlideOutDirection get direction => _direction;

  set direction(SlideOutDirection direction) {
    SlideOutDirection oldDirection = _direction;
    _direction = direction;

    _updateDirectionListeners(oldDirection);
  }

  /// Adds a listener for [state] and [direction] value changes of this controller.
  void addListener(SlidingSwitcherListener listener) {
    _listeners.add(listener);
  }

  /// Removes the given listener from this controller.
  void removeListener(SlidingSwitcherListener listener) {
    _listeners.remove(listener);
  }

  /// Updates all the listeners with the old and new values of the [SliderState].
  void _updateStateListeners(SliderState oldState) {
    for (var listener in _listeners) {
      listener.onChangedState(oldState, state);
    }
  }

  /// Updates all the listeners with the old and new values of the [SlideOutDirection].
  void _updateDirectionListeners(SlideOutDirection oldDirection) {
    for (var listener in _listeners) {
      listener.onChangeDirection(oldDirection, direction);
    }
  }

  /// Toggles between [SliderState.first] and [SliderState.second] value of this controller,
  /// if the current [state] value is [SliderState.none] the [state] will be set to [SliderState.first].
  ///
  /// After updating the [state] value notifying all managed widgets and listeners.
  SliderState toggleState() => state == SliderState.first ? state = SliderState.second : state = SliderState.first;
}
