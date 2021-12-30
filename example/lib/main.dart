import 'dart:async';

import 'package:example/home_controls.dart';
import 'package:flutter/material.dart';
import 'package:serayon_sliding_switcher/serayon_sliding_switcher.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sliding Switcher Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(title: 'Sliding Switcher Demo'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  final String title;

  const Home({Key? key, required this.title}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final SlidingSwitcherController _fabController = SlidingSwitcherController(
    initDirection: SlideOutDirection.left,
  );

  Timer? _timer;

  void nextDirection() {
    switch (_fabController.direction) {
      case SlideOutDirection.left:
        _fabController.direction = SlideOutDirection.up;
        break;
      case SlideOutDirection.up:
        _fabController.direction = SlideOutDirection.right;
        break;
      case SlideOutDirection.right:
        _fabController.direction = SlideOutDirection.down;
        break;
      case SlideOutDirection.down:
        _fabController.direction = SlideOutDirection.left;
        break;
      case SlideOutDirection.start:
      case SlideOutDirection.end:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _fabController.toggleState();
      nextDirection();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  _timer?.cancel();

                  // HomeControls is a page with buttons for you to try,
                  //   it is built to swap between states and directions manually.
                  // Go to the GitHub repo, under example/lib you'll find that page code
                  return HomeControls(title: widget.title);
                },
              ),
            ),
            icon: const Icon(Icons.tune),
          ),
        ],
      ),
      body: Center(
        child: SlidingSwitcherWidget(
          slidingStateController: _fabController,
          firstChild: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: ShapeDecoration(
              shape: const StadiumBorder(),
              color: Colors.amberAccent.shade700,
            ),
            child: const Text(
              'I\'m the first widget\'s child :D',
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
              'I\'m the second widget\'s child :P',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
