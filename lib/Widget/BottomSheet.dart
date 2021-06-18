import 'package:milyar/Language/all_translations.dart';
import 'package:milyar/Utils/color.dart';
import 'package:milyar/Widget/text.dart';
import 'package:flutter/material.dart';

class BottomSheetScreen extends StatefulWidget {
  @override
  _StateBottomSheetScreen createState() => _StateBottomSheetScreen();
}

class _StateBottomSheetScreen extends State<BottomSheetScreen> {
  int _groupValue = -1;

  Widget _myRadioButton({int value, Function onChanged}) {
    return Radio(
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: modalBottomSheetMenu(),
    );
  }

  modalBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Card(
            child: new Container(
              height: 350.0,
              color:
                  Colors.transparent, //could change this to Color(0xFF737373),
              //so you don't have to change MaterialApp canvasColor
              child: new Container(
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(10.0),
                          topRight: const Radius.circular(10.0))),
                  child: Column(
                    children: <Widget>[
                      text(
                          context,
                          allTranslations.text('add_ads'),
                          EdgeInsets.only(top: 20),
                          Color(getColorHexFromStr('#FF701D')),
                          23),
                      _myRadioButton(
                        value: 0,
                        onChanged: (newValue) =>
                            setState(() => _groupValue = newValue),
                      ),
                      _myRadioButton(
                        value: 1,
                        onChanged: (newValue) => setState(() {
                          _groupValue = newValue;
                        }),
                      ),
                    ],
                  )),
            ),
          );
        });
  }
}
