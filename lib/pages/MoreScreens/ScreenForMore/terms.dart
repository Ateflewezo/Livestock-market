import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milyar/Language/all_translations.dart';
import 'package:milyar/Models/general/AboutAppModels.dart';
import 'package:milyar/ScoppedModels/ScoppedModels/Network_Utils.dart';
import 'package:milyar/Utils/color.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsScreen extends StatefulWidget {
  @override
  _TermsScreenState createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  bool isLoading = false;

  ContatctUsModel aboutAppModels = ContatctUsModel();
  NetworkUtil _util = NetworkUtil();

  _getAboutClient() async {
    setState(() {
      isLoading = true;
    });

    Response response = await _util.post('v1/ContactUs');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      setState(() {
        aboutAppModels = ContatctUsModel.fromJson(response.data);
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
            allTranslations.currentLanguage == 'ar' ? "إتصل بنا" : "Contact Us",
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
        body:isLoading
            ? Center(
                child: CupertinoActivityIndicator(
                  animating: true,
                  radius: 15,
                ),
              )
            :  ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              child: InkWell(
                onTap: () {
                  launch("tel:${aboutAppModels.data.mobile1==null?'':aboutAppModels.data.mobile1}");
                },
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Icon(
                                Icons.call,
                                color: Colors.blue,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                allTranslations.currentLanguage == 'ar'
                                    ? "رقم الجوال ١ : "
                                    : "Mobile 1 :",
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              )
                            ],
                          ),
                        ),
                        Text(
                          aboutAppModels.data.mobile1,
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              child: InkWell(
                onTap: () {
                  launch("tel:${aboutAppModels.data.mobile2==null?'':aboutAppModels.data.mobile2}");
                },
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Icon(
                                Icons.call,
                                color: Colors.blue,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                allTranslations.currentLanguage == 'ar'
                                    ? "رقم الجوال ١ : "
                                    : "Mobile 2 :",
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              )
                            ],
                          ),
                        ),
                        Text(
                          aboutAppModels.data.mobile1,
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              child: InkWell(
                onTap: () async {
                  final Uri params = Uri(
                    scheme: 'mailto',
                    path: aboutAppModels.data.email,
                  );
                  String url = params.toString();
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    print('Could not launch $url');
                  }
                },
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Icon(
                                Icons.mail,
                                color: Colors.blue,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                allTranslations.currentLanguage == 'ar'
                                    ? "البريد الإلكترونى : "
                                    : "Email : ",
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              )
                            ],
                          ),
                        ),
                        Text(
                          aboutAppModels.data.email==null ? "":aboutAppModels.data.email,
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
