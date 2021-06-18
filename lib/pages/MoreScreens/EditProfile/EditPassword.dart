import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:milyar/Language/all_translations.dart';
import 'package:milyar/Models/AuthModels/GetProfileModels.dart';
import 'package:milyar/Models/AuthModels/UpdateProfile.dart';
import 'package:milyar/ScoppedModels/ScoppedModels/Network_Utils.dart';

import 'package:milyar/Utils/color.dart';
import 'package:milyar/Widget/Buttons.dart';
import 'package:milyar/Widget/text.dart';
import 'package:milyar/pages/bottomNavigationBar.dart/BottomNavigationApp.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditPassword extends StatefulWidget {
  @override
  _EditPasswordState createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  String currentPassword;
  String newPassword;
  String confirmPassword;

  UpdateProfileModels updateProfileModels = UpdateProfileModels();

  ProgressDialog pr;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
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

  NetworkUtil util = NetworkUtil();
GetProfileModels getProfileModels = GetProfileModels();
  submitEditProfile(BuildContext context) async {
    pr = ProgressDialog(
      context,
      isDismissible: false,
      type: ProgressDialogType.Normal,
    );

    FormState formState = formKey.currentState;
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if (formState.validate()) {
      formState.save();
      FormData _formData = FormData.fromMap({
        "user_id":preferences.getString("id"),
        "old_password":currentPassword,
        "new_password": newPassword,
        "lang": allTranslations.currentLanguage,

      });

    
      //  pr.update(message: allTranslations.currentLanguage=='ar'?"يرجى الانتظار":"Loading",progress: 4,maxProgress: 10.0);

      pr.show();
      util
          .post('v1/ChangePassward', body: _formData, )
          .then((result) {
        // print("---------> $result");
        if (result.data['key'] == 1) {
          pr.hide();
          setState(() {
            // updateProfileModels = UpdateProfileModels.fromJson(result.data);
            Alert(
              buttons: [
                DialogButton(
                  child: Text(
                   allTranslations.currentLanguage =="ar"? "الرجوع":"Back",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () => Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => BottomPageBar())),
                  width: 120,
                )
              ],
              context: context,
              title: allTranslations.currentLanguage == "ar"?"تم تعديل البيانات بنجاح":"The data has been modified successfully",
            ).show();
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

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: allTranslations.currentLanguage == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.blue,
              )),
          title: Text(
            allTranslations.text('edit_password'),
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
          centerTitle: true,
        ),
        body: ListView(
          children: <Widget>[
            Form(
              key: formKey,
              child: Column(
                children: <Widget>[
//------------------------------currentPassword--------------------------------

                  Padding(
                    padding: const EdgeInsets.only(right: 25, left: 25),
                    child: Row(
                      children: <Widget>[
                        text(
                            context,
                            allTranslations.currentLanguage == 'ar'
                                ? "كلمه المرور الحاليه"
                                : "Current Password",
                            EdgeInsets.only(top: 30),
                            Colors.black,
                            17),
                      ],
                    ),
                  ),
                  textFormFiledUpdate(
                      context,
                      (val) {
                        if (val.isEmpty) {
                          return allTranslations.currentLanguage == 'ar'
                              ? 'من فضلك ادخل كلمه المرور الحاليه'
                              : "Please Enter Current Password";
                        } else {
                          return null;
                        }
                      },
                      TextInputType.text,
                      (val) {
                        setState(() {
                          currentPassword = val;
                        });
                      },
                      allTranslations.currentLanguage == 'ar'
                          ? "********"
                          : "************",
                      true,
                      null,true),
//------------------------------newPassword--------------------------------
                  Padding(
                    padding: const EdgeInsets.only(right: 25, left: 25),
                    child: Row(
                      children: <Widget>[
                        text(
                            context,
                            allTranslations.currentLanguage == 'ar'
                                ? "كلمه المرور الجديده"
                                : "New Password",
                            EdgeInsets.only(top: 30),
                            Colors.black,
                            17),
                      ],
                    ),
                  ),
                  textFormFiledUpdate(
                      context,
                      (val) {
                        if (val.isEmpty) {
                          return allTranslations.currentLanguage == 'ar'
                              ? 'من فضلك ادخل كلمه المرور الجديده'
                              : "Please Enter New Password";
                        } else {
                          return null;
                        }
                      },
                      TextInputType.text,
                      (val) {
                        setState(() {
                          newPassword = val;
                        });
                      },
                      allTranslations.currentLanguage == 'ar'
                          ? "********"
                          : "************",
                      true,
                      controller,true),
//--------------------------- confirmPassword------------------
                  Padding(
                    padding: const EdgeInsets.only(right: 25, left: 25),
                    child: Row(
                      children: <Widget>[
                        text(
                            context,
                            allTranslations.currentLanguage == 'ar'
                                ? "تأكيد كلمه المرور الجديده"
                                : "Confirm New Password",
                            EdgeInsets.only(top: 30),
                            Colors.black,
                            17),
                      ],
                    ),
                  ),
                  textFormFiledUpdate(
                      context,
                      (val) {
                        if (controller.text != val) {
                          return allTranslations.currentLanguage == 'ar'
                              ? 'قم بالتأكد من اختيار كلمه المرور '
                              : "Please Enter New Password";
                        } else {
                          return null;
                        }
                      },
                      TextInputType.text,
                      (val) {
                        setState(() {
                          confirmPassword = val;
                        });
                      },
                      allTranslations.currentLanguage == 'ar'
                          ? "********"
                          : "************",
                      true,
                      null,true),
                ],
              ),
            ),
//----------------------------Buttons--------------------------------------
            Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: () {
                  submitEditProfile(context);
                },
                child: buttons(
                    context,
                    allTranslations.currentLanguage == 'ar'
                        ? 'حفظ التعديل'
                        : "Save Edits",
                    EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 30)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
