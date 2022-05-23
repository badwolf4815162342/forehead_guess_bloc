import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../design/fg_design.dart';
import '../design/fg_styles.dart';
import '../main.dart';
import '../models/deck.model.dart';

class DeckEditPage extends ConsumerStatefulWidget {
  static final routeName = (DeckEditPage).toString();

  const DeckEditPage({Key? key}) : super(key: key);

  @override
  ConsumerState<DeckEditPage> createState() => _DeckEditPageState();
}

class _DeckEditPageState extends ConsumerState<DeckEditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool autoValidate = true;
  bool readOnly = false;
  String _name = '';
  bool _loading = false;
  String _image = '';
  String _words = '';

  Future<bool> _onWillPop() async {
    return !(_loading);
  }

  void validateAndSave() {
    if (_formKey.currentState!.validate() || _loading) {
      setState(() {
        _loading = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
              FGText.subheading('Processing Data'),
              const CircularProgressIndicator(
                color: fgDarkColorLight,
                strokeWidth: 5,
              )
            ])),
      );
      Deck deck = ref.read(decksService).currentDeck;
      String newFilename = deck.fileName;
      if (deck.name == '') {
        newFilename = _name.replaceAll(' ', '_') + '.json';
      }
      Deck updatedDeck =
          Deck.fromWordsString(newFilename, _name, _image, _words);
      ref.read(decksService).updateCurrentDeck(updatedDeck).then((value) {
        setState(() {
          _loading = false;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Deck deck = ref.read(decksService).currentDeck;
    if (deck.name != '') {
      _name = deck.name;
      _image = deck.image;
      _words = deck.words.join(',');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            title: FGText.headingOne('Edit Deck'),
            backgroundColor: fgPrimaryColor,
          ),
          backgroundColor: fgBrightColorLight,
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(children: <Widget>[
                Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        FGText.settingsHeading('Deckname:'),
                        TextFormField(
                          style: settingsStyle,
                          cursorColor: fgBrightColor,
                          initialValue: _name,
                          validator: (value) {
                            RegExp regExp = RegExp(r'^[a-zA-Z0-9 _]*$');

                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            if (!regExp.hasMatch(value)) {
                              return 'Only letters/numbers/spaces, are allowed!';
                            }
                            setState(() {
                              _name = value;
                            });
                            return null;
                          },
                        ),
                        const Divider(
                          height: 50,
                          thickness: 1,
                          indent: 20,
                          endIndent: 0,
                          color: fgPrimaryColor,
                        ),
                        FGText.settingsHeading(
                            'Deck imageurl (try to select a square image):'),
                        TextFormField(
                          style: settingsStyle,
                          cursorColor: fgBrightColor,

                          keyboardType: TextInputType
                              .multiline, // user keyboard will have a button to move cursor to next line
                          maxLines: 7,
                          initialValue: _image,
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            if (!Uri.parse(value).isAbsolute) {
                              return 'Must be valid URL';
                            }
                            setState(() {
                              _image = value;
                            });
                            return null;
                          },
                        ),
                        const Divider(
                          height: 50,
                          thickness: 1,
                          indent: 20,
                          endIndent: 0,
                          color: fgPrimaryColor,
                        ),
                        FGText.settingsHeading('Deck words:'),
                        TextFormField(
                          cursorColor: fgBrightColor,
                          style: settingsStyle,
                          maxLines: 10,
                          keyboardType: TextInputType
                              .multiline, // user keyboard will have a button to move cursor to next line

                          initialValue: _words,
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            RegExp regExp =
                                RegExp(r'([a-zA-Z]|,|-|\(|\)|[0-9]|.)*');
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            if (!regExp.hasMatch(value)) {
                              return 'Only letters/-/, are allowed';
                            }
                            if (value.split(',').length < 5) {
                              return 'Put at least 5 words seperated with commas.';
                            }
                            setState(() {
                              _words = value;
                            });
                            return null;
                          },
                        ),
                      ],
                    )),
                const Divider(
                  height: 50,
                  thickness: 1,
                  indent: 20,
                  endIndent: 0,
                  color: fgPrimaryColor,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FGButton(
                        onTap: () {
                          validateAndSave();
                        },
                        title: 'Submit',
                      ),
                    ])
              ]),
            ),
          ),
        ));
  }
}
