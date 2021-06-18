import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:milyar/Language/all_translations.dart';
import 'package:milyar/Models/AuthModels/Cities.dart';
import 'package:milyar/Models/SubCata.dart';
import 'package:milyar/Models/general/AllCategoriesModels.dart';
import 'package:milyar/Models/general/SubCategoriesModels.dart';
import 'package:milyar/ScoppedModels/ScoppedModels/Network_Utils.dart';
import 'package:milyar/Utils/color.dart';
import 'package:milyar/Widget/Buttons.dart';
import 'package:milyar/pages/HomeScreen/HomeScreenDetails.dart';
import 'package:milyar/pages/HomeScreen/ProductCard.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toast/toast.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AllCategoryModel allCategoryModel = AllCategoryModel();
  String jwt;
  double longitude;
  double latitude;
  _getFromCach() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      jwt = preferences.getString('id');
      print(jwt);
    });
  }

  bool isLoading = false;

  bool cities = false;
  //int pageNo;
  NetworkUtil _util = NetworkUtil();

  _getAboutClient(int id, cityId, km,double lang,double lat, int pageNo) async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      jwt = preferences.getString('id');
    });
    Response response = await _util.post('v1/Shop',
        body: FormData.fromMap({
          "CategoryId": id,
          "CityId": cityId,
          "Km": km,
          "Lang": lang,
          "Lat": lat,
          "userID": jwt == null || jwt == '' ? null : jwt,
          "pageNo": pageNo,
        }));
    setState(() {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        setState(() {
          allCategoryModel = AllCategoryModel.fromJson(response.data);
          allCategoryModel.categories
              .insert(0, Category(categoryId: 0, categoryName: "الكل"));
          pageNo = allCategoryModel.pageNo;

          isLoading = false;
        });
      } else if (response.statusCode == 500) {
        print("--");
        Toast.show("حاول مره اخرى", context);
      } else {
        showInSnackBar(
            context,
            '',
            allTranslations.currentLanguage == 'ar'
                ? 'برجاء التأكد من الانترنت'
                : 'Please Check Internet');
      }
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
                _getAboutClient(null, null, null,null,null, allCategoryModel.pageNo - 1);
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
                _getAboutClient(null, null, null,null,null, allCategoryModel.pageNo + 1);
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
                      _getAboutClient(
                          null, null, null,null,null, allCategoryModel.pageNo - 1);
                    },
                    child: Text("  السابق  ",
                        style: TextStyle(color: Colors.white)),
                  ),
          ],
        ),
      );
    }
  }
  //=====================GetSlider---------------

  //-----------------------subCatoriges----------------
  SUbCategoryModels sUbCategoryModels = SUbCategoryModels();
  ProgressDialog pr;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  NetworkUtil util = NetworkUtil();
  SubCataModels subCataModels = SubCataModels();

