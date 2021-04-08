import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
//import 'package:flutter_mobile_vision/flutter_mobile_vision.dart'; //tried using and it just wasnt that great
import 'dart:io' as Io;
import 'package:http/http.dart' as http;
//import 'package:path/path.dart' as p;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

// Obtain a list of the available cameras on the device.
  //final cameras = await availableCameras();
  //final firstCamera = cameras.first;
  runApp(MainScreen());
}

class MainScreen extends StatelessWidget {
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
                  return ContinueProgress();
                }),
              );
            },
          ),
          /*
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
          */
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
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red[900])),
              child: Text('Continue Progress'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ContinueProgress();
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
          ],
        )));
  }
}

class BeginReadingScreenReal extends StatelessWidget {
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

class SavedText extends StatefulWidget {
  @override
  _SavedText createState() => _SavedText();
}

final List<String> savedTexts = <String>["Page 1"];
final List<String> savedTextParagraphs = <String>[
  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
];

class _SavedText extends State {
  TextEditingController nameController = TextEditingController();

  void addItemToList(String itemToAdd, String paragraph) {
    setState(() {
      savedTexts.add(itemToAdd);
      savedTextParagraphs.add(paragraph);
    });
    print(savedTextParagraphs);
  }

  void deleteItemFromList(String value) {
    setState(() {
      savedTexts.remove(value);
      savedTextParagraphs.remove(value);
    });
  }

  String parsedText = '';

  Future<String> openCamera() async {
    print("Camera");
    //File _image;
    final picker = ImagePicker();
    PickedFile image = await picker.getImage(
        source: ImageSource.camera, maxWidth: 670, maxHeight: 970);
    final Io.File imageFile = Io.File(image.path);
    var bytes = Io.File(imageFile.path.toString()).readAsBytesSync();
    String img64 = base64Encode(bytes);
    var url = Uri.parse('https://api.ocr.space/parse/image');
    var payload = {"base64Image": "data:image/jpg;base64,${img64.toString()}"};
    var header = {"apikey": "dddeb6dd7b88957"};
    var post = await http.post(url = url, body: payload, headers: header);
    var result = jsonDecode(post.body);
    parsedText = result['ParsedResults'][0]['ParsedText'];
    print(parsedText);
    return parsedText;
  }

  Future<String> openGallery() async {
    //instead of using an api call website, tesseractOcr looks good too
    print("Gallery");

    //var gallery = await ImagePicker.getImage( /// old api
    //  source: ImageSource.gallery,
    //);
    PickedFile image = await ImagePicker().getImage(
        source: ImageSource.gallery, maxWidth: 670, maxHeight: 970); //new api
    final Io.File imageFile = Io.File(image.path);
    var bytes = Io.File(imageFile.path.toString()).readAsBytesSync();
    String img64 = base64Encode(bytes);
    var url = Uri.parse('https://api.ocr.space/parse/image');
    var payload = {"base64Image": "data:image/jpg;base64,${img64.toString()}"};
    var header = {"apikey": "dddeb6dd7b88957"};
    var post = await http.post(url = url, body: payload, headers: header);
    var result = jsonDecode(post.body);
    parsedText = await result['ParsedResults'][0]['ParsedText'];
    //print(parsedText);
    return parsedText.toString();
  }

