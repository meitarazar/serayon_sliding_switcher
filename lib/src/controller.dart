part of serayon_sliding_switcher;

class SlidingSwitcherController {
  SliderState _state;
  SlideOutDirection _direction;
  final List<SlidingSwitcherListener> _listeners;

  SlidingSwitcherController({SliderState initState = SliderState.first, SlideOutDirection initDirection = SlideOutDirection.start})
      : _state = initState,
        _direction = initDirection,
        _listeners = [];

  SliderState get state => _state;

  set state(SliderState state) {
    SliderState oldState = _state;
    _state = state;

    _updateStateListeners(oldState);
  }

  SlideOutDirection get direction => _direction;

  set direction(SlideOutDirection direction) {
    SlideOutDirection oldDirection = _direction;
    _direction = direction;

    _updateDirectionListeners(oldDirection);
  }

  void addListener(SlidingSwitcherListener listener) {
    _listeners.add(listener);
  }

  void removeListener(SlidingSwitcherListener listener) {
    _listeners.remove(listener);
  }

  void _updateStateListeners(SliderState oldState) {
    for (var listener in _listeners) {
      listener.onChangedState(oldState, state);
    }
  }

  void _updateDirectionListeners(SlideOutDirection oldDirection) {
    for (var listener in _listeners) {
      listener.onChangeDirection(oldDirection, direction);
    }
  }

  SliderState toggleState() => state == SliderState.first ? state = SliderState.second : state = SliderState.first;
}
