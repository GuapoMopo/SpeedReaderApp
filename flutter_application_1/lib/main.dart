import 'package:flutter/material.dart';

void main() {
  runApp(Nav2App());
}

class Nav2App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.deepOrange,
          accentColor: Colors.deepOrange,
          backgroundColor: Colors.black),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SpeedReader"),
        backgroundColor: Colors.red[900],
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ButtonTheme(
              //isnt changing size and i don't know why
              minWidth: 200.0,
              height: 100.0,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red[900])),
                child: Text('Begin Reading'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return BeginReadingScreen();
                    }),
                  );
                },
              )),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.red[900])),
            child: Text('Progress'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return Progress();
                }),
              );
            },
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.red[900])),
            child: Text('Import Custom Text'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return ImportCustomText();
                }),
              );
            },
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.red[900])),
            child: Text('Saved Text'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return SavedText();
                }),
              );
            },
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.red[900])),
            child: Text('Settings'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return Settings();
                }),
              );
            },
          ),
        ],
      )),
    );
  }
}

class BeginReadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Begin Reading"),
        backgroundColor: Colors.red[900],
      ),
      body: Center(child: UpdateText()),
    );
  }
}

class Progress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Begin Reading"),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Back'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

class ImportCustomText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          child: Text('Pop2!'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

class SavedText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          child: Text('Pop2!'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          child: Text('Pop2!'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

class UpdateText extends StatefulWidget {
  //if you spam click, it creates multiple instances and overlaps
  UpdateTextState createState() => UpdateTextState();
}

class UpdateTextState extends State {
  String blank = '';
  String textHolder =
      "She had come to the conclusion that you could tell a lot about a person by their ears. The way they stuck out and the size of the earlobes could give you wonderful insights into the person. Of course, she couldn't scientifically prove any of this, but that didn't matter to her. Before anything else, she would size up the ears of the person she was talking to.";

  changeText() async {
    var list = textHolder.split(" ");
    for (var item in list) {
      setState(() {
        blank = item;
      });
      // ignore: unnecessary_statements
      (await new Future.delayed(
          const Duration(milliseconds: 200))); //control the wpm
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(children: <Widget>[
      Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Text('$blank', style: TextStyle(fontSize: 21))),
      ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.red[900])),
          onPressed: () =>
              changeText(), //will probably have to pass in wpm specified here
          child: const Text("READ")),
    ])));
  }
}
