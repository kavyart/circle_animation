import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        textTheme: GoogleFonts.staatlichesTextTheme(
            Theme.of(context).textTheme
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.teal,
          shadowColor: Colors.tealAccent,
          elevation: 100,
          titleTextStyle: GoogleFonts.staatliches(
            fontSize: 50,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Colors.white,
            backgroundColor: Colors.teal.shade800,
            shadowColor: Colors.tealAccent,
            elevation: 50,
            textStyle: GoogleFonts.staatliches(
              fontSize: 25,
            ),
            minimumSize: Size(200, 50),
          ),
        ),
      ),
      home: Homepage(),
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
      appBar: AppBar(
          toolbarHeight: 150,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(100),
            ),
          ),
          title: Text(
            'Circle Animation',
            style: GoogleFonts.staatliches(fontSize: 50),
          ),
      ),
      body: InkWell(
        onTap: () => _pressInput?.value = true,
        child: Center(
          child: Hero(
            tag: 'circle',
            child: Rive(
              artboard: _riveArtboard!,
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
  String name = '';

  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(100),
          ),
        ),
        title: Text(
          name != '' ? "$name's Home Page" : "Home Page",
          style: GoogleFonts.staatliches(fontSize: 50),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          // Text Field
          TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Enter Name Here",
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

            controller: _controller,
            onSubmitted: (String value) async {
              setState(() {
                name = value;
              });
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Hello!'),
                    content: Text(
                        'Welcome to your app ${_controller.text}!'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),

          // Spacing
          SizedBox(
            height: 15,
          ),

          // Start/Stop Button
          TextButton(
            onPressed: () {
              setState(() {
                name = _controller.text.toString();
              });
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Hello!'),
                    content: Text(
                        'Welcome to your app ${_controller.text}!'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text("Name Entered"),
          ),

          // Spacing
          SizedBox(
            height: 50,
          ),

          // Go to circle animation
          Container(
            height: 200,
            width: 200,
            child: GestureDetector(
              onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return PlayAnimation();
                  }));
              },
              child: Hero(
                  tag: 'circle',
                  child: RiveAnimation.asset(
                    'assets/flutter_circle.riv',
                    animations: ['Full Turn'],
                  ),
              ),
            ),
          ),
          // Spacing
          SizedBox(
            height: 15,
          ),
          TextButton(
            child: Text('Open Animation'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PlayAnimation()),
              );
            },
          )
        ],
      ),
    );
  }
}
