import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:milyar/Language/all_translations.dart';
import 'package:milyar/Models/AuthModels/DeleteAdsModels.dart';
import 'package:milyar/Models/SubAdsModel.dart';
import 'package:milyar/Models/general/AllCategoriesModels.dart';
import 'package:milyar/ScoppedModels/ScoppedModels/Network_Utils.dart';

import 'package:milyar/Utils/color.dart';
import 'package:milyar/pages/Adv_Screens/Adv_Screen.dart';
import 'package:milyar/pages/Adv_Screens/EditAds.dart';
import 'package:milyar/pages/HomeScreen/HomeScreenDetails.dart';
import 'package:milyar/pages/HomeScreen/ProductCard.dart';
import 'package:milyar/pages/MoreScreens/ScreenForMore/Models/MyAds.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toast/toast.dart';

class MyAds extends StatefulWidget {
  @override
  _MyAdsState createState() => _MyAdsState();
}

class _MyAdsState extends State<MyAds> {
  // SubcategoriesAdsModels myAdsModels = SubcategoriesAdsModels();
  bool isLoading = false;

  NetworkUtil _util = NetworkUtil();
  ProgressDialog pr;

  bool deleteAds = false;
  DeleteAdsModels deleteAdsModels = DeleteAdsModels();

  _submit(BuildContext context, int index) async {
    pr = ProgressDialog(
      context,
      isDismissible: false,
      type: ProgressDialogType.Normal,
    );
    // SharedPreferences prfs = await SharedPreferences.getInstance();

    pr.update(
        message: allTranslations.currentLanguage == 'ar'
            ? "يرجى الانتظار"
            : "Loading",
        progress: 4,
        maxProgress: 10.0);

    pr.show();
    _util
        .delete(
      'Advertisments/$index',
    )
        .then((result) {
      if (result.statusCode == 200) {
        setState(() {
          pr.hide();
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
                ? "تم حذف الإعلان بنجاح"
                : "Ad has been removed successfully",
          ).show();
          myAds.removeWhere((element) {
            return element.adId == index;
          });
        });
      } else {
        pr.hide();

        showDialog(
            context: context,
            builder: (BuildContext context) {
              // print(result.data['message']);
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                title: Text(
                  allTranslations.currentLanguage == 'ar'
                      ? "هناك مشكلة فى السيرفر"
                      : "Server Error",
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
      pr.hide();

      print("333333333333333333333333#########" + err.toString());
    });
  }

  String jwt;
   List<MyAdsModels> myAds;
// List<Advertisment> myAds;
 Advertisment atef;
  _getAboutClient() async {
    SharedPreferences prfs = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
      jwt = prfs.getString("jwt");
    });

    print(prfs.getString("jwt"));
    Response response =
        await _util.get('UserAdvertisments?userID=${prfs.getString("id")}');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      setState(() {
        myAds = myAdsModelsFromJson(jsonEncode(response.data));
       //myAds = Advertisment.fromJson(response.data);
       //
       if(myAds.length != 0)
       {

        atef = new Advertisment();
        var currentAd = myAds.first;
        atef.adId=currentAd.adId;
        atef.title =currentAd.title;
        atef.description = currentAd.description;
        atef.isPact = currentAd.isPact;
        atef.isPaid =currentAd.isPaid;
        atef.userId = currentAd.userId;
        atef.cityId = currentAd.cityId;
        atef.cityName =currentAd.cityName;
        atef.lang = double.parse(currentAd.lang.toString());
        atef.lat = double.parse(currentAd.lat.toString());
        atef.userPhone = currentAd.userPhone;
        atef.categoryName = currentAd.categoryName;
        atef.categoryId = currentAd.categoryId;
        atef.km = currentAd.km;
        atef.pageNo = 1;
        atef.isFav = currentAd.isFav;
        atef.search = currentAd.search;
        atef.imageUrl1 =currentAd.imageUrl1;
        atef.imageUrl2=currentAd.imageUrl2;
        atef.imageUrl3=currentAd.imageUrl3;
        atef.imageUrl4=currentAd.imageUrl4;
        atef.imageUrl5=currentAd.imageUrl5;
       }

        // myAdsModels = SubcategoriesAdsModels.fromJson(response.data);
        isLoading = false;
      });
    } else {}
  }