//--------------------Fillter-------------------------------
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(BuildContext context, String text, String s) {
    scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        duration: Duration(microseconds: 2),
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

  bool getHome = false;

  List<AllCitiesModels> citiees;
  AllCitiesModels allCitiesModels = AllCitiesModels();
  _getallCitiesClient() async {
    setState(() {
      cities = true;
    });

    Response response = await util.post('v1/GetCities');
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
          return StatefulBuilder(builder: (context, ssetter) {
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
                                    setter(() {
                                      cityName = citiees[index].cityName;
                                      cityId = citiees[index].cityId;
                                    });

                                    setter(() {});
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
        });
  }

  @override
  void initState() {
    // _getFromCach().then((x){
    _getAboutClient(null, null, null, null,null,null,);
    //});

    // _getSlider();
    // _getHomeScreen();
    // _getallCitiesClient();

    _getallCitiesClient();
    super.initState();
  }

  bool refreshing = false;

  // CitiesData citiesData;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  String _selectedLocation; // Option 2

  TextEditingController _controller = TextEditingController();
//--------------------------------------------------
  showAlertDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: formKey,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setXState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(),
                    Text(
                      allTranslations.currentLanguage == 'ar'
                          ? "فلتر"
                          : "Filtter",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.close))
                  ],
                ),
                content: Container(
                  height: 250,
                  child: Column(
                    children: <Widget>[
//--------------- Cities-------------------
                      Padding(
                        padding: EdgeInsets.only(right: 5, left: 5, top: 20),
                        child: Center(
                            child: Container(
                          decoration: BoxDecoration(
                              color: Color(getColorHexFromStr('#E7E7E7'))
                                  .withOpacity(.3),
                              borderRadius: BorderRadius.circular(10)),
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: InkWell(
                            onTap: () {
                              displaySubBottomSheet(
                                  citiees: citiees,
                                  context: context,
                                  setter: setXState);
                            },
                            child: Center(
                              child: Text(cityName == null
                                  ? allTranslations.currentLanguage == "en"
                                      ? " city"
                                      : "المدينة "
                                  : cityName),
                            ),
                          ),
                        )),
                      ),

                      Padding(
                        padding: EdgeInsets.only(right: 5, left: 5, top: 20),
                        child: Center(
                            child: Container(
                          decoration: BoxDecoration(
                              color: Color(getColorHexFromStr('#E7E7E7'))
                                  .withOpacity(.3),
                              borderRadius: BorderRadius.circular(10)),
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: InkWell(
                            onTap: ()async {
                            SharedPreferences preferences = await SharedPreferences.getInstance();  
                             setState(() {
                              longitude= preferences.getDouble("longitude") ; 
                                latitude= preferences.getDouble("latitude") ;  
                                print("********atef");
                                print(longitude.toString());
                                print(latitude.toString()) ;                              
                                                          });

                                 _getAboutClient(
                                null,null,
                                null,
                                   longitude==null?null:longitude
                                    , latitude==null?null:latitude,
                                null);
                            Navigator.pop(context);
                              // _getAboutClient() async {
                              //   setState(() {
                              //     isLoading = true;
                              //   });

                              //   Response response = await _util.post('v1/Shop',
                              //       body: FormData.fromMap({
                              //         "Lang": 42.505278,
                              //         "Lat": 18.216944,
                              //       }));
                              //   setState(() {
                              //     if (response.statusCode >= 200 &&
                              //         response.statusCode < 300) {
                              //       setState(() {
                              //         // print("Ddsadsadasdsadasdasdadasdasdas");
                              //         allCategoryModel =
                              //             AllCategoryModel.fromJson(
                              //                 response.data);

                              //         isLoading = false;
                              //       });
                              //     } else if (response.statusCode == 500) {
                              //       Toast.show("fghsjkl", context);
                              //     }
                              //   });
                              // }
                            },
                            child: Center(
                              child: Text("الاقرب"),
                            ),
                          ),
                        )),
                      ),

                      // Padding(
                      //   padding: EdgeInsets.only(right: 5, left: 5, top: 20),
                      //   child: TextFormField(
                      //     // autovalidate: _autoValidate,
                      //     enabled: true,
                      //     controller: _controller,
                      //     textAlign: TextAlign.center,
                      //     keyboardType: TextInputType.phone,
                      //     style: TextStyle(
                      //         color: Color(getColorHexFromStr('#E8883E')),
                      //         fontSize: 15),
                      //     decoration: InputDecoration(
                      //         errorStyle: TextStyle(
                      //           color: Color(getColorHexFromStr('#E8883E')),
                      //           fontSize: 13,
                      //         ),
                      //         contentPadding: new EdgeInsets.symmetric(
                      //             vertical: 15.0, horizontal: 10.0),
                      //         border: OutlineInputBorder(
                      //           borderSide: BorderSide(
                      //               color: Color(getColorHexFromStr('#E7E7E7')),
                      //               width: 1.0),
                      //           borderRadius: BorderRadius.all(
                      //             Radius.circular(15),
                      //           ),
                      //         ),
                      //         enabledBorder: OutlineInputBorder(
                      //           borderRadius: BorderRadius.all(
                      //             Radius.circular(15),
                      //           ),
                      //           borderSide: BorderSide.none,
                      //         ),
                      //         filled: true,
                      //         hintText: allTranslations.currentLanguage == "ar"
                      //             ? "كيلومتر"
                      //             : "Km",
                      //         hintStyle: TextStyle(
                      //             color: Colors.black,
                      //             fontWeight: FontWeight.bold)),
                      //   ),
                      // ),
//--------------------------Buttons--------------------------------------
                      InkWell(
                          onTap: () {
                            print(catId);
                            _getAboutClient(
                                catId == null ? null : catId,
                                cityId == null ? null : cityId,
                                _controller.text.isEmpty
                                    ? null
                                    : int.parse(_controller.text),
                                    null,null,
                                null);
                            Navigator.pop(context);
                          },
                          child: buttons(
                            context,
                            allTranslations.currentLanguage == 'ar'
                                ? 'بحث'
                                : 'Search',
                            EdgeInsets.only(top: 20),
                          ))
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
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

  // submitFavourite(BuildContext context, int id) async {}

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: allTranslations.currentLanguage == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
            backgroundColor: Color(getColorHexFromStr('FBFEFE')),
            key: scaffoldKey,
            appBar: AppBar(
                toolbarHeight: 100,
                backgroundColor: Colors.white,
                elevation: 0,
                leading: SizedBox(),
                title: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Image(
                    width: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? MediaQuery.of(context).size.width / 2
                        : MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? MediaQuery.of(context).size.height / 2
                        : MediaQuery.of(context).size.height / 3,
                    fit: BoxFit.contain,
                    image: AssetImage(
                      "assets/logo_wide.png",
                    ),
                  ),
                ),
                centerTitle: true,
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: InkWell(
                      onTap: () {
                        showAlertDialog(context);
                      },
                      child: Container(
                        height: 50,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white
                          // Color(getColorHexFromStr("#EAFDF4"))
                          //     .withOpacity(.5),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.location_on,
                            size: 35,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  )
                ]),
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
                : Column(
                    children: <Widget>[
                      Card(
                        elevation: .2,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 20, left: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[],
                              ),
                            ),
                            //------------------------Category-------------------------------
                            // SizedBox(
                            //   height: 10,
                            // ),
                            category(),
                            SizedBox(
                              height: 6,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () {
                            setState(() {
                              refreshing = true;
                            });
                            return new Future.delayed(
                                const Duration(seconds: 3), () {
                              setState(() {
                                // _getAboutClient();
                                // _submitSubAds(context, null);
                              });
                            });
                          },
                          key: _refreshIndicatorKey,
                          child: allCategoryModel.advertisments.isEmpty
                              ? Center(child: Text("لا يوجد اعلانات"))
                              : ListView.builder(
                                  itemCount:
                                      allCategoryModel.advertisments?.length,
                                  shrinkWrap: true,
                                  primary: false,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomeScreenDetails(
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
                                                .advertisments[index]
                                                .cityName ??
                                            "",
                                        brandName: "",
                                        isMine: false,
                                        price: "0" ?? "",
                                        isFav: allCategoryModel
                                                    .advertisments[index]
                                                    .isFav ==
                                                false
                                            ? 0
                                            : 1,
                                        description: allCategoryModel
                                                .advertisments[index]
                                                .description ??
                                            "",
                                        onToggleTapped: () {
                                          setState(() {
                                            if (jwt == null) {
                                              Toast.show(
                                                  allTranslations
                                                              .currentLanguage ==
                                                          "ar"
                                                      ? "قم بتسجيل الدخول اولا"
                                                      : "Login First",
                                                  context);
                                            } else {
                                              setState(() {
                                                if (allCategoryModel
                                                        .advertisments[index]
                                                        .isFav ==
                                                    false) {
                                                  pr = ProgressDialog(
                                                    context,
                                                    isDismissible: false,
                                                    type: ProgressDialogType
                                                        .Normal,
                                                  );

                                                  //  pr.show();
                                                  util
                                                      .post(
                                                    'Favorites?adID=${allCategoryModel.advertisments[index].adId}&userID=$jwt',
                                                  )
                                                      .then((result) {
                                                    // Navigator.pop(context);
                                                    print("---------> $result");
                                                    print(
                                                        "atefffffffffffffffff***************");
                                                    print(
                                                        'Favorites?adID=${allCategoryModel.advertisments[index].isFav}&userID=$jwt');
                                                    if (result.statusCode ==
                                                        203) {
                                                      setState(() {});
                                                    } else if (result
                                                            .statusCode ==
                                                        500) {
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
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 20),
                                                            ),
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context),
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
                                                            .advertisments[
                                                                index]
                                                            .isFav = true;
                                                      });
                                                      // Alert(
                                                      //   buttons: [
                                                      //     DialogButton(
                                                      //       child: Text(
                                                      //         allTranslations
                                                      //                     .currentLanguage ==
                                                      //                 'ar'
                                                      //             ? "الرجوع"
                                                      //             : "Back",
                                                      //         style: TextStyle(
                                                      //             color: Colors
                                                      //                 .white,
                                                      //             fontSize: 20),
                                                      //       ),
                                                      //       onPressed: () =>
                                                      //           Navigator.pop(
                                                      //               context),
                                                      //       width: 120,
                                                      //     )
                                                      //   ],
                                                      //   context: context,
                                                      //   title: "تم بنجاح",
                                                      // ).show();
                                                    }
                                                  }).catchError((err) {
                                                    print(
                                                        "333333333333333333333333#########" +
                                                            err.toString());
                                                  });
                                                } else {
                                                  print(
                                                      "atefffffffffffffffff***************");
                                                  print(
                                                      'Favorites?adID=${allCategoryModel.advertisments[index].isFav}&userID=$jwt');
                                                  pr = ProgressDialog(
                                                    context,
                                                    isDismissible: false,
                                                    type: ProgressDialogType
                                                        .Normal,
                                                  );

                                                  // pr.show();
                                                  util
                                                      .delete(
                                                    'Favorites/${allCategoryModel.advertisments[index].adId}?userID=$jwt',
                                                  )
                                                      .then((result) {
                                                    // Navigator.pop(context);
                                                    print("ateffffffff");
                                                    print("---------> $result");
                                                    if (result.statusCode ==
                                                        203) {
                                                      setState(() {});
                                                    } else if (result
                                                            .statusCode ==
                                                        500) {
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
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 20),
                                                            ),
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context),
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
                                                            .advertisments[
                                                                index]
                                                            .isFav = false;
                                                      });
                                                      // Alert(
                                                      //   buttons: [
                                                      //     DialogButton(
                                                      //       child: Text(
                                                      //         allTranslations
                                                      //                     .currentLanguage ==
                                                      //                 'ar'
                                                      //             ? "الرجوع"
                                                      //             : "Back",
                                                      //         style: TextStyle(
                                                      //             color: Colors
                                                      //                 .white,
                                                      //             fontSize: 20),
                                                      //       ),
                                                      //       onPressed: () =>
                                                      //           Navigator.pop(
                                                      //               context),
                                                      //       width: 120,
                                                      //     )
                                                      //   ],
                                                      //   context: context,
                                                      //   title: "تم بنجاح",
                                                      // ).show();
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
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),
                      _getpages()
                    ],
                  )),
      ),
    );
  }

  int _selectedIndex = 0;
  int _selectedCat = 0;

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  _onSelectedCat(int index) {
    setState(() => _selectedCat = index);
  }

  String catName = 'توصيل';

  Widget category() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: allCategoryModel.categories?.length,
          itemBuilder: (BuildContext context, int index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    if (allCategoryModel.categories[index].categoryName ==
                        "الكل") {
                      catId = null;
                      _getAboutClient(null, null, null, null,null,null,);

                      _onSelectedCat(
                          allCategoryModel.categories[index].categoryId);
                      catName = allCategoryModel.categories[index].categoryName;
                    } else {
                      catId = allCategoryModel.categories[index].categoryId;
                      _getAboutClient(
                          allCategoryModel.categories[index].categoryId,
                          null,
                          null,
                          null,null,
                          null);

                      _onSelectedCat(
                          allCategoryModel.categories[index].categoryId);
                      catName = allCategoryModel.categories[index].categoryName;
                    }
                  },
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            allCategoryModel.categories[index].categoryName,
                            style: TextStyle(
                                color: _selectedCat ==
                                        allCategoryModel
                                            .categories[index].categoryId
                                    ? Colors.blue
                                    : Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 1,
                              height: 20,
                              color: _selectedCat ==
                                      allCategoryModel
                                          .categories[index].categoryId
                                  ? Colors.blue
                                  : Colors.white,
                            ),
                          ),
                        ],
                      ),
                      _selectedCat ==
                              allCategoryModel.categories[index].categoryId
                          ? Container(
                              width: 49,
                              height: .7,
                              color: Colors.blue,
                            )
                          : Container()
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  int catId;

  var _value;
  String valueType;

  Widget type() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setXState) {
        return DropdownButton(
          hint: Text(
            allTranslations.currentLanguage == 'ar'
                ? 'نوع الإعلان'
                : "Ads Type",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(getColorHexFromStr('#282828')),
                fontFamily: "Cairo",
                fontSize: 15),
          ),
          iconEnabledColor: Colors.grey,
          iconDisabledColor: Colors.grey,
          onChanged: (value) {
            setXState(() {
              _value = value;
              print(value);
              if (value == '1') {
                valueType = 'order';
              } else {
                valueType = "provider";
              }
            });
          },
          value: _value,
          isExpanded: true,
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Cairo",
            fontSize: 20.0,
          ),
          items: [
            DropdownMenuItem<String>(
              value: "1",
              child: Text("طالب توصيل",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(getColorHexFromStr('#282828')),
                      fontFamily: "Cairo",
                      fontSize: 15)),
            ),
            DropdownMenuItem<String>(
              value: "2",
              child: Text("مقدم توصيل",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(getColorHexFromStr('#282828')),
                      fontFamily: "Cairo",
                      fontSize: 15)),
            ),
          ],
          // onChanged: (String value) async {
          //   setXState(() {
          //     citiesData = value;
          //   });
          // },
        );
      },
    );
  }

  showAlertDialogOrderType(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: formKey,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setXState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(),
                    Text(
                      allTranslations.currentLanguage == 'ar'
                          ? "فلتر التوصيل"
                          : "Filtter",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.close))
                  ],
                ),
                content: Container(
                  height: 200,
                  child: Column(
                    children: <Widget>[
//--------------- Cities-------------------
                      Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Color(getColorHexFromStr('#FAFAFA')),
                              borderRadius: BorderRadius.circular(15)),
                          child: DropdownButtonHideUnderline(
                            child: type(),
                          )),

//--------------------------Buttons--------------------------------------
                      InkWell(
                          onTap: () {
                            // _submiFillterType(context);
                          },
                          child: buttons(
                            context,
                            allTranslations.currentLanguage == 'ar'
                                ? 'البحث'
                                : 'Search',
                            EdgeInsets.only(top: 20),
                          ))
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
