import 'package:flutter/material.dart';
import 'package:milyar/Language/all_translations.dart';
import 'package:milyar/Widget/Buttons.dart';
import 'package:milyar/Widget/text.dart';
import 'package:milyar/pages/bottomNavigationBar.dart/BottomNavigationApp.dart';

class ContinueScreen extends StatefulWidget {
  @override
  _ContinueScreenState createState() => _ContinueScreenState();
}

class _ContinueScreenState extends State<ContinueScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: allTranslations.currentLanguage == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: Colors.white),
          child: ListView(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Image(
                      width: 100,
                      height: 100,
                      // color: Colors.black,
                      image: AssetImage("assets/logo_wide.png"),
                    )),
              ),

              text(
                  context,
                  allTranslations.currentLanguage == 'ar'
                      ? 'عملينا العزيز'
                      : "Our Client",
                  EdgeInsets.only(top: 100),
                  Colors.black,
                  23),
              text(
                  context,
                  allTranslations.currentLanguage == 'ar'
                      ? ' تم تفعيل الحساب بنجاح'
                      : "Account Activated Successfully",
                  const EdgeInsets.only(top: 0),
                  Colors.black,
                  23),

//------------------------ButtonsContinue-----------------
              InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BottomPageBar()));
                  },
                  child: buttons(
                      context,
                      allTranslations.currentLanguage == 'ar'
                          ? 'استمرار'
                          : "Countine",
                      const EdgeInsets.only(top: 200, right: 14, left: 15)))
            ],
          ),
        ),
      ),
    );
  }
}
