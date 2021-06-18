import 'package:milyar/Utils/Push_notifications.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milyar/Language/all_translations.dart';
import 'package:milyar/Models/AuthModels/LoginModels.dart';
import 'package:milyar/ScoppedModels/ScoppedModels/Network_Utils.dart';
import 'package:milyar/Utils/color.dart';
import 'package:milyar/Widget/Buttons.dart';
import 'package:milyar/Widget/text.dart';
import 'package:milyar/pages/Auth/ForgetPasswordScreen.dart';
import 'package:milyar/pages/Auth/Signup_Screen.dart';
import 'package:milyar/pages/bottomNavigationBar.dart/BottomNavigationApp.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  final String token;

  const LoginScreen({Key key, this.token}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String mobile, password;
  LoginModel loginModels = LoginModel();

  NetworkUtil util = NetworkUtil();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void showInSnackBar(BuildContext context, String text, String follow) {
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        backgroundColor: Colors.black,
        content: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontFamily: "Cairo",
          ),
        ),
      ),
    );
  }

/////////////////////////////////////////////
  ProgressDialog pr;
  String fcmToken;

  // AppPushNotifications appPushNotifications = AppPushNotifications();
  submit(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    pr = ProgressDialog(
      context,
      isDismissible: false,
      type: ProgressDialogType.Normal,
    );

    FormState formState = formKey.currentState;

    if (formState.validate()) {
      formState.save();
      FormData _formData = FormData.fromMap({
        "phone":   mobile,
        "password": password,
      });

      SharedPreferences preferences = await SharedPreferences.getInstance();

      pr.update(
          message: allTranslations.currentLanguage == 'ar'
              ? "يرجى الانتظار"
              : "Loading",
          progress: 4,
          maxProgress: 10.0);

      pr.show();
      util
          .post(
        '/v1/login',
        body: _formData,
      )
          .then((result) {
        pr.hide();
        print("*********************/atef");
        print("---------> $result");
        if (result.data["key"] == 1) {
          setState(() {
            loginModels = LoginModel.fromJson(result.data);
            preferences.setString('id', loginModels.data.id);
            // preferences.setString('type', loginModels.data.type);
            preferences.setString('full_name', loginModels.data.userName);
            preferences.setString('mobile', loginModels.data.phone);
            preferences.setString('email', loginModels.data.email);
            preferences.setString('address', loginModels.data.address);
            // preferences.setString('image', loginModels.data.image);
            preferences.setString('jwt', loginModels.token);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => BottomPageBar()));
          });
        } else {
          pr.hide();

          showInSnackBar(context, result.data['msg'], result.data['msg']);
        }
      }).catchError((err) {
        pr.hide();

        showInSnackBar(
            context,
            '',
            allTranslations.currentLanguage == 'ar'
                ? 'برجاء التأكد من الانترنت'
                : 'Please Check Internet');
        print("333333333333333333333333#########" + err.toString());
      });
    }
  }

  GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: allTranslations.currentLanguage == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        key: _scaffoldKey,
        body: ListView(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Image(
                            width: 200,
                            height: 100,
                            // color: Colors.black,
                            image: AssetImage("assets/logo_wide.png"),
                          )),
                    ),
                    Column(
                      children: <Widget>[
                        text(
                            context,
                            allTranslations.currentLanguage == 'ar'
                                ? 'تسجيل الدخول'
                                : "Login",
                            EdgeInsets.only(top: 50),
                            Colors.black,
                            20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            text(
                                context,
                                allTranslations.currentLanguage == 'ar'
                                    ? 'ليس لديك حساب؟    '
                                    : "Have Account ? ",
                                EdgeInsets.only(top: 20),
                                Color(getColorHexFromStr('#585858')),
                                17),
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUpScreen()));
                              },
                              child: text(
                                  context,
                                  allTranslations.currentLanguage == 'ar'
                                      ? 'انشاء حساب'
                                      : "Sign Up",
                                  EdgeInsets.only(top: 20),
                                  Color(getColorHexFromStr('#509F48')),
                                  17),
                            ),
                          ],
                        ),
                        Form(
                          key: formKey,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: textFormFiledPhone(
                                      context,
                                      TextInputType.number,
                                      (val) {
                                        setState(() {
                                          mobile = val ;
                                        
                                        });
                                      },
                                      allTranslations.currentLanguage == 'ar'
                                          ? 'رقم الجوال'
                                          : "Mobile",
                                      false,
                                      null,
                                      (val) {
                                        if (val.isEmpty) {
                                          return allTranslations
                                                      .currentLanguage ==
                                                  'ar'
                                              ? "ادخل رقم الجوال"
                                              : "Enter Mobile Number";
                                        } else {
                                          return null;
                                        }
                                      })),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: textFormFiled(
                                    context,
                                    TextInputType.visiblePassword,
                                    (val) {
                                      setState(() {
                                        password = val;
                                      });
                                    },
                                    allTranslations.currentLanguage == 'ar'
                                        ? 'كلمة المرور'
                                        : "Password",
                                    true,
                                    null,
                                    (val) {
                                      if (val.isEmpty) {
                                        return allTranslations
                                                    .currentLanguage ==
                                                'ar'
                                            ? "ادخل كلمه المرور الخاصه بك"
                                            : "Enter Vaild Password";
                                      } else {
                                        return null;
                                      }
                                    }),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ForgetPasswordScreen()));
                              },
                              child: Text(
                                allTranslations.currentLanguage == 'ar'
                                    ? 'نسيت كلمه المرور'
                                    : "Forget Password",
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Color(getColorHexFromStr('#FF8585')),
                                    decoration: TextDecoration.underline),
                              )),
                        )
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        onTap: () {
                          print("atefffffffffff");
                    print(966.toString()+"1111111111");
                          submit(context);
                        },
                        child: buttons(
                            context,
                            allTranslations.currentLanguage == 'ar'
                                ? 'تسجيل الدخول'
                                : "Login",
                            EdgeInsets.only(
                                right: 20, left: 20, top: 90, bottom: 20)),
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
