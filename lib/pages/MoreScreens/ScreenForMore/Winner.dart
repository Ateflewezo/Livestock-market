import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milyar/Language/all_translations.dart';
import 'package:milyar/Models/general/Winners.dart';
import 'package:milyar/ScoppedModels/ScoppedModels/Network_Utils.dart';
import 'package:milyar/Utils/color.dart';

class WinnerScreen extends StatefulWidget {
  final String type;

  final String title;
  const WinnerScreen({Key key, this.type, this.title}) : super(key: key);
  @override
  _WinnerScreenState createState() => _WinnerScreenState();
}

class _WinnerScreenState extends State<WinnerScreen> {
  bool isLoading = false;

  NetworkUtil _util = NetworkUtil();
  WinnersShow winnersShow = WinnersShow();
  _getAboutClient() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> _headers = {"lang": allTranslations.currentLanguage};
    Response response = await _util.get(widget.type, headers: _headers);
    if (response.statusCode == 405) {
      setState(() {
        winnersShow = WinnersShow.fromJson(response.data);
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
      textDirection: allTranslations.currentLanguage == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(getColorHexFromStr('FFFFFF')),
          title: Text(
            widget.title,
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
        body: isLoading
            ? Center(
                child: CupertinoActivityIndicator(
                  animating: true,
                  radius: 15,
                ),
              )
            : winnersShow.data.length == 0
                ? Center(
                    child: Text(allTranslations.currentLanguage == "ar"
                        ? 'لا يوجد فائزين'
                        : 'There are no winners'),
                  )
                : Card(
                    child: ListView.builder(
                        itemCount: winnersShow.data.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7)),
                                        image: DecorationImage(
                                          // image: AssetImage("assets/icons/iphone.png"),
                                          image: NetworkImage(
                                              winnersShow.data[index].image),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(winnersShow.data[index].name),
                                ],
                              ),
                              Divider()
                            ],
                          );
                        }),
                  ),
      ),
    );
  }
}
