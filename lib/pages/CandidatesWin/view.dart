import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milyar/Language/all_translations.dart';
import 'package:milyar/Models/general/Winners.dart';
import 'package:milyar/ScoppedModels/ScoppedModels/Network_Utils.dart';
import 'package:milyar/Utils/color.dart';
import 'package:milyar/Widget/Buttons.dart';
import 'package:milyar/pages/MoreScreens/ScreenForMore/Winner.dart';

class CandidatesWinner extends StatefulWidget {
  @override
  _CandidatesWinnerState createState() => _CandidatesWinnerState();
}

class _CandidatesWinnerState extends State<CandidatesWinner> {
  bool isLoading = false;

  NetworkUtil _util = NetworkUtil();
  WinnersShow winnersShow = WinnersShow();
  _getAboutClient() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> _headers = {"lang": allTranslations.currentLanguage};
    Response response =
        await _util.get('candidate_conditions', headers: _headers);
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
              allTranslations.currentLanguage == "ar"
                  ? "المرشحين للفوز"
                  : "The candidates to win",
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
                      child: Text(
                        allTranslations.currentLanguage=="ar"?
                        'لا توجد شروط':'There are no conditions'),
                    )
                  : ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        ListView.builder(
                            itemCount: winnersShow.data.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return ListTile(
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          height: 10,
                                          width: 10,
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              shape: BoxShape.circle),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                  winnersShow.data[index].name),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WinnerScreen(
                                          type: "candidates",
                                          title:
                                              allTranslations.currentLanguage ==
                                                      "ar"
                                                  ? "المرشحين للفوز"
                                                  : "The candidates to win",
                                        )));
                          },
                          child: buttons(
                              context,
                              allTranslations.currentLanguage == 'ar'
                                  ? 'استمرار'
                                  : "Continue",
                              EdgeInsets.only(right: 14, left: 15)),
                        )
                      ],
                    )),
    );
  }
}