  Future<void> _showMenu(int pos) async {
    int selected = await showMenu(
      position: RelativeRect.fromLTRB(100, 100.0, 100.0, 100.0),
      context: context,
      items: [
        PopupMenuItem(
          value: 0,
          child: Row(
            children: [
              Icon(Icons.edit),
              Text("Edit"),
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.delete),
              Text("Delete"),
            ],
          ),
        ),
      ],
    );
    if (selected == 0) {
      print('handle edit');
    } else {
      deleteItemFromList(savedTexts[pos]);
    }
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Input name'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: nameController,
              decoration: InputDecoration(hintText: "Page 1"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text("Okay"),
                onPressed: () async {
                  codeDialog = valueText;
                  Navigator.pop(context);
                  textString = await openGallery();
                  print(textString);
                  addItemToList(codeDialog, textString);
                },
              )
            ],
          );
        });
  }

  String codeDialog;
  String valueText;
  String textString;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text("Saved Text"), backgroundColor: Colors.red[900]),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: savedTexts.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 50,
                  margin: EdgeInsets.all(2),
                  child: Center(
                    child: ListTile(
                      title: Text('${savedTexts[index]}'),
                      onTap: () {
                        print(index);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return UpdateText(
                              textIndex: index,
                            ); //right now they all go home screen so but
                            //they should go to read screen with the proper text located at savedText[index]
                          }),
                        );
                      },
                      onLongPress: () => {_showMenu(index)},
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.red[900],
        onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      GestureDetector(
                          child: Text('Take a picture'),
                          onTap: () async {
                            Navigator.of(context).pop();

                            var textString = await openCamera();
                            print(textString);
                          }),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                      ),
                      GestureDetector(
                        child: Text('Select from gallery'),
                        onTap: () async {
                          Navigator.of(context).pop();
                          await _displayTextInputDialog(context);
                          // var textString = await openGallery();
                          print("Right before");
                          print(textString);
                          print(codeDialog);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}

class ContinueProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Progress"),
          backgroundColor: Colors.red[900],
        ),
        body: ListView(children: <Widget>[
          ListTile(
            leading: Icon(Icons.note),
            title: Text('Level 1'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return UpdateTextProgress(
                  textIndex: 0,
                );
              }),
            ),
          ),
          ListTile(
            leading: Icon(Icons.note),
            title: Text('Level 2'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return UpdateTextProgress(
                  textIndex: 1,
                );
              }),
            ),
          ),
          ListTile(
            leading: Icon(Icons.note),
            title: Text('Level 3'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return UpdateTextProgress(
                  textIndex: 2,
                );
              }),
            ),
          ),
          ListTile(
            leading: Icon(Icons.note),
            title: Text('Level 4'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return UpdateTextProgress(
                  textIndex: 3,
                );
              }),
            ),
          ),
          ListTile(
            leading: Icon(Icons.note),
            title: Text('Level 5'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return UpdateTextProgress(
                  textIndex: 4,
                );
              }),
            ),
          ),
          ListTile(
            leading: Icon(Icons.note),
            title: Text('Level 6'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return UpdateTextProgress(
                  textIndex: 5,
                );
              }),
            ),
          ),
          ListTile(
            leading: Icon(Icons.note),
            title: Text('Level 7'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return UpdateTextProgress(
                  textIndex: 6,
                );
              }),
            ),
          ),
          ListTile(
            leading: Icon(Icons.note),
            title: Text('Level 8'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return UpdateTextProgress(
                  textIndex: 7,
                );
              }),
            ),
          ),
          ListTile(
            leading: Icon(Icons.note),
            title: Text('Level 9'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return UpdateTextProgress(
                  textIndex: 8,
                );
              }),
            ),
          ),
          ListTile(
            leading: Icon(Icons.note),
            title: Text('Level 10'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return UpdateTextProgress(
                  textIndex: 9,
                );
              }),
            ),
          ),
          ListTile(
            leading: Icon(Icons.note),
            title: Text('Level 11'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return UpdateTextProgress(
                  textIndex: 10,
                );
              }),
            ),
          ),
          ListTile(
            leading: Icon(Icons.note),
            title: Text('Level 12'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return UpdateTextProgress(
                  textIndex: 11,
                );
              }),
            ),
          ),
        ]));
  }
}

/*
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
*/
/*
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
*/

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Text('Settings'), backgroundColor: Colors.red[900]),
        //backgroundColor: Colors.grey,
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
                  child: Text('Day/Night Mode'),
                  onPressed: () {
                    //doesn't do anything
                  },
                )),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red[900])),
                child: Text('Language'),
                onPressed: () {
                  //doesn't do anything
                }),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red[900])),
              child: Text('FontSize'),
              onPressed: () {
                //doesn't do anything
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red[900])),
              child: Text('Social'),
              onPressed: () {
                //doesn't do anything
              },
            )
          ],
        )));
  }
}

class UpdateTextProgress extends StatefulWidget {
  final int textIndex;
  UpdateTextProgress({Key key, @required this.textIndex}) : super(key: key);
  //if you spam click, it creates multiple instances and overlaps
  UpdateTextStateProgress createState() =>
      UpdateTextStateProgress(textIndex2: textIndex);
}

