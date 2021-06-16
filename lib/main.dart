import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart';

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
  Artboard? _riveArtboard;
  StateMachineController? _controller;
  SMIInput<bool>? _pressInput;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey,
      body: InkWell(
        onTap: () => _pressInput?.value = true,
        child: Center(
          child: Rive(
            artboard: _riveArtboard!,
          ),
        ),
      ),
    );
  }

/*
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
  */
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
