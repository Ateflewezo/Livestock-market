import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milyar/Language/all_translations.dart';
import 'package:milyar/Models/AuthModels/LoginModels.dart';
import 'package:milyar/ScoppedModels/ScoppedModels/Network_Utils.dart';
import 'package:milyar/Utils/color.dart';
import 'package:milyar/Widget/Buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SocailScreen extends StatefulWidget {
  @override
  _SocailScreenState createState() => _SocailScreenState();
}

class _SocailScreenState extends State<SocailScreen> {
  TextEditingController _maroof = TextEditingController();
  TextEditingController _insta = TextEditingController();
  TextEditingController _twitter = TextEditingController();
  TextEditingController _facebook = TextEditingController();
  TextEditingController _youtube = TextEditingController();
  TextEditingController _snapChat = TextEditingController();
  NetworkUtil util = NetworkUtil();
  LoginModel getProfileModels = LoginModel();
  bool profile = false;

  submitData(BuildContext context) async {
    SharedPreferences prfs = await SharedPreferences.getInstance();
    setState(() {
      profile = true;
    });

    Map<String, dynamic> _headers = {
      "Authorization": "Bearer " + prfs.getString("jwt"),
    };
    print(_headers);

    util.get('client/my/profile', headers: _headers).then((result) {
      print("---------> $result");
      if (result.statusCode == 200) {
        setState(() {
          getProfileModels = LoginModel.fromJson(result.data);
          profile = false;

          // if (getProfileModels.data.socialLinks == null) {
          //   _maroof.text = "";
          //   _insta.text = "";
          //   _twitter.text = "";
          //   _facebook.text = "";
          //   _snapChat.text = "";
          //   _youtube.text = '';
          // } else {
          //   _maroof.text = getProfileModels.data.socialLinks.maroof;
          //   _insta.text = getProfileModels.data.socialLinks.instagram;
          //   _twitter.text = getProfileModels.data.socialLinks.twitter;
          //   _facebook.text = getProfileModels.data.socialLinks.facebook;
          //   _snapChat.text = getProfileModels.data.socialLinks.snapchat;
          //   _youtube.text = getProfileModels.data.socialLinks.youtube;
          // }
        });
      } else {}
    });
  }

  @override
  void initState() {
    submitData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: allTranslations.currentLanguage == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(getColorHexFromStr('FFFFFF')),
          title: Text(
            allTranslations.currentLanguage == "ar"
                ? "الربط بحسابات التواصل الإجتماعى"
                : "Linking to social media accounts",
            style: TextStyle(color: Color(getColorHexFromStr('5FBB55'))),
          ),
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.keyboard_arrow_right,
                size: 30,
                color: Color(
                  getColorHexFromStr('#5FBB55'),
                ),
              )),
          centerTitle: true,
        ),
        body: profile
            ? Center(
                child: CupertinoActivityIndicator(
                  animating: true,
                  radius: 15,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _itemsCard(
                      allTranslations.currentLanguage =="ar"?
                      
                      "ربط حسابك بمعروف":"Maroof",
                        AssetImage('assets/Maroof.png'), _maroof),
                    _itemsCard(
                        allTranslations.currentLanguage =="ar"?
                      "ربط حسابك بإنستجرام":"Instagram",
                        AssetImage('assets/instagram.png'), _insta),
                    _itemsCard(
                        allTranslations.currentLanguage =="ar"?
                      "ربط حسابك بتويتر":"Twitter",
                        AssetImage('assets/twitter.png'), _twitter),
                    _itemsCard(
                        allTranslations.currentLanguage =="ar"?
                      "ربط حسابك بالفيس بوك":"FaceBook",
                        AssetImage('assets/facebook.png'), _facebook),
                    _itemsCard(
                        allTranslations.currentLanguage =="ar"?
                      "ربط حسابك بيوتيوب":"Youtube",
                        AssetImage('assets/youtube.png'), _youtube),
                    _itemsCard(
                        allTranslations.currentLanguage =="ar"?
                      "ربط حسابك سناب شات":"SnapChat",
                        AssetImage('assets/SnapChat.png'), _snapChat),
                    SizedBox(
                      height: 70,
                    ),
                    isLoading
                        ? Center(
                            child: CupertinoActivityIndicator(
                              animating: true,
                              radius: 15,
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              submit(context);
                            },
                            child: buttons(
                                context,
                                allTranslations.currentLanguage == 'ar'
                                    ? 'حفظ'
                                    : "Save",
                                EdgeInsets.only(right: 14, left: 15)),
                          )
                  ],
                ),
              ),
      ),
    );
  }

  Widget _itemsCard(
      String hidden, AssetImage assetImage, TextEditingController controller) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Image(
                  image: assetImage,
                  height: 50,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 100,
                  child: TextFormField(
                    textAlign: TextAlign.right,
                    controller: controller,
                    style: TextStyle(
                        fontFamily: "cairo",
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                    decoration: InputDecoration(
                      errorStyle: TextStyle(
                        fontFamily: "cairo",
                        color: Colors.red,
                        fontSize: 13,
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 10, top: 18, bottom: 18, right: 10),
                      hintText: hidden,
                      filled: true,
                      fillColor: Color(getColorHexFromStr('FFFFFF')),
                    ),
                  ),
                ),
                Divider()
              ],
            ),
          ],
        ));
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void showInSnackBar(BuildContext context, String text, String follow) {
    _scaffoldKey.currentState.showSnackBar(
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

  bool isLoading = false;

  submit(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    FormData _formData = FormData.fromMap({
      "maroof": _maroof.text,
      "instagram": _insta.text,
      "facebook": _facebook.text,
      "twitter": _twitter.text,
      "youtube": _youtube.text,
      "snapchat": _snapChat.text
    });

    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map<String, dynamic> _headers = {
      "Authorization": "Bearer " + preferences.getString("jwt"),
    };

    util
        .post('client/social_links', body: _formData, headers: _headers)
        .then((result) {
      print("---------> ${result.statusCode}");
      if (result.statusCode == 200) {
        setState(() {
          isLoading = false;
          showInSnackBar(
              context, result.data['message'], result.data['message']);
        });
      } else if (result.statusCode == 405) {
        setState(() {
          isLoading = false;
          showInSnackBar(
              context, result.data['message'], result.data['message']);
        });
      }
    }).catchError((err) {
      isLoading = false;
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
