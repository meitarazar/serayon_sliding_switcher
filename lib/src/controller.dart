part of serayon_sliding_switcher;

class SlidingSwitcherController {
  SliderState _state;
  final List<SlidingSwitcherListener> _listeners;

  SlidingSwitcherController({SliderState state = SliderState.first})
      : _state = state,
        _listeners = [];

  SliderState get state => _state;

  set state(SliderState state) {
    _state = state;
    _updateStateListeners();
  }

  void _registerListener(SlidingSwitcherListener listener) {
    _listeners.add(listener);
  }

  void _removeListener(SlidingSwitcherListener listener) {
    _listeners.remove(listener);
  }

  void _updateStateListeners() {
    for (var listener in _listeners) {
      listener.onChangedState(state);
    }
  }

  void onChangeDirection(SlideOutDirection direction) {
    for (var listener in _listeners) {
      listener.onChangeDirection(direction);
    }
  }

  SliderState toggleState() => state == SliderState.first ? state = SliderState.second : state = SliderState.first;
}