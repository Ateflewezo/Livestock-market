import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:milyar/Language/all_translations.dart';
import 'package:milyar/Models/general/AllCategoriesModels.dart';
import 'package:milyar/ScoppedModels/ScoppedModels/Network_Utils.dart';
import 'package:milyar/Utils/color.dart';
import 'package:milyar/pages/HomeScreen/HomeScreenDetails.dart';
import 'package:milyar/pages/HomeScreen/ProductCard.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toast/toast.dart';

class NearestPage extends StatefulWidget {
  final lat, lng;

  const NearestPage({Key key, this.lat, this.lng}) : super(key: key);
  @override
  _NearestPageState createState() => _NearestPageState();
}

class _NearestPageState extends State<NearestPage> {
  String jwt;
  _getFromCach() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      jwt = preferences.getString('id');
      print(jwt);
    });
  }

  bool isLoading = false;
  ProgressDialog pr;

  NetworkUtil util = NetworkUtil();
  AllCategoryModel allCategoryModel = AllCategoryModel();

  NetworkUtil _util = NetworkUtil();

  _getAboutClient(var lat, lng) async {
    setState(() {
      isLoading = true;
    });

    Response response = await _util.post('v1/Shop',
        body: FormData.fromMap({
          "Lang": lat,
          "Lat": lng,
        }));
    setState(() {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        setState(() {
          // print("Ddsadsadasdsadasdasdadasdasdas");
          allCategoryModel = AllCategoryModel.fromJson(response.data);

          isLoading = false;
        });
      } else if (response.statusCode == 500) {
        Toast.show("fghsjkl", context);
      }
    });
  }

  bool getLat = false;
  double lat, lng;

  @override
  void initState() {
    _getFromCach();
    _getAboutClient(widget.lat, widget.lng);
    super.initState();
  }