class UpdateTextStateProgress
    extends State //this is for progress, so it'll be hardcoded
    with
        SingleTickerProviderStateMixin {
  final int textIndex2;
  UpdateTextStateProgress({Key key, @required this.textIndex2});
  String blank = '';
  String textHolder;
  int actualWPM = 150;

  changeTextTest(String item) {
    setState(() {
      blank = item;
    });
  }

  AnimationController controller;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void playPauseChange() {
    setState(() {
      isPlaying = !isPlaying;
      isPlaying ? controller.forward() : controller.reverse();
    });
  }

  bool isChanging = true;
  bool lockInstance = false;
  bool firstClick = false;
  bool rewindSave = false;
  int savedSpot = 0;
  int wpm;
  var list = [
    'These reflections have dispelled the agitation with which I began my letter, and I feel my heart glow with an enthusiasm which elevates me to heaven, for nothing contributes so much to tranquillise the mind as a steady purpose—a point on which the soul may fix its intellectual eye. This expedition has been the favourite dream of my early years. I have read with ardour the accounts of the various voyages which have been made in the prospect of arriving at the North Pacific Ocean through the seas which surround the pole. You may remember that a history of all the voyages made for purposes of discovery composed the whole of our good Uncle Thomas’ library. My education was neglected, yet I was passionately fond of reading. These volumes were my study day and night, and my familiarity with them increased that regret which I had felt, as a child, on learning that my father’s dying injunction had forbidden my uncle to allow me to embark in a seafaring life. ',
    'Mr. Bennet was so odd a mixture of quick parts, sarcastic humour, reserve, and caprice, that the experience of three-and-twenty years had been insufficient to make his wife understand his character. Her mind was less difficult to develop. She was a woman of mean understanding, little information, and uncertain temper. When she was discontented, she fancied herself nervous. The business of her life was to get her daughters married; its solace was visiting and news. ',
    'Not all that Mrs. Bennet, however, with the assistance of her five daughters, could ask on the subject, was sufficient to draw from her husband any satisfactory description of Mr. Bingley. They attacked him in various ways—with barefaced questions, ingenious suppositions, and distant surmises; but he eluded the skill of them all, and they were at last obliged to accept the second-hand intelligence of their neighbour, Lady Lucas. Her report was highly favourable. Sir William had been delighted with him. He was quite young, wonderfully handsome, extremely agreeable, and, to crown the whole, he meant to be at the next assembly with a large party. Nothing could be more delightful! To be fond of dancing was a certain step towards falling in love; and very lively hopes of Mr. Bingley’s heart were entertained.',
    'My family have been prominent, well-to-do people in this Middle Western city for three generations. The Carraways are something of a clan, and we have a tradition that we’re descended from the Dukes of Buccleuch, but the actual founder of my line was my grandfather’s brother, who came here in fifty-one, sent a substitute to the Civil War, and started the wholesale hardware business that my father carries on today. ',
    'The practical thing was to find rooms in the city, but it was a warm season, and I had just left a country of wide lawns and friendly trees, so when a young man at the office suggested that we take a house together in a commuting town, it sounded like a great idea. He found the house, a weather-beaten cardboard bungalow at eighty a month, but at the last minute the firm ordered him to Washington, and I went out to the country alone. I had a dog—at least I had him for a few days until he ran away—and an old Dodge and a Finnish woman, who made my bed and cooked breakfast and muttered Finnish wisdom to herself over the electric stove. ',
    'It was the best of times, it was the worst of times, it was the age of wisdom, it was the age of foolishness, it was the epoch of belief, it was the epoch of incredulity, it was the season of Light, it was the season of Darkness, it was the spring of hope, it was the winter of despair, we had everything before us, we had nothing before us, we were all going direct to Heaven, we were all going direct the other way—in short, the period was so far like the present period, that some of its noisiest authorities insisted on its being received, for good or for evil, in the superlative degree of comparison only. ',
    'There were a king with a large jaw and a queen with a plain face, on the throne of England; there were a king with a large jaw and a queen with a fair face, on the throne of France. In both countries it was clearer than crystal to the lords of the State preserves of loaves and fishes, that things in general were settled for ever. ',
    'With drooping heads and tremulous tails, they mashed their way through the thick mud, floundering and stumbling between whiles, as if they were falling to pieces at the larger joints. As often as the driver rested them and brought them to a stand, with a wary “Wo-ho! so-ho-then!” the near leader violently shook his head and everything upon it—like an unusually emphatic horse, denying that the coach could be got up the hill. Whenever the leader made this rattle, the passenger started, as a nervous passenger might, and was disturbed in mind.',
    'So she was considering in her own mind (as well as she could, for the hot day made her feel very sleepy and stupid), whether the pleasure of making a daisy-chain would be worth the trouble of getting up and picking the daisies, when suddenly a White Rabbit with pink eyes ran close by her. ',
    'Alice was not a bit hurt, and she jumped up on to her feet in a moment: she looked up, but it was all dark overhead; before her was another long passage, and the White Rabbit was still in sight, hurrying down it. There was not a moment to be lost: away went Alice like the wind, and was just in time to hear it say, as it turned a corner, “Oh my ears and whiskers, how late it’s getting!” She was close behind it when she turned the corner, but the Rabbit was no longer to be seen: she found herself in a long, low hall, which was lit up by a row of lamps hanging from the roof. ',
    'Suddenly she came upon a little three-legged table, all made of solid glass; there was nothing on it except a tiny golden key, and Alice’s first thought was that it might belong to one of the doors of the hall; but, alas! either the locks were too large, or the key was too small, but at any rate it would not open any of them. However, on the second time round, she came upon a low curtain she had not noticed before, and behind it was a little door about fifteen inches high: she tried the little golden key in the lock, and to her great delight it fitted! ',
    'Alice opened the door and found that it led into a small passage, not much larger than a rat-hole: she knelt down and looked along the passage into the loveliest garden you ever saw. How she longed to get out of that dark hall, and wander about among those beds of bright flowers and those cool fountains, but she could not even get her head through the doorway; “and even if my head would go through,” thought poor Alice, “it would be of very little use without my shoulders. Oh, how I wish I could shut up like a telescope! I think I could, if I only knew how to begin.” For, you see, so many out-of-the-way things had happened lately, that Alice had begun to think that very few things indeed were really impossible. '
  ];
  var wpmListTime = <int>[
    600, //100wpm
    400, //150wpm
    300, //200wpm
    240, //250wpm
    200, //300wpm
    171, //350wpm
    150, //400wpm
    133, //450wpm
    120, //500wpm
    109, //550wpm
    100, //600wpm
    92, //650wpm
  ];
  var wpmList = <String>[
    '100 WPM',
    '150 WPM',
    '200 WPM',
    '250 WPM',
    '300 WPM',
    '350 WPM',
    '400 WPM',
    '450 WPM',
    '500 WPM',
    '550 WPM',
    '600 WPM',
    '650 WPM'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: Text("Saved Text"),
          backgroundColor: Colors.red[900],
        ),
        body: Center(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: Column(children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 250.0,
                color: Colors.red[900],
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '$blank',
                    style: TextStyle(fontSize: 60),
                  ),
                ),
              ),
              Row(
                  //EmainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      iconSize: 100,
                      icon: Icon(Icons.fast_rewind_outlined),
                      onPressed: () async {
                        rewindSave = true;
                        print(savedSpot);
                        if (savedSpot != 0 && savedSpot - 2 > 0) {
                          print("REWIND");
                          //rewind word functionality
                          savedSpot = savedSpot - 2;
                          await changeTextTest(list[savedSpot]);
                          print(lockInstance);
                          isChanging = true;
                        }
                        rewindSave = false;
                      },
                    ),
                    IconButton(
                      iconSize: 100,
                      icon: Icon(isPlaying
                          ? Icons.pause_outlined
                          : Icons.play_arrow_outlined),
                      onPressed: () async {
                        var textPara = list[textIndex2];
                        textPara = textPara.replaceAll("\n", " ");
                        list = textPara.split(
                          " ",
                        );
                        if (firstClick == true) isChanging = false;
                        //this will lock it so it doesn't create another instance and will reset when it's done displaying
                        if (lockInstance == false) {
                          firstClick = true;
                          print("HERE");
                          playPauseChange();
                          print("playpause");
                          for (var i = savedSpot; i < list.length; i++) {
                            print("outside");
                            if (isChanging == true) {
                              print("inside");
                              await changeTextTest(list[i]);
                              // ignore: unnecessary_statements
                              (await new Future.delayed(Duration(
                                  milliseconds: wpmListTime[textIndex2])));
                              //sleep(Duration(milliseconds: 200));
                            } else if (isChanging == false) {
                              print("isChanging");
                              print(rewindSave);
                              if (rewindSave == false) savedSpot = i;
                              //savedSpot = i;
                              lockInstance = false;
                              firstClick = false;
                              isChanging = true;
                              rewindSave = false;
                              break; // if you spam click, then it can't hit the break fast enough and won't pause
                            }
                            lockInstance = true;
                          }
                          lockInstance = false;
                          firstClick = false;
                          playPauseChange();
                        }
                      },
                    ),
                    new Text(
                      wpmList[textIndex2],
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                    /*  new DropdownButton<String>(
                      hint: new Text("Select a WPM",
                          style: TextStyle(fontSize: 25)),
                      value: wpm == null ? null : wpmList[wpm],
                      items: wpmList.map((String value) {
                        return new DropdownMenuItem(
                          value: value,
                          child: new Text(
                            value,
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          wpm = wpmList.indexOf(value);
                          actualWPM = (int.parse(value.split(" ")[0]));
                          double temp = (60 / actualWPM) * 1000;
                          actualWPM = temp.toInt();
                          print(actualWPM);
                        });
                      },
                    )*/
                  ])
            ])));
  }
}

