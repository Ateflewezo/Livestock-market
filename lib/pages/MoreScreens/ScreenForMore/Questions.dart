import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milyar/Language/all_translations.dart';
import 'package:milyar/Models/general/QuestionsModels.dart';
import 'package:milyar/ScoppedModels/ScoppedModels/Network_Utils.dart';
import 'package:milyar/Utils/color.dart';

class Questions extends StatefulWidget {
  @override
  _QuestionsState createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  QuestionsModels getReasonModels = QuestionsModels();

  bool isLoading = false;

  NetworkUtil _util = NetworkUtil();

  _getAboutClient() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> _headers =
       {"lang": allTranslations.currentLanguage};
    Response response =
        await _util.get('public/questions/all', headers: _headers);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      setState(() {
        getReasonModels = QuestionsModels.fromJson(response.data);
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
            allTranslations.text('question'),
            style: TextStyle(color: Color(getColorHexFromStr('#66CC7E'))),
          ),
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.keyboard_arrow_right,
                size: 30,
                color: Color(
                  getColorHexFromStr('#66CC7E'),
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
            : ListView.builder(
                shrinkWrap: true,
                itemCount: getReasonModels.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(getReasonModels.data[index].question),
                    leading: Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(100)),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 30),
                    subtitle: Text(getReasonModels.data[index].answer),
                  );
                },
              ),
      ),
    );
  }
}