Future<bool> _onBackPressed() {
    return showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            content: new Text(
              allTranslations.currentLanguage == 'ar'
                  ? "هل تريد اغلاق التطبيق "
                  : "Do you want close the app?",
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Cairo',
                  color: Color(getColorHexFromStr('#EC6D04'))),
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(
                  allTranslations.currentLanguage == 'ar' ? "لا" : "No",
                  style: TextStyle(color: Color(getColorHexFromStr('#EC6D04'))),
                ),
              ),
              new FlatButton(
                onPressed: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                child: new Text(
                  allTranslations.currentLanguage == 'ar' ? "نعم" : "ok",
                  style: TextStyle(color: Color(getColorHexFromStr('#EC6D04'))),
                ),
              ),
            ],
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    // _getData();
    return WillPopScope(
      onWillPop:_onBackPressed ,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text(
              "الأقرب",
              style: TextStyle(color: Colors.blue),
            ),
            elevation: 0,
          ),
          body: isLoading
              ? Center(
                  child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: 80,
                          margin: EdgeInsets.all(0),
                          child: Shimmer.fromColors(
                              baseColor: Colors.black12.withOpacity(0.1),
                              highlightColor: Colors.black.withOpacity(0.2),
                              child: Container(
                                color: Colors.red,
                                width: MediaQuery.of(context).size.width,
                                height: 80,
                                margin: EdgeInsets.all(10),
                              )),
                        );
                      }),
                )
              : ListView.builder(
                  itemCount: allCategoryModel.advertisments.length,
                  shrinkWrap: true,
                  primary: false,
                  itemBuilder: (context, index) {
                    return allCategoryModel.advertisments.length == 0
                        ? Center(
                            child: Text("لا توجد بيانات"),
                          )
                        : InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreenDetails(
                                            idAds: allCategoryModel
                                                .advertisments[index],
                                          ))).then((value) {
                                // _getHomeScreen();
                              });
                            },
                            child: productCard(
                                context: context,
                                name: allCategoryModel.advertisments[index].title,
                                img: "https://souq-mawashi.com/" +
                                    allCategoryModel
                                        .advertisments[index].imageUrl1,
                                address: allCategoryModel
                                        .advertisments[index].cityName ??
                                    "",
                                brandName: "",
                                isMine: false,
                                price: "0" ?? "",
                                description: allCategoryModel
                                        .advertisments[index].description ??
                                    "",
                                onToggleTapped: () {
                                  setState(() {
                                    if (jwt == null) {
                                      Toast.show(
                                          allTranslations.currentLanguage == "ar"
                                              ? "قم بتسجيل الدخول اولا"
                                              : "Login First",
                                          context);
                                    } else {
                                      setState(() {
                                        if (allCategoryModel
                                                .advertisments[index].isFav ==
                                            false) {
                                          pr = ProgressDialog(
                                            context,
                                            isDismissible: false,
                                            type: ProgressDialogType.Normal,
                                          );

                                          pr.show();
                                          util
                                              .post(
                                            'Favorites?adID=${allCategoryModel.advertisments[index].adId}&userID=$jwt',
                                          )
                                              .then((result) {
                                            Navigator.pop(context);
                                            print("---------> $result");
                                            if (result.statusCode == 203) {
                                              setState(() {});
                                            } else if (result.statusCode == 500) {
                                              Alert(
                                                buttons: [
                                                  DialogButton(
                                                    child: Text(
                                                      allTranslations
                                                                  .currentLanguage ==
                                                              'ar'
                                                          ? "الرجوع"
                                                          : "Back",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20),
                                                    ),
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    width: 120,
                                                  )
                                                ],
                                                context: context,
                                                title: allTranslations
                                                            .currentLanguage ==
                                                        'ar'
                                                    ? "هناك مشكله فى السيرفر حاليا"
                                                    : "Success",
                                              ).show();
                                            } else {
                                              setState(() {
                                                allCategoryModel
                                                    .advertisments[index]
                                                    .isFav = true;
                                              });
                                              Alert(
                                                buttons: [
                                                  DialogButton(
                                                    child: Text(
                                                      allTranslations
                                                                  .currentLanguage ==
                                                              'ar'
                                                          ? "الرجوع"
                                                          : "Back",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20),
                                                    ),
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    width: 120,
                                                  )
                                                ],
                                                context: context,
                                                title: result.data.toString(),
                                              ).show();
                                            }
                                          }).catchError((err) {
                                            print(
                                                "333333333333333333333333#########" +
                                                    err.toString());
                                          });
                                        } else {
                                          print(
                                              'Favorites?adID=${allCategoryModel.advertisments[index]}&userID=$jwt');
                                          pr = ProgressDialog(
                                            context,
                                            isDismissible: false,
                                            type: ProgressDialogType.Normal,
                                          );

                                          pr.show();
                                          util
                                              .delete(
                                            'Favorites/${allCategoryModel.advertisments[index].adId}?userID=$jwt',
                                          )
                                              .then((result) {
                                            Navigator.pop(context);
                                            print("---------> $result");
                                            if (result.statusCode == 203) {
                                              setState(() {});
                                            } else if (result.statusCode == 500) {
                                              Alert(
                                                buttons: [
                                                  DialogButton(
                                                    child: Text(
                                                      allTranslations
                                                                  .currentLanguage ==
                                                              'ar'
                                                          ? "الرجوع"
                                                          : "Back",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20),
                                                    ),
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    width: 120,
                                                  )
                                                ],
                                                context: context,
                                                title: allTranslations
                                                            .currentLanguage ==
                                                        'ar'
                                                    ? "هناك مشكله فى السيرفر حاليا"
                                                    : "Success",
                                              ).show();
                                            } else {
                                              setState(() {
                                                allCategoryModel
                                                    .advertisments[index]
                                                    .isFav = false;
                                              });
                                              Alert(
                                                buttons: [
                                                  DialogButton(
                                                    child: Text(
                                                      allTranslations
                                                                  .currentLanguage ==
                                                              'ar'
                                                          ? "الرجوع"
                                                          : "Back",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20),
                                                    ),
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    width: 120,
                                                  )
                                                ],
                                                context: context,
                                                title: result.data.toString(),
                                              ).show();
                                            }
                                          }).catchError((err) {
                                            print(
                                                "333333333333333333333333#########" +
                                                    err.toString());
                                          });
                                        }
                                      });
                                    }
                                  });
                                },
                                isFav:
                                    allCategoryModel.advertisments[index].isFav ==
                                            false
                                        ? 0
                                        : 1),
                          );
                  },
                )),
    );
  }
}