class UpdateText extends StatefulWidget {
  final int textIndex;
  UpdateText({Key key, @required this.textIndex}) : super(key: key);
  //if you spam click, it creates multiple instances and overlaps
  UpdateTextState createState() => UpdateTextState(textIndex2: textIndex);
}

bool yesOrNo = false;

class UpdateTextState extends State with SingleTickerProviderStateMixin {
  final int textIndex2;
  UpdateTextState({Key key, @required this.textIndex2});
  String blank = '';
  String textHolder;
  int actualWPM = 150;

  changeTextTest(String item) {
    setState(() {
      blank = item;
    });
  }

  AnimationController controller;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void playPauseChange() {
    setState(() {
      isPlaying = !isPlaying;
      isPlaying ? controller.forward() : controller.reverse();
    });
  }

  bool isChanging = true;
  bool lockInstance = false;
  bool firstClick = false;
  bool rewindSave = false;
  int savedSpot = 0;
  int wpm;
  var list = [];
  var wpmList = <String>[
    '100 WPM',
    '150 WPM',
    '200 WPM',
    '250 WPM',
    '300 WPM',
    '350 WPM',
    '400 WPM',
    '450 WPM',
    '500 WPM',
    '550 WPM',
    '600 WPM',
    '650 WPM',
    '700 WPM',
    '750 WPM',
    '800 WPM'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: Text("Saved Text"),
          backgroundColor: Colors.red[900],
        ),
        body: Center(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: Column(children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 250.0,
                color: Colors.red[900],
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '$blank',
                    style: TextStyle(fontSize: 60),
                  ),
                ),
              ),
              Row(
                  //EmainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      iconSize: 100,
                      icon: Icon(Icons.fast_rewind_outlined),
                      onPressed: () async {
                        rewindSave = true;
                        print(savedSpot);
                        if (savedSpot != 0 && savedSpot - 2 > 0) {
                          print("REWIND");
                          //rewind word functionality
                          savedSpot = savedSpot - 2;
                          await changeTextTest(list[savedSpot]);
                          print(lockInstance);
                          isChanging = true;
                        }
                        rewindSave = false;
                      },
                    ),
                    IconButton(
                      iconSize: 100,
                      icon: Icon(isPlaying
                          ? Icons.pause_outlined
                          : Icons.play_arrow_outlined),
                      onPressed: () async {
                        var textPara = savedTextParagraphs[textIndex2];
                        textPara = textPara.replaceAll("\n", " ");
                        list = textPara.split(
                          " ",
                        );
                        if (firstClick == true) isChanging = false;
                        //this will lock it so it doesn't create another instance and will reset when it's done displaying
                        if (lockInstance == false) {
                          firstClick = true;
                          print("HERE");
                          playPauseChange();
                          print("playpause");
                          for (var i = savedSpot; i < list.length; i++) {
                            print("outside");
                            if (isChanging == true) {
                              print("inside");
                              await changeTextTest(list[i]);
                              // ignore: unnecessary_statements
                              (await new Future.delayed(
                                  Duration(milliseconds: actualWPM)));
                              //sleep(Duration(milliseconds: 200));
                            } else if (isChanging == false) {
                              print("isChanging");
                              print(rewindSave);
                              if (rewindSave == false) savedSpot = i;
                              //savedSpot = i;
                              lockInstance = false;
                              firstClick = false;
                              isChanging = true;
                              rewindSave = false;
                              break; // if you spam click, then it can't hit the break fast enough and won't pause
                            }
                            lockInstance = true;
                          }
                          lockInstance = false;
                          firstClick = false;
                          playPauseChange();
                        }
                      },
                    ),
                    new DropdownButton<String>(
                      hint: new Text("Select a WPM",
                          style: TextStyle(fontSize: 25)),
                      value: wpm == null ? null : wpmList[wpm],
                      items: wpmList.map((String value) {
                        return new DropdownMenuItem(
                          value: value,
                          child: new Text(
                            value,
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          wpm = wpmList.indexOf(value);
                          actualWPM = (int.parse(value.split(" ")[0]));
                          double temp = (60 / actualWPM) * 1000;
                          actualWPM = temp.toInt();
                          print(actualWPM);
                        });
                      },
                    )
                  ])
            ])));
  }
}
