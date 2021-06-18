import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milyar/Language/all_translations.dart';
import 'package:milyar/Models/FavouriteModels.dart';
import 'package:milyar/Models/general/AllCategoriesModels.dart';
import 'package:milyar/ScoppedModels/ScoppedModels/Network_Utils.dart';
import 'package:milyar/Utils/color.dart';
import 'package:intl/intl.dart' as formDateTime;

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:milyar/Widget/text.dart';
import 'package:milyar/pages/HomeScreen/CardIamge.dart';
import 'package:milyar/pages/HomeScreen/DetailsModel.dart';
import 'package:share/share.dart';

import 'package:flutter/material.dart' as prifex0;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:url_launcher/url_launcher.dart';

class HomeScreenDetails extends StatefulWidget {
  final Advertisment idAds;

  const HomeScreenDetails({Key key, this.idAds}) : super(key: key);
  @override
  _HomeScreenDetailsState createState() => _HomeScreenDetailsState();
}

class _HomeScreenDetailsState extends State<HomeScreenDetails> {
  @override
  void initState() {
    _getDetails();

    super.initState();
  }

  NetworkUtil util = NetworkUtil();

  bool _isLoading = true;
  OrderDetailsModel orderDetailsModel = OrderDetailsModel();
  _getDetails() async {
    // setState(() {
    //   _isLoading = true;
    // });

  util
        .get(
      'Advertisments/${widget.idAds.adId}',
    )
        .then((result) {
      print("----------9999999999---------------- $result");

      if (result.statusCode == 200) {
        setState(() {
          print(result.data);
          orderDetailsModel = OrderDetailsModel.fromJson(result.data);
          image = [
            {"image": orderDetailsModel.imageUrl1},
            {"image": orderDetailsModel.imageUrl2},
            {
              "image": orderDetailsModel.imageUrl3,
            },
            {"image": orderDetailsModel.imageUrl4},
            {"image": orderDetailsModel.imageUrl5}
          ];

          _isLoading = false;
        });
      }
    });
  }

  TextEditingController comment = TextEditingController();
  List<Map<dynamic, String>> image = [];

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
            allTranslations.text('details'),
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
              size: 40,
              color: Colors.blue,
            ),
          ),
          centerTitle: true,
        ),
        body: _isLoading
            ? Center(
                child: CupertinoActivityIndicator(),
              )
            : ListView(
                shrinkWrap: true,
                primary: true,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                        child: Swiper(
                          itemBuilder: (BuildContext context, int index) {
                            return prifex0.Image.network(
                              "https://souq-mawashi.com" +
                                  image[index]['image'],
                              fit: BoxFit.fill,
                            );
                          },
                          onTap: (int index) {
                            Navigator.of(context).push(
                                PageRouteBuilder(pageBuilder: (_, __, ___) {
                              return CardImage(
                                images: image==null?"":image,
                              );
                            }));
                          },
                          itemCount: image.length,
                          pagination: new SwiperPagination(),
                          // control: new SwiperControl( ),
                          autoplay: image.length > 1 ? true : false,
                          outer: false,
                        ),
                      ),

//-------------------CardDetails-----------------------------
                      cardDetails(),
                    ],
                  ),

//----------------------ChatAndPhone------------------------------------
                  phoneAndChat(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text("التعليقات"),
                    ),
                  ),
//------------------------RateAndComments-------------------------------
                  ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: orderDetailsModel.comments?.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            margin: EdgeInsets.only(right: 10, left: 10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        orderDetailsModel
                                                .comments[index].name ??
                                            "",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        formDateTime.DateFormat("yyyy-MM-dd")
                                            .format(DateTime.parse(
                                                orderDetailsModel
                                                    .comments[index].date
                                                    .toString())),
                                        style: TextStyle(
                                            color: Colors.grey.withOpacity(.5)),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        formDateTime.DateFormat("hh:mm a")
                                            .format(DateTime.parse(
                                                orderDetailsModel
                                                    .comments[index].date
                                                    .toString())),
                                        style: TextStyle(
                                            color: Colors.grey.withOpacity(.5)),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(orderDetailsModel
                                      .comments[index].commentText),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                  InkWell(
                    onTap: () {
                      showGeneralDialog(
                        barrierLabel: "Barrier",
                        barrierDismissible: true,
                        barrierColor: Colors.black.withOpacity(0.5),
                        transitionDuration: Duration(milliseconds: 700),
                        context: context,
                        pageBuilder: (_, __, ___) {
                          return StatefulBuilder(builder: (context, setState) {
                            return Align(
                              alignment: Alignment.center,
                              child: Material(
                                child: Container(
                                  height: 250,
                                  child: SizedBox.expand(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // back(),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      Text(
                                        "اضف تعليقك",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.1),
                                                  spreadRadius: 5,
                                                  blurRadius: 7,
                                                  offset: Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            margin: EdgeInsets.only(
                                                top: 20, right: 5, left: 5),
                                            child: TextFormField(
                                              textDirection: TextDirection.ltr,
                                              controller: comment,
                                              maxLines: 2,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              textInputAction:
                                                  TextInputAction.newline,
                                              style:
                                                  TextStyle(color: Colors.blue),
                                              textAlign: TextAlign.end,
                                              decoration: InputDecoration(
                                                // prefixIcon: prefixIcon,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white,
                                                      width: 1.0),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                  borderSide: BorderSide(
                                                      color: Colors.white,
                                                      width: 1.0),
                                                ),
                                                labelText: "اكتب تعليقك هنا",
                                                fillColor: Colors.white,

                                                filled: true,
                                                labelStyle: TextStyle(
                                                  color: Color(
                                                      getColorHexFromStr(
                                                          "D3D3D3")),
                                                ),
                                              ),
                                            )),
                                      ),
                                      isSending
                                          ? Center(
                                              child:
                                                  CupertinoActivityIndicator(),
                                            )
                                          : InkWell(
                                              onTap: () {
                                                _sendDataToServer(setState);
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    right: 20, left: 20),
                                                height: 50,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: Center(
                                                  child: Text(
                                                    "تعليق",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                ),
                                                // color: Colors.amber,
                                              ),
                                            )
                                    ],
                                  )),
                                  margin: EdgeInsets.only(
                                      bottom: 50, left: 12, right: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                            );
                          });
                        },
                        transitionBuilder: (_, anim, __, child) {
                          return SlideTransition(
                            position:
                                Tween(begin: Offset(0, 1), end: Offset(0, 0))
                                    .animate(anim),
                            child: child,
                          );
                        },
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 20, left: 20),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Text(
                          "أضف تعليق",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      // color: Colors.amber,
                    ),
                  )
