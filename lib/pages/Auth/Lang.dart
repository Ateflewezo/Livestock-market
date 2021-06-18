import 'package:flutter/material.dart';
import 'package:milyar/Language/all_translations.dart';
import 'package:milyar/Utils/color.dart';
import 'package:milyar/Widget/Buttons.dart';
import 'package:milyar/pages/Auth/Type_Register_Screen.dart';

class LanguageScreen extends StatefulWidget {
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final String language = allTranslations.currentLanguage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.png'), fit: BoxFit.cover),
          ),
          child: ListView(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Center(
                      child: Image(
                    width: 100,
                    height: 100,
                    // color: Colors.black,
                    image: AssetImage("assets/Logo.png"),
                  ))),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 200),
                  child: Text(
                    "اختر اللغه  ",
                    style: TextStyle(
                        color: Color(getColorHexFromStr("#252525")),
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Center(
                  child: InkWell(
                    onTap: () async {
                      await allTranslations.setNewLanguage(
                          language == 'ar' ? 'ar' : 'en', true);
                      setState(() {
                        allTranslations.setNewLanguage("ar", true);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TypeRegisterScreen()));
                      });
                    },
                    // onTap: () {
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => SignUpScreen()));
                    // },
                    child: buttons(context, 'اللغه العربيه',
                        EdgeInsets.only(right: 14, left: 15)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: () async {
                      await allTranslations.setNewLanguage(
                          language == 'ar' ? 'en' : 'ar', true);
                      setState(() {
                        allTranslations.setNewLanguage("en", true);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TypeRegisterScreen()));
                      });
                    },
                    child: buttons(context, 'English',
                        EdgeInsets.only(right: 14, left: 15)),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
