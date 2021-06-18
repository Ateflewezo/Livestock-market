import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:milyar/Language/all_translations.dart';
import 'package:milyar/Models/AuthModels/CodeForgetPassword.dart';
import 'package:milyar/ScoppedModels/ScoppedModels/Network_Utils.dart';

import 'package:milyar/Utils/color.dart';
import 'package:milyar/Widget/Buttons.dart';
import 'package:milyar/Widget/text.dart';
import 'package:milyar/pages/Auth/ChagePasswordScreen.dart';


import 'package:milyar/pages/Auth/continuePassword.dart';

import 'package:progress_dialog/progress_dialog.dart';

class CodeForgetPassword extends StatefulWidget {
  final String mobile;
  final String id;

  const CodeForgetPassword({Key key, this.mobile, this.id}) : super(key: key);
  @override
  _CodeForgetPasswordState createState() => _CodeForgetPasswordState();
}

class _CodeForgetPasswordState extends State<CodeForgetPassword> {
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  String thisText = "";
  int pinLength = 4;

  bool hasError = false;
  String errorMessage;
  NetworkUtil util = NetworkUtil();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CodeForgetPasswordModels codeForgetPasswordModels =
      CodeForgetPasswordModels();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  ProgressDialog pr;

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

  String password;
  submit(BuildContext context) async {
    pr = ProgressDialog(
      context,
      isDismissible: false,
      type: ProgressDialogType.Normal,
    );

    FormState formState = formKey.currentState;
    if (formState.validate()) {
      formState.save();
      FormData _formData = FormData.fromMap({
        "user_id": widget.id,
        "code": controller.text,
        "new_password": password,
        "lang": allTranslations.currentLanguage
      });

      pr.update(
          message: allTranslations.currentLanguage == 'ar'
              ? "يرجى الانتظار"
              : "Loading",
          progress: 4,
          maxProgress: 10.0);
      pr.show();
      util.post('v1/ChangePasswordByCode', body: _formData).then((result) {
        print("---------> $result");
        if (result.data['key'] == 1) {
          //  showInSnackBar(context, result.data['msg']);
          setState(() {
            pr.hide(); 
      
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ContinuePasswordScreen()));
            
            // codeForgetPasswordModels =
            //     CodeForgetPasswordModels.fromJson(result.data);
    
            // preferences.setInt('id', codeForgetPasswordModels.data.id);
            // preferences.setString('type', codeForgetPasswordModels.data.type);
            // preferences.setString(
            //     'full_name', codeForgetPasswordModels.data.fullName);
            // preferences.setString(
            //     'mobile', codeForgetPasswordModels.data.mobile);
            // preferences.setString('email', codeForgetPasswordModels.data.email);
            // preferences.setString(
            //     'address', codeForgetPasswordModels.data.address);
            // preferences.setString('image', codeForgetPasswordModels.data.image);
            // preferences.setString('jwt', codeForgetPasswordModels.data.jwt);
          });
        } else {
          pr.hide();
          showInSnackBar(context, result.data['msg']);
        }
      }).catchError((err) {
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
          body: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: ListView(
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
                text(
                    context,
                    allTranslations.currentLanguage == 'ar'
                        ? 'استرجاع كلمه المرور'
                        : "Recover Password",
                    EdgeInsets.only(top: 70),
                    Colors.black,
                    30),
                text(
                    context,
                    allTranslations.currentLanguage == 'ar'
                        ? 'من فضلك قم بادخال كود التفعيل'
                        : "Please Enter Activation Code",
                    EdgeInsets.only(top: 20),
                    Color(getColorHexFromStr('#787878')),
                    15),
                text(
                    context,
                    allTranslations.currentLanguage == 'ar'
                        ? 'المرسل لك على هاتفك'
                        : "It Send To Mobile",
                    EdgeInsets.only(top: 10),
                    Color(getColorHexFromStr('#787878')),
                    15),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Center(
                      child: Text(
                    widget.mobile,
                    style:
                        TextStyle(color: Color(getColorHexFromStr('#FFAC7C'))),
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Text(
                        allTranslations.currentLanguage == 'ar'
                            ? "تعديل رقم الجوال"
                            : "Edit Mobile Phone",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Color(getColorHexFromStr('#FF8F8F'))),
                      ),
                    ),
                  ),
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Center(
                        child: textFormFiled(
                            context,
                            TextInputType.number,
                            (String value) {
                              controller.text = value;
                            },
                            allTranslations.currentLanguage == 'ar'
                                ? "كود التفعيل"
                                : "Acitve code",
                            false,
                            null,
                            (String value) {
                              if (value.isEmpty) {
                                return allTranslations.currentLanguage == 'ar'
                                    ? "كود التفعيل"
                                    : "Acitve code";
                              } else {
                                return null;
                              }
                            }),
                      ),
                      Center(
                        child: textFormFiled(
                            context,
                            TextInputType.text,
                            (val) {
                              setState(() {
                                password = val;
                              });
                            },
                            allTranslations.currentLanguage == 'ar'
                                ? 'كلمه المرور'
                                : "Password",
                            true,
                            controller2,
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
                      Center(
                        child: textFormFiled(
                            context,
                            TextInputType.text,
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
                              if (controller2.text != val) {
                                return allTranslations.currentLanguage == 'ar'
                                    ? "قم بالتأكد من كلمه المرور"
                                    : "Enter Confirm Password";
                              } else {
                                return null;
                              }
                            }),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    submit(context);
                  },
                  child: buttons(
                      context,
                      allTranslations.currentLanguage == 'ar'
                          ? "تفعيل"
                          : "Active",
                      EdgeInsets.only(top: 10, left: 20, right: 20)),
                )
              ],
            ),
          )),
    );
  }
}
