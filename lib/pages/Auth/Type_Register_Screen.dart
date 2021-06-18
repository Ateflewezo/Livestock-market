import 'package:flutter/material.dart';
import 'package:milyar/Language/all_translations.dart';
import 'package:milyar/Utils/color.dart';
import 'package:milyar/Widget/Buttons.dart';
import 'package:milyar/pages/Auth/LoginScreen.dart';
import 'package:milyar/pages/Auth/Signup_Screen.dart';
import 'package:milyar/pages/bottomNavigationBar.dart/BottomNavigationApp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TypeRegisterScreen extends StatefulWidget {
  @override
  _TypeRegisterScreenState createState() => _TypeRegisterScreenState();
}

class _TypeRegisterScreenState extends State<TypeRegisterScreen> {
  String fcmToken;
  _fcmToken() async {
    SharedPreferences.getInstance().then((prefs) {
      fcmToken = prefs.getString('msgToken');
      print("gggggggggggggg ${prefs.getString('msgToken')}");
    });
  }

  @override
  void initState() {
    _fcmToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: allTranslations.currentLanguage == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
          body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/bg1.png'),
          fit: BoxFit.cover,
        )),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Center(
                  child: Image(
                width: 250,
                height: 100,
               fit: BoxFit.contain,
                // color: Colors.black,
                image: AssetImage("assets/logo_wide.png"),
              )),
            ),
            Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 70),
                    child: Text(
                      allTranslations.currentLanguage == 'ar'
                          ? "من فضلك اختر نوع التسجيل"
                          : "Please Choose Register Type",
                      style: TextStyle(
                          color: Color(getColorHexFromStr("#252525")),
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
            Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen(
                                    token: fcmToken,
                                  )));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 90, bottom: 25),
                      child:buttons(
                          context,
                          allTranslations.currentLanguage == 'ar'
                              ? 'تسجيل  الدخول'
                              : "Login",
                          EdgeInsets.only(right: 14, left: 15))),
                  ),
                ),
              ],
            ),
            Stack(
              children: <Widget>[
                Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()));
                      },
                      child: buttons(
                          context,
                          allTranslations.currentLanguage == 'ar'
                              ? 'تسجيل حساب جديد'
                              : "SignUp New Account",
                          EdgeInsets.only(right: 14, left: 15)),
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Stack(
                children: <Widget>[
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BottomPageBar()));
                        },
                        child: buttons(
                            context,
                            allTranslations.currentLanguage == 'ar'
                                ? 'الدخول كزائر'
                                : "Visitor",
                            EdgeInsets.only(right: 14, left: 15)),
                      )),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
