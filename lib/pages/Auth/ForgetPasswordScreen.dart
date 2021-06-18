import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:milyar/Language/all_translations.dart';
import 'package:milyar/Models/AuthModels/ForgetPasswordModel.dart';
import 'package:milyar/ScoppedModels/ScoppedModels/Network_Utils.dart';

import 'package:milyar/Utils/color.dart';
import 'package:milyar/Widget/Buttons.dart';
import 'package:milyar/Widget/text.dart';
import 'package:milyar/pages/Auth/CodeForgetPassword.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  String mobile;
  ForgetPasswordModel forgetPasswordModel = ForgetPasswordModel();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  NetworkUtil util = NetworkUtil();

  ProgressDialog pr;
  void showInSnackBar(BuildContext context, String text) {
    scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: "Cairo",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  submit(BuildContext context) async {
    pr = ProgressDialog(context,
        isDismissible: false, type: ProgressDialogType.Normal, showLogs: true);
    FormState formState = formKey.currentState;

    if (formState.validate()) {
      formState.save();
      FormData _formData = FormData.fromMap(
          {"phone": mobile, "lang": allTranslations.currentLanguage});
      pr.update(
          message: allTranslations.currentLanguage == 'ar'
              ? "يرجى الانتظار"
              : "Loading",
          progress: 4,
          maxProgress: 10.0);

      pr.show();
      util
          .post(
        'v1/Forget_password',
        body: _formData,
      )
          .then((result) {
        print('kkkkkkkkkkkkkkkks');

        print("---------> $result");
        if (result.data['key'] == 1) {
          setState(() {
            pr.hide();
            forgetPasswordModel = ForgetPasswordModel.fromJson(result.data);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CodeForgetPassword(
                          mobile: mobile,
                          id: forgetPasswordModel.code.userId,
                        )));
          });
        } else {
          pr.hide();
          showInSnackBar(context, result.data['msg']);
        }
      }).catchError((err) {
        pr.hide();
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
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Colors.white),
            child: Stack(
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
                              ? 'استرجاع كلمه المرور'
                              : "Recover Password",
                          EdgeInsets.only(top: 200),
                          Colors.black,
                          23),
                      text(
                          context,
                          allTranslations.currentLanguage == 'ar'
                              ? 'من فضلك قم بادخال رقم جوالك '
                              : "Please Enter Mobile Phone",
                          EdgeInsets.only(top: 40),
                          Color(getColorHexFromStr('#B8B8B8')),
                          15),
                      text(
                          context,
                          allTranslations.currentLanguage == 'ar'
                              ? 'لارسال كود التفعيل عليه'
                              : "To Send Active Code",
                          EdgeInsets.only(top: 10),
                          Color(getColorHexFromStr('#B8B8B8')),
                          15),
                      Padding(
                        padding: const EdgeInsets.only(top: 100),
                        child: textFormFiledPhone(
                            context,
                            TextInputType.number,
                            (val) {
                              setState(() {
                                mobile = val;
                              });
                            },
                            allTranslations.currentLanguage == 'ar'
                                ? 'رقم الجوال'
                                : "Mobile",
                            false,
                            null,
                            (val) {
                              if (val.isEmpty) {
                                return allTranslations.currentLanguage == 'ar'
                                    ? "ادخل رقم الجوال"
                                    : "Enter Mobile Number";
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
                              ? 'ارسال'
                              : "Send",
                          EdgeInsets.only(right: 20, left: 20, bottom: 20)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
