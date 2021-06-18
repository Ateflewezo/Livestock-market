import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:milyar/Language/all_translations.dart';
import 'package:milyar/Models/AuthModels/Cities.dart';
import 'package:milyar/Models/general/AllCategoriesModels.dart';
import 'package:milyar/Models/general/SearchModels.dart';
import 'package:milyar/ScoppedModels/ScoppedModels/Network_Utils.dart';
import 'package:milyar/Utils/color.dart';
import 'package:milyar/Widget/Buttons.dart';
import 'package:milyar/Widget/text.dart';
import 'package:milyar/pages/HomeScreen/HomeScreenDetails.dart';
import 'package:milyar/pages/HomeScreen/ProductCard.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toast/toast.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(BuildContext context, String text) {
    scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: "Cairo",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SearchModels searchModels = SearchModels();

  ProgressDialog pr;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  AllCategoryModel allCategoryModel = AllCategoryModel(advertisments: []);
// int pageNo;
  NetworkUtil _util = NetworkUtil();

  _getAboutClient(int pageNo) async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> addData = {
      "search": nameAds.text,
      "CityId": cityId,
      "pageNo": pageNo,
    };
    Response response =
        await _util.post('v1/Shop', body: FormData.fromMap(addData));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      setState(() {
        allCategoryModel = AllCategoryModel.fromJson(response.data);
        pageNo = allCategoryModel.pageNo;
        isLoading = false;
      });
    } else {}
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

  String jwt;
  _getFromCach() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      jwt = preferences.getString('id');
      print(jwt);
    });
  }

  _getpages() {
    if (allCategoryModel.advertisments.length < 6 &&
        allCategoryModel.pageNo == 1) {
      return SizedBox();
    } else if (allCategoryModel.advertisments.length < 6 &&
        allCategoryModel.pageNo > 1) {
      return Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Align(
            alignment: Alignment.bottomLeft,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.blue[400],
              onPressed: () {
                _getAboutClient(allCategoryModel.pageNo - 1);
              },
              child: Text(
                " السابق",
                style: TextStyle(color: Colors.white),
              ),
            )),
      );
    } else if (allCategoryModel.advertisments.length == 6 &&
        allCategoryModel.pageNo >= 1) {
      return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.blue[400],
              onPressed: () {
                _getAboutClient(allCategoryModel.pageNo + 1);
              },
              child: Text(" التالي ", style: TextStyle(color: Colors.white)),
            ),
            allCategoryModel.pageNo == 1
                ? SizedBox()
                : RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.blue[400],
                    onPressed: () {
                      _getAboutClient(allCategoryModel.pageNo - 1);
                    },
                    child: Text("  السابق  ",
                        style: TextStyle(color: Colors.white)),
                  ),
          ],
        ),
      );
    }
  }

  String search;
  TextEditingController nameAds = TextEditingController();
  bool cities = false;

  List<AllCitiesModels> citiees;
  AllCitiesModels allCitiesModels = AllCitiesModels();
  _getallCitiesClient() async {
    setState(() {
      cities = true;
    });

    Response response = await _util.post('v1/GetCities');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      setState(() {
        citiees = allCitiesModelsFromJson(jsonEncode(response.data));
        print(citiees.length);
        cities = false;
      });
    } else {}
  }

  String cityName;
  int cityId;
  void displaySubBottomSheet({
    BuildContext context,
    List<AllCitiesModels> citiees,
    setter,
  }) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          // return StatefulBuilder(builder: (context, ssetter) {
          return Container(
            width: double.infinity,
            height: 400,
            padding: EdgeInsets.all(9),
            child: Column(
              children: [
                (() {
                  return Text(allTranslations.currentLanguage == "en"
                      ? "Please choose your city"
                      : "من فضلك قم باختيار المدينة ");
                }()),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                 onTap: (){
                   setState(() {
                      cityName = "الكل";
                            cityId = 0;    
                            print("///////////////**********");
                            print(cityId.toString());         
                                      });
                                         setState(() {});

                                  Navigator.of(context).pop();
                 }, 
                  child: Text(
                                     "الكل",
                                      style: TextStyle(
                                          color: Color(
                                              getColorHexFromStr('#5FBB55'))),
                                    ),),
                                    SizedBox(height: 10,),
                                     Divider(height: 1,),
                cities
                    ? Center(
                        child: CupertinoActivityIndicator(
                          animating: true,
                          radius: 14,
                        ),
                      )
                    : Expanded(
                        child: ListView.separated(
                            shrinkWrap: true,
                            separatorBuilder: (context, index) => Divider(),
                            itemCount: citiees.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    cityName = citiees[index].cityName;
                                    cityId = citiees[index].cityId;
                                    print("ateffffff***************");
                                    print(cityName.toString());
                                    print(cityId.toString());
                                  });
                                  // setter(() {
                                  //   cityName = citiees[index].cityName;
                                  //   cityId = citiees[index].cityId;
                                  // });

                                  // setter(() {});
                                  setState(() {});

                                  Navigator.of(context).pop();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      citiees[index].cityName ?? "",
                                      style: TextStyle(
                                          color: Color(
                                              getColorHexFromStr('#5FBB55'))),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      )
              ],
            ),
          );
        });
    // });
  }

  @override
  void initState() {
    _getFromCach();
    searchModels.data = [];
    _getallCitiesClient();
    super.initState();
  }

  submitFavourite(BuildContext context, int id) async {
    print({"adID": id, "userID": jwt});
    pr = ProgressDialog(
      context,
      isDismissible: false,
      type: ProgressDialogType.Normal,
    );

    pr.show();
    _util
        .post(
      'Favorites?adID=$id&userID=$jwt',
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
                allTranslations.currentLanguage == 'ar' ? "الرجوع" : "Back",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
          context: context,
          title: allTranslations.currentLanguage == 'ar'
              ? "هناك مشكله فى السيرفر حاليا"
              : "Success",
        ).show();
      } else {
        Alert(
          buttons: [
            DialogButton(
              child: Text(
                allTranslations.currentLanguage == 'ar' ? "الرجوع" : "Back",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
          context: context,
          title: result.data.toString(),
        ).show();
      }
    }).catchError((err) {
      print("333333333333333333333333#########" + err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: allTranslations.currentLanguage == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Color(getColorHexFromStr('FBFEFF')),
            body: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: text(context, allTranslations.text('search'),
                      EdgeInsets.only(top: 20), Colors.blue, 18),
                ),
                Form(
                  key: formKey,
                  child: textFormFiledSearch(
                      context,
                      (val) {
                        if (val.isEmpty) {
                          return allTranslations.text('vaild_search');
                        } else {
                          return null;
                        }
                      },
                      TextInputType.text,
                      (val) {
                        setState(() {
                          search = val;
                        });
                      },
                      "ادخل كلمة البحث",
                      false,
                      nameAds,
                      SizedBox()
                      // Padding(
                      //   padding: const EdgeInsetsDirectional.only(end: 0.0),
                      //   child: InkWell(
                      //     onTap: () {
                      //       _getAboutClient();
                      //       // print("ateffffffff");
                      //       // print(nameAds.text);
                      //     },
                      //     child: Container(
                      //         height: 55,
                      //         width: 40,
                      //         decoration: BoxDecoration(
                      //             color: Colors.blue,
                      //             borderRadius: BorderRadius.circular(10)),
                      //         child: Icon(
                      //           Icons.search,
                      //           color: Colors.white,
                      //           size: 30,
                      //         )),
                      //   ),
                      // ),
                      ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 15, right: 10, left: 10),
                  child: SingleChildScrollView(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(
                            child: Container(
                          decoration: BoxDecoration(
                              color: Color(getColorHexFromStr('#E7E7E7'))
                                  .withOpacity(.3),
                              borderRadius: BorderRadius.circular(10)),
                          height: 50,
                          width: MediaQuery.of(context).size.width / 2,
                          child: InkWell(
                            onTap: () {
                              displaySubBottomSheet(
                                citiees: citiees,
                                context: context,
                              );
                            },
                            child: Center(
                              child: Text(cityName == null
                                  ? allTranslations.currentLanguage == "en"
                                      ? " city"
                                      : "اختر المدينة "
                                  : cityName),
                            ),
                          ),
                        )),
                        InkWell(
                            onTap: () {
                              print("##############");
                              print(nameAds.text.toString());
                              print(cityId.toString());
                              _getAboutClient(null);
                              //  Navigator.pop(context);
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width / 2.5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.blue,
                                  border: Border.all(color: Colors.blue)),
                              child: Center(
                                child: Text(
                                  "بحث",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),

                //------------------------////

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: <Widget>[
                //     text(
                //         context,
                //         allTranslations.text('search_result'),
                //         EdgeInsets.only(right: 30, left: 30, top: 20),
                //         Colors.blue,
                //         15),
                //     Padding(
                //       padding: EdgeInsets.only(right: 5, left: 5, top: 20),
                //       child: Text(
                //         allCategoryModel.advertisments == null
                //             ? allTranslations.currentLanguage == 'ar'
                //                 ? 'لا توجد'
                //                 : " 0 Result"
                //             : allCategoryModel.advertisments.length.toString() +
                //                 allTranslations.text('result'),
                //         style: TextStyle(
                //             fontWeight: FontWeight.bold,
                //             color: Color(getColorHexFromStr('D5D5D5'))),
                //       ),
                //     )
                //   ],
                // ),
//---------------------ItemsScreen-----------------------------------

                isLoading
                    ? Expanded(
                        child: ListView.builder(
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                height: 80,
                                margin: EdgeInsets.all(0),
                                child: Shimmer.fromColors(
                                    baseColor: Colors.black12.withOpacity(0.1),
                                    highlightColor:
                                        Colors.black.withOpacity(0.2),
                                    child: Container(
                                      color: Colors.red,
                                      width: MediaQuery.of(context).size.width,
                                      height: 80,
                                      margin: EdgeInsets.all(10),
                                    )),
                              );
                            }),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: allCategoryModel.advertisments.length,
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (context, index) {
                            return InkWell(
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
                                  name: allCategoryModel
                                      .advertisments[index].title,
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
                                            "من فضلك قم بتسجيل الدخول اولا",
                                            context,
                                            gravity: Toast.CENTER);
                                        return false;
                                      } else {
                                        submitFavourite(
                                          context,
                                          allCategoryModel
                                              .advertisments[index].adId,
                                        );
                                      }

                                      if (allCategoryModel
                                              .advertisments[index].isFav ==
                                          false) {
                                        allCategoryModel
                                            .advertisments[index].isFav = true;
                                      } else {
                                        allCategoryModel
                                            .advertisments[index].isFav = false;
                                      }
                                    });
                                  },
                                  isFav: allCategoryModel
                                              .advertisments[index].isFav ==
                                          false
                                      ? 0
                                      : 1),
                            );
                          },
                        ),
                      ),
                allCategoryModel.advertisments.isEmpty
                    ? SizedBox()
                    : SingleChildScrollView(
                        child: _getpages(),
                      )
              ],
            )),
      ),
    );
  }
}
