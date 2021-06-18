import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milyar/Language/all_translations.dart';
import 'package:milyar/Models/AuthModels/Cities.dart';
import 'package:milyar/Models/SubAdsModel.dart';
import 'package:milyar/ScoppedModels/ScoppedModels/Network_Utils.dart';
import 'package:milyar/Utils/color.dart';
import 'package:milyar/Widget/Buttons.dart';
import 'package:progress_dialog/progress_dialog.dart';

class FillterWidget extends StatefulWidget {
  @override
  _FillterWidgetState createState() => _FillterWidgetState();
}

class _FillterWidgetState extends State<FillterWidget> {
  AllCitiesModels allCitiesModels = AllCitiesModels();
  NetworkUtil _util = NetworkUtil();
  bool isLoading = false;
  // CitiesData citiesData;

  _getallCitiesClient() async {
    setState(() {
      isLoading = true;
    });

    Response response = await _util.get('city/all');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      setState(() {
        allCitiesModels = AllCitiesModels.fromJson(response.data);
        isLoading = false;
      });
    } else {}
  }

  // SubcategoriesAdsModels subcategoriesAdsModels = Subcategories AdsModels();
  ProgressDialog pr;
  _submiFillter(BuildContext context) async {
    pr = ProgressDialog(
      context,
      isDismissible: false,
      type: ProgressDialogType.Normal,
    );

    FormData _formData = FormData.fromMap({
      // 'city_id': citiesData.id, 
    });

    pr.update(
        message: allTranslations.currentLanguage == 'ar'
            ? "يرجى الانتظار"
            : "Loading",
        progress: 4,
        maxProgress: 10.0);

    pr.show();
    _util.post('client/filter/ads', body: _formData).then((result) {
      print("-------------------------- $result");
      Navigator.pop(context);

      if (result.statusCode == 200) {
        setState(() {
          // subcategoriesAdsModels = SubcategoriesAdsModels.fromJson(result.data);
          Navigator.pop(context);
        });
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              print(result.data['message']);
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                title: Text(
                  result.data['message'],
                  style: TextStyle(
                      fontSize: 14, color: Theme.of(context).primaryColor),
                ),
                actions: <Widget>[
                  Center(
                    child: FlatButton(
                      child: Text(allTranslations.text('ok')),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              );
            });
      }
    }).catchError((err) {
      print("333333333333333333333333#########" + err.toString());
    });
  }

  @override
  void initState() {
    _getallCitiesClient();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        width: MediaQuery.of(context).size.width,
        height: 300,
        child: _SystemPadding(
          child: Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(),
                Text(
                  allTranslations.currentLanguage == 'ar' ? "فلتر" : "Filtter",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.close))
              ],
            ),

            // Padding(
            //   padding: const EdgeInsets.only(top: 20),
            //   child: Container(
            //     height: 50,
            //     decoration: BoxDecoration(
            //         color: Color(getColorHexFromStr('#FAFAFA')),
            //         borderRadius: BorderRadius.circular(15)),
            //     width: MediaQuery.of(context).size.width,
            //     child: DropdownButtonHideUnderline(
            //       child: isLoading
            //           ? Center(
            //               child: CupertinoActivityIndicator(
            //                 animating: true,
            //                 radius: 15,
            //               ),
            //             )
            //           : DropdownButton<CitiesData>(
            //               hint: Center(
            //                 child: Text(
            //                   allTranslations.currentLanguage == 'ar'
            //                       ? 'المدينه'
            //                       : "City",
            //                   style: TextStyle(
            //                       fontWeight: FontWeight.bold,
            //                       color: Color(getColorHexFromStr('#A9A9A9')),
            //                       fontFamily: "Cairo",
            //                       fontSize: 15),
            //                 ),
            //               ),
            //               iconEnabledColor: Colors.grey,
            //               iconDisabledColor: Colors.grey,
            //               isExpanded: true,
            //               style: TextStyle(
            //                 color: Colors.black,
            //                 fontSize: 20.0,
            //               ),
            //               items: allCitiesModels.data.map((item) {
            //                 return DropdownMenuItem<CitiesData>(
            //                     value: item,
            //                     child: Center(
            //                       child: item.id == 0
            //                           ? Text(
            //                               item.name,
            //                               style: TextStyle(
            //                                   fontWeight: FontWeight.bold,
            //                                   color: Color(getColorHexFromStr(
            //                                       '#A9A9A9')),
            //                                   fontFamily: "Cairo",
            //                                   fontSize: 15),
            //                             )
            //                           : Text(
            //                               item.name,
            //                               style: TextStyle(
            //                                   fontWeight: FontWeight.bold,
            //                                   color: Color(getColorHexFromStr(
            //                                       '#A9A9A9')),
            //                                   fontFamily: "Cairo",
            //                                   fontSize: 15),
            //                             ),
            //                     ));
            //               }).toList(),
            //               onChanged: (CitiesData value) async {
            //                 setState(() {
            //                   citiesData = value;
            //                 });
            //               },
            //               value: citiesData,
            //             ),
            //     ),
            //   ),
            // ),
//-------------------------------------------------------------------

            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Color(getColorHexFromStr('#FAFAFA')),
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(),
                    Text(
                      allTranslations.currentLanguage == 'ar'
                          ? 'السعر'
                          : "Price",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(getColorHexFromStr('#A9A9A9'))),
                    ),
                    Icon(Icons.arrow_drop_down,
                        color: Color(getColorHexFromStr('#A9A9A9'))),
                  ],
                ),
              ),
            ),

            InkWell(
                onTap: () {
                  _submiFillter(context);
                },
                child: buttons(
                  context,
                  allTranslations.currentLanguage == 'ar' ? 'البحث' : 'Search',
                  EdgeInsets.only(top: 20),
                ))
          ]),
        ));
  }
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return new AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