  @override
  void initState() {
    _getAboutClient();
    super.initState();
  }

  submitFavourite(BuildContext context, int id) async {
    pr = ProgressDialog(
      context,
      isDismissible: false,
      type: ProgressDialogType.Normal,
    );

    SharedPreferences preferences = await SharedPreferences.getInstance();

    Map<String, dynamic> _headers = {
      "Authorization": "Bearer " + preferences.getString("jwt"),
    };

    pr.show();
    _util.post('client/toggle_fav_ad/$id', headers: _headers).then((result) {
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
          title: result.data['message'],
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
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            allTranslations.text('mads'),
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
        body: isLoading
            ? Center(
                child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
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
            : myAds.length == 0
                ? Center(
                    child: Text(allTranslations.currentLanguage == "ar"
                        ? 'لا توجد اعلانات'
                        : "No Ads"),
                  )
                : ListView.builder(
                    itemCount: myAds.length,
                    shrinkWrap: true,
                    primary: false,
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreenDetails(
                                    

                                        idAds: atef,
                                        )));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 15, left: 15, top: 10, bottom: 10),
                            child: Container(
                              // height: 130,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(.2),
                                    blurRadius: 10.0, // soften the shadow
                                    spreadRadius: 0.0, //extend the shadow
                                    offset: Offset(
                                      2.0, // Move to right 10  horizontally
                                      2.0, // Move to bottom 10 Vertically
                                    ),
                                  )
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Container(
                                      height: 100,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7)),
                                        image: DecorationImage(
                                          // image: AssetImage("assets/icons/iphone.png"),
                                          image: NetworkImage(
                                              "https://souq-mawashi.com" +
                                                  myAds[index].imageUrl1),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // SizedBox(width: 2,),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  280,
                                              child: Text(
                                                myAds[index].title ?? "",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Color(
                                                        getColorHexFromStr(
                                                            '082334')),
                                                    // fontFamily: AppTheme.boldFont,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w800),
                                                maxLines: 1,
                                              ),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8, left: 8),
                                                child: IconButton(
                                                  onPressed: () {
                                                    // print("ateffffff");
                                                    // print(myAds[index].adId.toString());
                                                    _submit(context,
                                                        myAds[index].adId);
                                                  },
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.blue,
                                                    // color: AppTheme.primaryColor,
                                                  ),
                                                )),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8, left: 8),
                                                child: IconButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    EditAds(
                                                                      idAds: myAds[
                                                                              index]
                                                                          .adId,
                                                                    )));
                                                  },
                                                  icon: Icon(
                                                    Icons.edit,
                                                    color: Colors.blue,
                                                    // color: AppTheme.primaryColor,
                                                  ),
                                                )),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Icon(
                                              Icons.location_on,
                                              size: 15,
                                              color: Colors.blue,
                                              // color: AppTheme.primaryColor,
                                            ),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  170,
                                              child: AutoSizeText(
                                                myAds[index].cityName ?? "",
                                                maxLines: 1,
                                                minFontSize: 9,
                                                maxFontSize: 13,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 12,
                                                  // fontFamily: AppTheme.fontName,
                                                  // fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              50,
                                          child: AutoSizeText(
                                            myAds[index].description,
                                            maxLines: 1,
                                            minFontSize: 14,
                                            maxFontSize: 16,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Color(getColorHexFromStr(
                                                  "#808080")),
                                              fontSize: 13,

                                              // fontFamily: AppTheme.fontName,
                                              // fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          // productCard(
                          //     context: context,
                          //     name: myAds[index].title,
                          //     img: ,
                          //     address: myAds[index].cityName ?? "",
                          //     brandName: "",
                          //     isMine: false,
                          //     price: "0" ?? "",
                          //     description: myAds[index].description ?? "",
                          //     onToggleTapped:
                          //     isFav: myAds[index].isFav == false ? 0 : 1),
                          );
                    },
                  ),
      ),
    );
  }
}
