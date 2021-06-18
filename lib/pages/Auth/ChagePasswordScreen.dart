import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:milyar/Language/all_translations.dart';
import 'package:milyar/Models/AuthModels/ResetModels.dart';
import 'package:milyar/ScoppedModels/ScoppedModels/Network_Utils.dart';
import 'package:milyar/Utils/color.dart';
import 'package:milyar/Widget/Buttons.dart';
import 'package:milyar/Widget/text.dart';
import 'package:milyar/pages/bottomNavigationBar.dart/BottomNavigationApp.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String code;
  final String token;
  const ChangePasswordScreen({Key key, this.code, this.token})
      : super(key: key);
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController controller = TextEditingController();
  String password;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  NetworkUtil util = NetworkUtil();
  ResetModels resetModels = ResetModels();
  ProgressDialog pr;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(BuildContext context, String text) {
    scaffoldKey.currentState.showSnackBar(
      new SnackBar(
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

  submit(BuildContext context) async {
    pr = ProgressDialog(context,
        isDismissible: false, type: ProgressDialogType.Normal, showLogs: true);

    FormState formState = formKey.currentState;
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if (formState.validate()) {
      formState.save();
      FormData _formData =
          FormData.fromMap({"password": password, "code": widget.code});

      Map<String, dynamic> _headers = {
        "Authorization": "Bearer " + widget.token,
      };

      pr.update(
          message: allTranslations.currentLanguage == 'ar'
              ? "يرجى الانتظار"
              : "Loading",
          progress: 4,
          maxProgress: 10.0);

      pr.show();
      util
          .post('auth/do_reset', body: _formData, headers: _headers)
          .then((result) {
        print('kkkkkkkkkkkkkkkks');
        pr.hide();
        print("---------> $result");
        if (result.statusCode == 200) {
          setState(() {
            resetModels = ResetModels.fromJson(result.data);

            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => BottomPageBar()));

            preferences.setInt('id', resetModels.data.id);
            preferences.setString('type', resetModels.data.type);
            preferences.setString('full_name', resetModels.data.fullName);
            preferences.setString('mobile', resetModels.data.mobile);
            preferences.setString('email', resetModels.data.email);
            preferences.setString('address', resetModels.data.address);
            preferences.setString('image', resetModels.data.image);
            preferences.setString('jwt', resetModels.data.jwt);
          });
        } else {
          showInSnackBar(context, result.data['message']);
        }
      }).catchError((err) {
        Navigator.pop(context);
        showInSnackBar(
            context,
            allTranslations.currentLanguage == 'ar'
                ? 'برجاء التأكد من الانترنت'
                : 'Please Check Internet');
        print("333333333333333333333333#########" + err.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: allTranslations.currentLanguage == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        key: scaffoldKey,
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
                  Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        text(
                            context,
                            allTranslations.currentLanguage == 'ar'
                                ? 'استرجاع كلمه المرور '
                                : "Recover Password",
                            EdgeInsets.only(top: 120),
                            Colors.black,
                            23),
                        text(
                            context,
                            allTranslations.currentLanguage == 'ar'
                                ? 'من فضلك قم بادخال كلمه المرور'
                                : "Please Enter New Password",
                            EdgeInsets.only(top: 40),
                            Color(getColorHexFromStr('#B8B8B8')),
                            15),
                        Padding(
                          padding: const EdgeInsets.only(top: 100),
                          child: textFormFiled(
                              context,
                              TextInputType.number,
                              (val) {
                                setState(() {
                                  password = val;
                                });
                              },
                              allTranslations.currentLanguage == 'ar'
                                  ? 'كلمه المرور'
                                  : "Password",
                              true,
                              controller,
                              (val) {
                                if (val.isEmpty) {
                                  return allTranslations.currentLanguage == 'ar'
                                      ? "ادخل كلمه المرور"
                                      : "Enter Password";
                                } else {
                                  return null;
                                }
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: textFormFiled(
                              context,
                              TextInputType.number,
                              (val) {
                                setState(() {
                                  // mobile = val;
                                });
                              },
                              allTranslations.currentLanguage == 'ar'
                                  ? 'تأكيد كلمه المرور'
                                  : "Confirm Password",
                              true,
                              null,
                              (val) {
                                if (controller.text != val) {
                                  return allTranslations.currentLanguage == 'ar'
                                      ? "قم بالتأكد من كلمه المرور"
                                      : "Enter Confirm Password";
                                } else {
                                  return null;
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () {},
                      child: InkWell(
                        onTap: () {
                          submit(context);
                        },
                        child: buttons(
                            context,
                            allTranslations.currentLanguage == 'ar'
                                ? 'تفعيل الحساب'
                                : "Active",
                            EdgeInsets.only(
                                right: 20, left: 20, bottom: 20, top: 40)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
