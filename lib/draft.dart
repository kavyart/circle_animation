import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart';
import 'package:animation/main.dart';

void main() => runApp(AnimationApp());

class AnimationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.openSansTextTheme(
            Theme.of(context).textTheme
        ),
      ),
      home: PlayAnimation(),
    );
  }
}

class PlayAnimation extends StatefulWidget {
  const PlayAnimation({Key? key}) : super(key: key);

  @override
  _PlayAnimationState createState() => _PlayAnimationState();
}

class _PlayAnimationState extends State<PlayAnimation> {
  // control for playback
  //late RiveAnimationController _controller;
  Artboard? _riveArtboard;
  StateMachineController? _controller;
  SMIInput<bool>? _pressInput;

/*
  // toggle between play and pause animation states
  void _togglePlay() =>
      setState(() => _controller.isActive = !_controller.isActive);
*/

  // tracks if the animation is playing by whether controller is running
  bool get isPlaying => _controller?.isActive ?? false;

  @override
  void initState() {
    super.initState();

    rootBundle.load('assets/flutter_circle.riv').then(
          (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);

        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;
        var controller =
        StateMachineController.fromArtboard(artboard, 'Play');
        if (controller != null) {
          artboard.addController(controller);
          _pressInput = controller.findInput('Pressed');
        }
        setState(() => _riveArtboard = artboard);
      },
    );

    //_controller = SimpleAnimation('Idle');
  }

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RiveAnimation.asset(
          'assets/flutter_circle.riv',
          controllers: [_controller],
          // update the play state when the widget's initialized
          onInit: () => setState(() {}),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _togglePlay,
        tooltip: isPlaying ? 'Pause' : 'Play',
        child: Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text('Button State Machine'),
      ),
      body: Center(
        child: _riveArtboard == null
            ? const SizedBox()
            : MouseRegion(
          //onEnter: (_) => _hoverInput?.value = true,
          //onExit: (_) => _hoverInput?.value = false,
          child: GestureDetector(
            onTapDown: (_) => _pressInput?.value = true,
            //onTapCancel: () => _pressInput?.value = false,
            //onTapUp: (_) => _pressInput?.value = false,
            child: SizedBox(
              width: 250,
              height: 250,
              child: Rive(
                artboard: _riveArtboard!,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF111111),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          // Text Field
          TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "0",
              hintStyle: TextStyle(
                fontSize: 32,
                color: Colors.white.withAlpha(90),
              ),
            ),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              color: Colors.white,
            ),
          ),

          // Spacing
          SizedBox(
            height: 32,
          ),

          // Start/Stop Button
          TextButton(
            onPressed: () {},
            child: Text("Start Animation"),
          ),
        ],
      ),
    );
  }
}



/*
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class FlareDemo extends StatefulWidget {
  @override
  _FlareDemoState createState() => _FlareDemoState();
}

class _FlareDemoState extends State<FlareDemo> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () {
          setState(() {
            isOpen = !isOpen;
            print('on tap pressed');
          });
        },
        child: Center(
          child: FlareActor('assets/flutter_flare_new.flr',
              animation:
//              "circle"

              isOpen ? "actvate" : "deactivate"),
        ),
      ),
    );
  }
}*/
/*

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

void main() => runApp(WordCircleAnimation());

class WordCircleAnimation extends StatefulWidget {
  //const WordCircleAnimation({Key? key}) : super(key: key);
  @override
  _WordCircleAnimationState createState() => _WordCircleAnimationState();
}

class _WordCircleAnimationState extends State<WordCircleAnimation> {
  bool isOpen = false;

  /// Controller for playback
  late Artboard _riveArtboard;
  late RiveAnimationController _controller;
  late SMIInput? _pressInput;

  /// Toggles between play and pause animation states
  void _togglePlay() => _controller.isActive = !_controller.isActive;

  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/flutter_flare_new.riv').then(
          (data) async {
        final file = RiveFile.import(data);
        final board = file.mainArtboard;
        var controller =
        StateMachineController.fromArtboard(board, 'Play');
        if (controller != null) {
          board.addController(controller);
          _pressInput = controller.findInput('Press');
        }
        setState(() => _riveArtboard = board);
      },
    );
    _controller = SimpleAnimation('windshield_wipers');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Animation"),
      ),
      */
/*body: InkWell(
        onTap: () {
          setState(() {
            isOpen = !isOpen;
            print('on tap pressed');
          });
        },
        child: Center(
          child: RiveAnimation.network(
            'https://cdn.rive.app/animations/flutter_circle.riv',
            stateMachines: ['Play'],
            controllers: [_controller],
          ),
        ),
      ),*//*

    );

    //   body: Center(
    //     child: GestureDetector(
    //       onTap: _togglePlay,
    //       child: RiveAnimation.network(
    //         'https://cdn.rive.app/animations/vehicles.riv',
    //         artboard: 'Jeep',
    //         animations: ['idle'],
    //         controllers: [_controller],
    //         fit: BoxFit.cover,
    //       ),
    //     ),
    //   ),
    // );
  }
}*/
