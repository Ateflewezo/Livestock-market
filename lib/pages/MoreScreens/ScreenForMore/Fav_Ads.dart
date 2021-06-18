import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milyar/Language/all_translations.dart';
import 'package:milyar/Models/FavouriteModels.dart';
import 'package:milyar/Models/SubAdsModel.dart';
import 'package:milyar/Models/general/AllCategoriesModels.dart';
import 'package:milyar/ScoppedModels/ScoppedModels/Network_Utils.dart';
import 'package:milyar/Utils/color.dart';
import 'package:milyar/pages/HomeScreen/HomeScreenDetails.dart';
import 'package:milyar/pages/HomeScreen/ProductCard.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class FavouriteAds extends StatefulWidget {
  @override
  _FavouriteAdsState createState() => _FavouriteAdsState();
}

class _FavouriteAdsState extends State<FavouriteAds> {
  FavModel getFavouriteModels = FavModel();
  bool isLoading = false;
  String jwt;
  _getFromCach() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      jwt = preferences.getString('id');
      _getFavClient();
      print(jwt);
    });
  }

  ProgressDialog pr;

  List<FavModel> fav = [];
  NetworkUtil _util = NetworkUtil();
 
   Advertisment atef ;
  _getFavClient() async {
    setState(() {
      isLoading = true;
    });
    print("Favorites?userID=$jwt");
    Response response = await _util.get(
      "Favorites?userID=$jwt",
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      setState(() {
        fav = favModelFromJson(jsonEncode(response.data));
        //print(favModelFromJson(jsonEncode(response.data)));
        atef = new Advertisment();
        if(fav.length!=0){

         var currentAd = fav.first;

        atef.adId=currentAd.adId;
        atef.title =currentAd.title;
        atef.description = currentAd.description;
        atef.cityName =currentAd.cityName;
        atef.categoryName = currentAd.categoryName;
        atef.isFav = currentAd.isFav;
        atef.imageUrl1 =currentAd.imageUrl1;
        isLoading = false;
        }
      });
    } else {}
  }

  @override
  void initState() {
    _getFromCach();
    // _getFavClie nt();
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
              allTranslations.text('fav_adv'),
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
            leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.keyboard_arrow_right,
                  size: 30,
                  color: Colors.blue,
                )),
            centerTitle: true,
          ),
          body: 
          // isLoading
          //     ? Center(
          //         child: CupertinoActivityIndicator(
          //           animating: true,
          //           radius: 15,
          //         ),
          //       )
          //     : 
              fav.isEmpty?Center(child: Text("لايوجد اعلانات مفضلة")):
              ListView.builder(
                  itemCount: fav.length==0?0:fav.length ,
                  shrinkWrap: true,
                  primary: false,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreenDetails(
                                  
                                     idAds:atef
                                    //     allCategoryModel.advertisments[index],
                                    ))).then((value) {
                          // _getHomeScreen();
                        });
                      },
                      child: productCard(
                          context: context,
                          name: fav[index]?.title,
                          img: "https://souq-mawashi.com" +
                              fav[index].imageUrl1,
                          address: fav[index].cityName ?? "",
                          brandName: "",
                          isMine: false,
                          price: "0" ?? "",
                          isFav: fav[index]?.isFav == false ? 0 : 1,
                          description: fav[index]?.description ?? "",
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
                                  if (fav[index]?.isFav == false) {
                                    pr = ProgressDialog(
                                      context,
                                      isDismissible: false,
                                      type: ProgressDialogType.Normal,
                                    );

                                    // pr.show();
                                    _util
                                        .post(
                                      'Favorites?adID=${fav[index]?.adId}&userID=$jwt',
                                    )
                                        .then((result) {
                                     // Navigator.pop(context);
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
                                          fav[index]?.isFav = true;
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
                                        //             color: Colors.white,
                                        //             fontSize: 20),
                                        //       ),
                                        //       onPressed: () =>
                                        //           Navigator.pop(context),
                                        //       width: 120,
                                        //     )
                                        //   ],
                                        //   context: context,
                                        //   title: "تم الغا",
                                        // ).show();
                                      }
                                    }).catchError((err) {
                                      print(
                                          "333333333333333333333333#########" +
                                              err.toString());
                                    });
                                  } else {
                                    print(
                                        'Favorites?adID=${fav[index]?.adId}&userID=$jwt');
                                    pr = ProgressDialog(
                                      context,
                                      isDismissible: false,
                                      type: ProgressDialogType.Normal,
                                    );

                                    // pr.show();
                                    _util
                                        .delete(
                                      'Favorites/${fav[index]?.adId}?userID=$jwt',
                                    )
                                        .then((result) {

                                     // Navigator.pop(context);
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
                                          fav[index]?.isFav = false;
                                          fav.removeWhere((item) => item.isFav ==false);
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
                                        //             color: Colors.white,
                                        //             fontSize: 20),
                                        //       ),
                                        //       onPressed: () =>
                                        //           Navigator.pop(context),
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
        ));
  }
}
