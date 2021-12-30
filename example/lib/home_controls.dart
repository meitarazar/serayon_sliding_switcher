import 'package:flutter/material.dart';
import 'package:serayon_sliding_switcher/serayon_sliding_switcher.dart';

class HomeControls extends StatefulWidget {
  final String title;

  const HomeControls({Key? key, required this.title}) : super(key: key);

  @override
  State<HomeControls> createState() => _HomeControlsState();
}

class _HomeControlsState extends State<HomeControls> with SlidingSwitcherListener {
  // this is
  final SlidingSwitcherController _fabController = SlidingSwitcherController(
    initDirection: SlideOutDirection.left,
  );

  void changeState(SliderState state) => _fabController.state = state;

  void changeDirection(SlideOutDirection direction) => _fabController.direction = direction;

  @override
  void onChangedState(SliderState oldState, SliderState newState) => setState(() {});

  @override
  void onChangeDirection(SlideOutDirection oldDirection, SlideOutDirection newDirection) => setState(() {});

  @override
  void initState() {
    _fabController.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    _fabController.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back)),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Text(
                'Change direction',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: FractionallySizedBox(
                widthFactor: 0.75,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    MyActionButton(
                      icon: Icons.arrow_left,
                      isActive: _fabController.direction == SlideOutDirection.left,
                      onPressed: () => changeDirection(SlideOutDirection.left),
                    ),
                    MyActionButton(
                      icon: Icons.arrow_drop_up,
                      isActive: _fabController.direction == SlideOutDirection.up,
                      onPressed: () => changeDirection(SlideOutDirection.up),
                    ),
                    MyActionButton(
                      icon: Icons.arrow_drop_down,
                      isActive: _fabController.direction == SlideOutDirection.down,
                      onPressed: () => changeDirection(SlideOutDirection.down),
                    ),
                    MyActionButton(
                      icon: Icons.arrow_right,
                      isActive: _fabController.direction == SlideOutDirection.right,
                      onPressed: () => changeDirection(SlideOutDirection.right),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 24.0),
              child: Text(
                'Change state',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: FractionallySizedBox(
                widthFactor: 0.75,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    MyElevatedButton(
                      text: 'None',
                      isActive: _fabController.state == SliderState.none,
                      onPressed: () => changeState(SliderState.none),
                    ),
                    MyElevatedButton(
                      text: 'First',
                      isActive: _fabController.state == SliderState.first,
                      onPressed: () => changeState(SliderState.first),
                    ),
                    MyElevatedButton(
                      text: 'Second',
                      isActive: _fabController.state == SliderState.second,
                      onPressed: () => changeState(SliderState.second),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 64.0),
              child: SlidingSwitcherWidget(
                slidingStateController: _fabController,
                firstChild: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  decoration: ShapeDecoration(
                    shape: const StadiumBorder(),
                    color: Colors.amberAccent.shade700,
                  ),
                  child: const Text(
                    'I\'m the first widget state :D',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                secondChild: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  decoration: ShapeDecoration(
                    shape: const StadiumBorder(),
                    color: Colors.deepOrangeAccent.shade700,
                  ),
                  child: const Text(
                    'I\'m the second widget state :P',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyActionButton extends StatelessWidget {
  final bool isActive;
  final IconData icon;
  final VoidCallback? onPressed;

  const MyActionButton({Key? key, required this.isActive, required this.icon, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Icon(
        icon,
        color: isActive ? Colors.black : Colors.white,
      ),
      style: ElevatedButton.styleFrom(
        primary: isActive ? Colors.amber : null,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(8.0),
      ),
      onPressed: onPressed,
    );
  }
}

class MyElevatedButton extends StatelessWidget {
  final bool isActive;
  final String text;
  final VoidCallback? onPressed;

  const MyElevatedButton({Key? key, required this.isActive, required this.text, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? Colors.black : null,
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: isActive ? Colors.amber : null,
      ),
      onPressed: onPressed,
    );
  }
}
