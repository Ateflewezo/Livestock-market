import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:milyar/Language/all_translations.dart';
import 'package:milyar/Models/AuthModels/CodeRegister_Models.dart';
import 'package:milyar/ScoppedModels/ScoppedModels/Network_Utils.dart';

import 'package:milyar/Utils/color.dart';
import 'package:milyar/Widget/Buttons.dart';
import 'package:milyar/Widget/text.dart';
import 'package:milyar/pages/Auth/Continue_Screen.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CodeScreen extends StatefulWidget {
  final String mobile;
  final String id;
  const CodeScreen({Key key, this.mobile, this.id}) : super(key: key);
  @override
  _CodeScreenState createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  TextEditingController controller = TextEditingController();

  String thisText = "";
  int pinLength = 4;

  bool hasError = false;
  String errorMessage;
  NetworkUtil util = NetworkUtil();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RegisterCodeModels registerCodeModels = RegisterCodeModels();
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

  submit(BuildContext context) async {
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
        "user_id": widget.id,
        "code": controller.text,
        "lang": allTranslations.currentLanguage
      });

      pr.update(
          message: allTranslations.currentLanguage == 'ar'
              ? "يرجى الانتظار"
              : "Loading",
          progress: 4,
          maxProgress: 10.0);

      pr.show();
      util.post('v1/ConfirmCodeRegister', body: _formData).then((result) {
        print("---------> $result");
        if (result.data['key'] == 1) {
          setState(() {
            pr.hide();
            registerCodeModels = RegisterCodeModels.fromJson(result.data);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ContinueScreen()));
            preferences.setString('id', registerCodeModels.data.id);
            // preferences.setString('type', registerCodeModels.data.type);
            preferences.setString(
                'full_name', registerCodeModels.data.userName);
            preferences.setString('mobile', registerCodeModels.data.phone);
            preferences.setString('email', registerCodeModels.data.email);
            preferences.setString('address', registerCodeModels.data.address);
            // preferences.setString('image', registerCodeModels.data.image);
            // preferences.setString('jwt', registerCodeModels.data.jwt);
            // preferences.setString('address', registerCodeModels.data.address);
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
          body: Container(
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
                        ? 'تفعيل الحساب'
                        : 'Active Account',
                    EdgeInsets.only(top: 50),
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
                  child: Center(
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
                      EdgeInsets.only(
                          top: 100, left: 20, right: 20, bottom: 20)),
                )
              ],
            ),
          )),
    );
  }
}