//----------------------Comments--------------------------------------
                ],
              ),
      ),
    );
  }

  bool isSending = false;

  _sendDataToServer(StateSetter setter) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setter(() {
      isSending = true;
    });
    FormData _formData = FormData.fromMap({
      "Name": preferences.getString("full_name"),
      "CommentText": comment.text,
      "UserId": preferences.getString('id'),
      "advID": widget.idAds.adId,
    });
    util.post("v1/addComment", body: _formData).then((result) {
      if (result.data["data"] != null) {
        setter(() {
          Timer(Duration(milliseconds: 1), () {});
          orderDetailsModel.comments.add(Comment(
              advId: widget.idAds.adId,
              commentId: 10000,
              commentText: comment.text,
              date: DateTime.now(),
              name: preferences.getString("full_name"),
              userId: preferences.getString('id')));
          isSending = false;
          comment.clear();
          Navigator.pop(context);
          Toast.show("تم إضافة التعليق بنجاح", context);
        });
      }
    });
  }

  Widget cardDetails() {
    return Padding(
      padding: const EdgeInsets.only(top: 220, left: 10, right: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.idAds.title ?? ""),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                
                                Share.share( 
                                 
                                 "https://play.google.com/store/apps/details?id=com.soqu.elmawashii",

                                  // 'https://souq-mawashi.com/Advertisments/Details/${widget.idAds.adId}',
                                );
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: Color(getColorHexFromStr('#E8F9EF')),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Icon(
                                  Icons.share,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 40,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: Color(getColorHexFromStr('#E8F9EF')),
                                  borderRadius: BorderRadius.circular(10)),
                              child: widget.idAds.isFav == true
                                  ? Icon(
                                      Icons.favorite,
                                      color: Colors.blue,
                                    )
                                  : Icon(
                                      Icons.favorite_border,
                                      color: Colors.blue,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),

//---------------------------------Rate--------------------

//---------------------------------Rate--------------------
//------------------------Location-----------------
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    prifex0.Image(
                      image: AssetImage('assets/location.png'),
                      height: 30,
                      color: Colors.blue,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        orderDetailsModel.cityName ?? "",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    )
                  ],
                ),
              ),
//-------------------------Location--------------------------
//----------------------AdvNumbrtDetails----------------------
              // Row(
              //   children: <Widget>[
              //     Padding(
              //       padding: const EdgeInsets.only(right: 7, left: 7),
              //       child: Text(
              //         allTranslations.text('nub_ads'),
              //         style: TextStyle(
              //             fontWeight: FontWeight.bold,
              //             color: Color(getColorHexFromStr('6ACD38'))),
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.only(right: 7, left: 7),
              //       child: Text(adsDetailsModels.data.code),
              //     )
              //   ],
              // ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  orderDetailsModel.description ?? "",
                  style: TextStyle(color: Colors.grey),
                ),
              ),

              Row(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue,
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  "${orderDetailsModel.categoryName}" ?? "",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
//----------------------AdvNumbrtDetails----------------------
            ],
          ),
        ),
      ),
    );
  }

  Widget phoneAndChat() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
            // height: 70,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text("طرق التواصل"),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          UrlLauncher.launch(
                              'tel:+${orderDetailsModel.userPhone ?? ""}');
                        },
                        child: Container(
                          height: 35,
                          width: 50,
                          color: Color(getColorHexFromStr('#F8F8F8')),
                          child: Center(
                              child: Icon(
                            Icons.phone,
                            color: Color(getColorHexFromStr('69CB31')),
                          )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 35,
                        width: 50,
                        color: Color(getColorHexFromStr('#F8F8F8')),
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              launchWhatsApp();
                            },
                            child: prifex0.Image(
                              image: AssetImage("assets/whatsapp.png"),
                              height: 20,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            )),
      ),
    );
  }

  void launchWhatsApp() async {
    String url() {
      if (Platform.isAndroid) {
        // add the [https]
        return "https://wa.me/${orderDetailsModel.userPhone}/?text=${Uri.parse("السلام عليكم")}"; // new line
      } else {
        // add the [https]
        return "https://api.whatsapp.com/send?phone=${orderDetailsModel.userPhone}=${Uri.parse("السلام عليكم")}"; // new line
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }
}
