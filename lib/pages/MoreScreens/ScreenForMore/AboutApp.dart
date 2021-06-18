import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milyar/Language/all_translations.dart';
import 'package:milyar/Models/general/AboutAppModels.dart';
import 'package:milyar/ScoppedModels/ScoppedModels/Network_Utils.dart';
import 'package:milyar/Utils/color.dart';

class AboutApp extends StatefulWidget {
  @override
  _AboutAppState createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  bool isLoading = false;

  AboutUs aboutAppModels = AboutUs();
  NetworkUtil _util = NetworkUtil();

  _getAboutClient() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> _headers = {"lang": allTranslations.currentLanguage};
    Response response = await _util.post('v1/AboutUs');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      setState(() {
        aboutAppModels = AboutUs.fromJson(response.data);
        isLoading = false;
      });
    } else {}
  }

  @override
  void initState() {
    _getAboutClient();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: allTranslations.currentLanguage == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            allTranslations.currentLanguage == 'ar'
                ? "عن التطبيق"
                : "About App",
            style: TextStyle(color: Colors.blue),
          ),
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.keyboard_arrow_right,
                  size: 30, color: Colors.blue)),
          centerTitle: true,
        ),
        body: isLoading
            ? Center(
                child: CupertinoActivityIndicator(
                  animating: true,
                  radius: 15,
                ),
              )
            : ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Column(
                      children: <Widget>[
                        Text(
                          aboutAppModels.data.about ?? "",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
