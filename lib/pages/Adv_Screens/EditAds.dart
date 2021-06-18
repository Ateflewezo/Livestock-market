import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:milyar/Models/AuthModels/Cities.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prifix;

import 'package:milyar/Language/all_translations.dart';
// import 'package:milyar/Models/AdsDetailsModel.dart';
import 'package:milyar/Models/AdsDetailsModel.dart' as prefix1;
import 'package:milyar/Models/AuthModels/AllCreateAdsModels.dart';
import 'package:milyar/Models/AuthModels/DeleteMessageModels.dart';
import 'package:milyar/Models/AuthModels/UpdateAdsModels.dart';
import 'package:milyar/Models/cataogriesModels.dart';
import 'package:milyar/Models/general/AllCategoriesModels.dart';
import 'package:milyar/ScoppedModels/ScoppedModels/Network_Utils.dart';
import 'package:milyar/Utils/color.dart';
import 'package:milyar/Widget/Buttons.dart';
import 'package:milyar/Widget/text.dart';
import 'package:milyar/pages/Adv_Screens/EditModel.dart';
import 'package:milyar/pages/bottomNavigationBar.dart/BottomNavigationApp.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path/path.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:flutter/services.dart';
import 'package:milyar/Models/general/AllCountriesModels.dart' as prefix;

class EditAds extends StatefulWidget {
  final int idAds;

  const EditAds({
    Key key,
    this.idAds,
  }) : super(key: key);
  @override
  _EditAdsState createState() => _EditAdsState();
}

class _EditAdsState extends State<EditAds> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

//----------------------Cateroies--------------------------
  AllCategoryModels allCategoryModels = AllCategoryModels();

  bool isLoading = false;

  AllCategoryModel allCategoryModel = AllCategoryModel();
  String jwt;
  _getFromCach() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      jwt = preferences.getString('id');
      print(jwt);
    });
  }

  bool cities = false;

  NetworkUtil _util = NetworkUtil();

  _getAboutClient() async {
    setState(() {
      // isLoading = true;
    });

    Response response = await _util.post(
      'v1/Shop',
    );
    setState(() {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        setState(() {
          allCategoryModel = AllCategoryModel.fromJson(response.data);

          // isLoading = false;
        });
      } else if (response.statusCode == 500) {
        print("kjkjkjjkjkjjkjkjkjjkkjkjjkkjjjkjjjkjkjjkjkj");
      }
    });
  }

  Subcategory subs;
  String catName;
  int catId;
  DataModels dataModels;
  void displaySubBottomSheet({
    BuildContext context,
  }) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            width: double.infinity,
            height: 400,
            padding: EdgeInsets.all(9),
            child: Column(
              children: [
                (() {
                  return Text(allTranslations.currentLanguage == "en"
                      ? "Please choose your Categories"
                      : "من فضلك قم باختيار الصنف ");
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
                            itemCount: allCategoryModel.categories.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    catName = allCategoryModel
                                        .categories[index].categoryName;
                                    catId = allCategoryModel
                                        .categories[index].categoryId;
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      allCategoryModel
                                              .categories[index].categoryName ??
                                          "",
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
  }

//----------------------Countries--------------------

  // List<City> cities;

//----------------------------------------------------
  List<dynamic> selectedImages = [];

  void _imagePicker(BuildContext context, int type) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            actions: <Widget>[
              CupertinoButton(
                child: Row(
                  children: <Widget>[
                    Icon(
                      CupertinoIcons.photo_camera_solid,
                      color: Color(getColorHexFromStr("#2c6468")),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      allTranslations.currentLanguage == 'ar'
                          ? "الكاميرا"
                          : "camera",
                      style: TextStyle(
                        color: Color(getColorHexFromStr("#307e85")),
                        fontSize: 15,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
                onPressed: () => _getImage(context, ImageSource.camera, type),
              ),
              CupertinoButton(
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.insert_photo,
                      color: Color(getColorHexFromStr("#2c6468")),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      allTranslations.currentLanguage == 'ar'
                          ? "الاستديو"
                          : "gallery",
                      style: TextStyle(
                        color: Color(getColorHexFromStr("#307e85")),
                        fontSize: 15,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
                onPressed: () => _getImage(context, ImageSource.gallery, type),
              ),
            ],
          );
        });
  }

  File mutlimageUrl1;
  File mutlimageUrl2;
  File mutlimageUrl3;
  File mutlimageUrl4;
  File mutlimageUrl5;
  void _getImage(BuildContext context, ImageSource source, int type) {
    ImagePicker.pickImage(source: source, maxWidth: 400.0).then((File image) {
      if (image != null) {
        setState(() {
          if (type == 1) {
            mutlimageUrl1 = image;
          } else if (type == 2) {
            mutlimageUrl2 = image;
          } else if (type == 3) {
            mutlimageUrl3 = image;
          } else if (type == 4) {
            mutlimageUrl4 = image;
          } else {
            mutlimageUrl5 = image;
          }
        });
      }
      Navigator.pop(context);
    });
  }

  // Widget _adImage(dynamic image) {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Stack(
  //       children: <Widget>[
  //         Container(
  //           height: 100,
  //           width: 100,
  //           decoration: BoxDecoration(
  //             border: Border.all(
  //               style: BorderStyle.solid,
  //               color: Color(getColorHexFromStr("#307e85")),
  //               width: 2,
  //             ),
  //             borderRadius: BorderRadius.circular(12),
  //             image: DecorationImage(
  //               image: image is File ? FileImage(image) : NetworkImage(image),
  //               fit: BoxFit.cover,
  //             ),
  //           ),
  //         ),
  //         InkWell(
  //           onTap: () {
  //             setState(() {
  //               selectedImages.remove(image);
  //             });
  //             _deleteImage(this.context, imagea.id);
  //           },
  //           child: Align(
  //             alignment: Alignment.topLeft,
  //             child: Card(
  //               elevation: 7.0,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(10.0),
  //               ),
  //               child: Container(
  //                 height: 20,
  //                 width: 20,
  //                 decoration: BoxDecoration(
  //                   gradient: LinearGradient(
  //                     // Where the linear gradient begins and ends
  //                     begin: Alignment.centerRight,
  //                     end: Alignment.centerLeft,
  //                     // Add one stop for each color. Stops should increase from 0 to 1
  //                     stops: [0.01, 0.9],
  //                     colors: [
  //                       // Colors are easy thanks to Flutter's Colors class.

  //                       Color(
  //                         getColorHexFromStr("#315261"),
  //                       ),
  //                       Color(
  //                         getColorHexFromStr("#50b5aa"),
  //                       ),
  //                     ],
  //                   ),
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //                 child: Center(
  //                     child: Icon(
  //                   Icons.close,
  //                   color: Colors.white,
  //                   size: 15,
  //                 )),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Subcategory subcategory;
  prefix1.ImageX imagea;
  prefix.City selectCities;
  TextEditingController citiesController = TextEditingController();
  String name, discribion, whatsApp;
  // AdsDetailsModels adsDetailsModels = AdsDetailsModels();
  TextEditingController nameAds = TextEditingController();
  TextEditingController discribtionName = TextEditingController();
  // TextEditingController catName = TextEditingController();
  TextEditingController citiesName = TextEditingController();
  TextEditingController countName = TextEditingController();
  TextEditingController whatsAppMobile = TextEditingController();
  TextEditingController price = TextEditingController();
  List<AllCitiesModels> citiees;
  AllCitiesModels allCitiesModels = AllCitiesModels();
  AdsDetailsModels adsDetailsModels = AdsDetailsModels();

  _getAds() async {
    setState(() {
      isLoading = true;
    });

    Response response = await _util.get(
      'Advertisments/${widget.idAds}',
    );
    setState(() {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        setState(() {
          adsDetailsModels = AdsDetailsModels.fromJson(response.data);
          nameAds.text = adsDetailsModels.title;
          catName = adsDetailsModels.categoryName;
          catId = adsDetailsModels.categoryId;

          cityName = adsDetailsModels.cityName;
          cityId = adsDetailsModels.cityId;
          discribtionName.text = adsDetailsModels.description;
          isLoading = false;
        });
      } else if (response.statusCode == 500) {
        print("kjkjkjjkjkjjkjkjkjjkkjkjjkkjjjkjjjkjkjjkjkj");
      }
    });
  }

  _getallCitiesClient() async {
    setState(() {
      cities = true;
    });

    Response response = await _util.post('v1/GetCities');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      setState(() {
        citiees = allCitiesModelsFromJson(jsonEncode(response.data));
        print(citiees.length);
        // allCitiesModels = AllCitiesModels.fromJson(response.data);
        cities = false;
      });
    } else {}
  }

  int countriesId, citiesId, coutId;
  @override
  void initState() {
    _getFromCach();
    _getallCitiesClient();
    _getAboutClient();
    _getAds();
    super.initState();
  }

  String cityName;
  int cityId;
  void displaySubBottomSheetCity(
      {BuildContext context, List<AllCitiesModels> citiees}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
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
                                  setState(() {
                                    cityName = citiees[index].cityName;
                                    cityId = citiees[index].cityId;
                                  });
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
  }

  bool imageUrl1 = false;
  bool imageUrl2 = false;
  bool imageUrl3 = false;
  bool imageUrl4 = false;
  bool imageUrl5 = false;
  String subName;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: allTranslations.currentLanguage == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.keyboard_arrow_right),
            iconSize: 40,
            color: Colors.blue,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            allTranslations.currentLanguage == 'ar'
                ? "تعديل اعلان "
                : "Edit Ads",
            style: TextStyle(color: Colors.blue),
          ),
          centerTitle: true,
        ),
        key: scaffoldKey,
        body: isLoading
            ? Center(
                child: CupertinoActivityIndicator(
                  animating: true,
                  radius: 14,
                ),
              )
            : ListView(
                children: <Widget>[
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 120,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: ScrollPhysics(),
                            child: Row(
                              children: [
                                imageUrl1 == false
                                    ? Stack(
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 80,
                                            margin: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(9),
                                            ),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                child: prifix.Image(
                                                  image: NetworkImage(
                                                    "https://souq-mawashi.com" +
                                                        adsDetailsModels
                                                            .imageUrl1,
                                                  ),
                                                  fit: BoxFit.cover,
                                                )),
                                          ),
                                          Positioned(
                                            top: 10,
                                            left: 10,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  imageUrl1 = true;
                                                });
                                              },
                                              child: Container(
                                                // width: 20,
                                                // height: 20,
                                                margin: EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    : Stack(
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 80,
                                            margin: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(9),
                                            ),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                child: mutlimageUrl1 == null
                                                    ? InkWell(
                                                        onTap: () {
                                                          _imagePicker(
                                                              context, 1);
                                                        },
                                                        child: Center(
                                                            child: Icon(
                                                          Icons.camera_alt,
                                                          size: 50,
                                                          color: Colors.black,
                                                        )),
                                                      )
                                                    : InkWell(
                                                        onTap: () {
                                                          _imagePicker(
                                                              context, 1);
                                                        },
                                                        child: prifix.Image(
                                                          image: FileImage(
                                                              mutlimageUrl1),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )),
                                          ),
                                        ],
                                      ),
                                imageUrl2 == false
                                    ? Stack(
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 80,
                                            margin: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(9),
                                            ),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                child: prifix.Image(
                                                  image: NetworkImage(
                                                    "https://souq-mawashi.com" +
                                                        adsDetailsModels
                                                            .imageUrl2,
                                                  ),
                                                  fit: BoxFit.cover,
                                                )),
                                          ),
                                          Positioned(
                                            top: 10,
                                            left: 10,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  imageUrl2 = true;
                                                });
                                              },
                                              child: Container(
                                                // width: 20,
                                                // height: 20,
                                                margin: EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    : Stack(
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 80,
                                            margin: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(9),
                                            ),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                child: mutlimageUrl2 == null
                                                    ? InkWell(
                                                        onTap: () {
                                                          _imagePicker(
                                                              context, 2);
                                                        },
                                                        child: Center(
                                                            child: Icon(
                                                          Icons.camera_alt,
                                                          size: 50,
                                                          color: Colors.black,
                                                        )),
                                                      )
                                                    : InkWell(
                                                        onTap: () {
                                                          _imagePicker(
                                                              context, 2);
                                                        },
                                                        child: prifix.Image(
                                                          image: FileImage(
                                                              mutlimageUrl2),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )),
                                          ),
                                        ],
                                      ),
                                imageUrl3 == false
                                    ? Stack(
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 80,
                                            margin: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(9),
                                            ),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                child: prifix.Image(
                                                  image: NetworkImage(
                                                    "https://souq-mawashi.com" +
                                                        adsDetailsModels
                                                            .imageUrl3,
                                                  ),
                                                  fit: BoxFit.cover,
                                                )),
                                          ),
                                          Positioned(
                                            top: 10,
                                            left: 10,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  imageUrl3 = true;
                                                });
                                              },
                                              child: Container(
                                                // width: 20,
                                                // height: 20,
                                                margin: EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    : Stack(
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 80,
                                            margin: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(9),
                                            ),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                child: mutlimageUrl3 == null
                                                    ? InkWell(
                                                        onTap: () {
                                                          _imagePicker(
                                                              context, 3);
                                                        },
                                                        child: Center(
                                                            child: Icon(
                                                          Icons.camera_alt,
                                                          size: 50,
                                                          color: Colors.black,
                                                        )),
                                                      )
                                                    : InkWell(
                                                        onTap: () {
                                                          _imagePicker(
                                                              context, 3);
                                                        },
                                                        child: prifix.Image(
                                                          image: FileImage(
                                                              mutlimageUrl3),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )),
                                          ),
                                        ],
                                      ),
                                imageUrl4 == false
                                    ? Stack(
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 80,
                                            margin: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(9),
                                            ),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                child: prifix.Image(
                                                  image: NetworkImage(
                                                    "https://souq-mawashi.com" +
                                                        adsDetailsModels
                                                            .imageUrl4,
                                                  ),
                                                  fit: BoxFit.cover,
                                                )),
                                          ),
                                          Positioned(
                                            top: 10,
                                            left: 10,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  imageUrl4 = true;
                                                });
                                              },
                                              child: Container(
                                                // width: 20,
                                                // height: 20,
                                                margin: EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    : Stack(
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 80,
                                            margin: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(9),
                                            ),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                child: mutlimageUrl4 == null
                                                    ? InkWell(
                                                        onTap: () {
                                                          _imagePicker(
                                                              context, 4);
                                                        },
                                                        child: Center(
                                                            child: Icon(
                                                          Icons.camera_alt,
                                                          size: 50,
                                                          color: Colors.black,
                                                        )),
                                                      )
                                                    : InkWell(
                                                        onTap: () {
                                                          _imagePicker(
                                                              context, 4);
                                                        },
                                                        child: prifix.Image(
                                                          image: FileImage(
                                                              mutlimageUrl4),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )),
                                          ),
                                        ],
                                      ),
                                imageUrl5 == false
                                    ? Stack(
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 80,
                                            margin: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(9),
                                            ),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                child: prifix.Image(
                                                  image: NetworkImage(
                                                    "https://souq-mawashi.com" +
                                                        adsDetailsModels
                                                            .imageUrl5,
                                                  ),
                                                  fit: BoxFit.cover,
                                                )),
                                          ),
                                          Positioned(
                                            top: 10,
                                            left: 10,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  imageUrl5 = true;
                                                });
                                              },
                                              child: Container(
                                                // width: 20,
                                                // height: 20,
                                                margin: EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    : Stack(
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 80,
                                            margin: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(9),
                                            ),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                child: mutlimageUrl5 == null
                                                    ? InkWell(
                                                        onTap: () {
                                                          _imagePicker(
                                                              context, 5);
                                                        },
                                                        child: Center(
                                                            child: Icon(
                                                          Icons.camera_alt,
                                                          size: 50,
                                                          color: Colors.black,
                                                        )),
                                                      )
                                                    : InkWell(
                                                        onTap: () {
                                                          _imagePicker(
                                                              context, 5);
                                                        },
                                                        child: prifix.Image(
                                                          image: FileImage(
                                                              mutlimageUrl5),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ),

//---------------------------catareies-------------------
                        Padding(
                          padding: const EdgeInsets.only(right: 25, left: 25),
                          child: Row(
                            children: <Widget>[
                              text(
                                  context,
                                  allTranslations.currentLanguage == 'ar'
                                      ? "الإسم"
                                      : "Name",
                                  EdgeInsets.only(top: 30),
                                  Colors.black,
                                  20),
                            ],
                          ),
                        ),
                        textFormFiledUpdate(
                            context,
                            (value) {
                              if (value.isEmpty) {
                                return allTranslations.currentLanguage == 'ar'
                                    ? 'من فضلك ادخل اسم الإعلان'
                                    : "Please Enter Ad Name";
                              } else
                                return null;
                            },
                            TextInputType.text,
                            (val) {
                              setState(() {
                                name = val;
                              });
                            },
                            allTranslations.currentLanguage == 'ar'
                                ? "الإسم"
                                : "Name",
                            false,
                            nameAds,
                            true),
                        Padding(
                          padding: const EdgeInsets.only(right: 25, left: 25),
                          child: Row(
                            children: <Widget>[
                              text(
                                  context,
                                  allTranslations.currentLanguage == 'ar'
                                      ? "الصنف"
                                      : "Category",
                                  EdgeInsets.only(top: 30),
                                  Colors.black,
                                  20),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 29, left: 20),
                          child: InkWell(
                            onTap: () {
                              allCategoryModel.categories == null
                                  ? Toast.show(
                                      allTranslations.currentLanguage == 'ar'
                                          ? "التأكد من شبكه الانترنت"
                                          : "Please Check Internet",
                                      context,
                                      duration: Toast.LENGTH_SHORT,
                                      gravity: Toast.BOTTOM,
                                    )
                                  : displaySubBottomSheet(context: context);
                            },
                            child: catName != null
                                ? Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        text(
                                            context,
                                            catName,
                                            EdgeInsets.only(top: 30),
                                            Colors.blue,
                                            17),
                                        Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.blue,
                                        )
                                      ],
                                    ),
                                  )
                                : Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        text(
                                            context,
                                            catName == null
                                                ? 'اختر الصنف'
                                                : catName,
                                            EdgeInsets.only(top: 30),
                                            Colors.blue,
                                            17),
                                        Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Color(
                                              getColorHexFromStr('#A4A4A4')),
                                        )
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 29, left: 20),
                          child: Container(
                            color: Colors.grey,
                            width: MediaQuery.of(context).size.width,
                            height: 2,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(right: 25, left: 25),
                          child: Row(
                            children: <Widget>[
                              text(
                                  context,
                                  allTranslations.currentLanguage == 'ar'
                                      ? "المدينه"
                                      : "City",
                                  EdgeInsets.only(top: 30),
                                  Colors.black,
                                  20),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 29, left: 20),
                          child: InkWell(
                            onTap: () {
                              citiees == null
                                  ? Toast.show(
                                      allTranslations.currentLanguage == 'ar'
                                          ? "برجاء الانتظار"
                                          : "Please wait .....",
                                      context,
                                      duration: Toast.LENGTH_SHORT,
                                      gravity: Toast.BOTTOM,
                                    )
                                  : displaySubBottomSheetCity(
                                      citiees: citiees, context: context);
                            },
                            child: cityName != null
                                ? Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        text(
                                            context,
                                            cityName,
                                            EdgeInsets.only(top: 30),
                                            Colors.blue,
                                            17),
                                        Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.blue,
                                        )
                                      ],
                                    ),
                                  )
                                : Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        text(
                                            context,
                                            'اختر المدينه',
                                            EdgeInsets.only(top: 30),
                                            Color(
                                                getColorHexFromStr('#A4A4A4')),
                                            17),
                                        Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Color(
                                              getColorHexFromStr('#A4A4A4')),
                                        )
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 29, left: 20),
                          child: Container(
                            color: Colors.grey,
                            width: MediaQuery.of(context).size.width,
                            height: 2,
                          ),
                        ),

//-------------------------Discribtions---------------------

                        Padding(
                          padding: const EdgeInsets.only(right: 25, left: 25),
                          child: Row(
                            children: <Widget>[
                              text(
                                  context,
                                  allTranslations.currentLanguage == 'ar'
                                      ? "تفاصيل الاعلان"
                                      : "Ads Details",
                                  EdgeInsets.only(top: 30),
                                  Colors.black,
                                  20),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            right: 20,
                            left: 20,
                          ),
                          child: TextFormField(
                            maxLines: 4,
                            textInputAction: TextInputAction.newline,
                            onSaved: (val) {
                              setState(() {
                                discribion = val;
                              });
                            },
                            // autovalidate: _autoValidate,
                            validator: (value) {
                              if (value.isEmpty) {
                                return allTranslations.currentLanguage == 'ar'
                                    ? 'من فضلك ادخل تفاصيل الاعلان'
                                    : "Please Enter Ads Details";
                              } else {
                                return null;
                              }
                            },
                            keyboardType: TextInputType.multiline,
                            // obscureText: scure,
                            controller: discribtionName,
                            style: TextStyle(color: Colors.blue, fontSize: 15),
                            decoration: InputDecoration(
                                errorStyle: TextStyle(
                                  color: Color(getColorHexFromStr('#E8883E')),
                                  fontSize: 13,
                                ),
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 10.0),
                                filled: true,
                                hintText: name,
                                fillColor: Colors.white.withOpacity(.1),
                                focusColor:
                                    Color(getColorHexFromStr('#B7B7B7')),
                                hintStyle: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold)),
                          ),
                        )
                      ],
                    ),
                  ),
                  isUpdate
                      ? Center(
                          child: CupertinoActivityIndicator(
                            animating: true,
                            radius: 15,
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            _submitCreateAdv(context);
                          },
                          child: buttons(
                              context,
                              "تعديل اعلان",
                              EdgeInsets.only(
                                  top: 30, right: 20, left: 20, bottom: 30)))
                ],
              ),
      ),
    );
  }

//------------------------------------Submit-------------------
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(BuildContext context, String text) {
    scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontFamily: "Cairo",
          ),
        ),
      ),
    );
  }

  List<dynamic> newImages = [];

  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: ""),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Catchi",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    // print(resultList);

    setState(() {
      images = resultList;
      selectedImages.addAll(resultList);
      // newImages.addAll(resultList);

      _error = error;
    });
  }

  CreateAdvertiseModels createAdvertiseModels = CreateAdvertiseModels();
  ProgressDialog pr;
  Future<Uint8List> compressImageList(Uint8List list) async {
    var result = await FlutterImageCompress.compressWithList(
      list,
      minHeight: 1920,
      minWidth: 1080,
      quality: 96,
      // rotate: 135,
    );
//    print(list.length);
//    print(result.length);
    return result;
  }

  var url1;
  var url2;
  var url3;
  var url4;
  var url5;
  bool isUpdate = false;
  _submitCreateAdv(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (imageUrl1 == true && mutlimageUrl1 == null) {
      showInSnackBar(
          context,
          allTranslations.currentLanguage == "ar"
              ? "قم بإضافة الصورة الأولى اولا"
              : "Image 1 Requird");
    } else if (imageUrl2 == true && mutlimageUrl2 == null) {
      showInSnackBar(
          context,
          allTranslations.currentLanguage == "ar"
              ? "قم بإضافة الصورة الثانية اولا"
              : "Image 2 Requird");
    } else if (imageUrl3 == true && mutlimageUrl3 == null) {
      showInSnackBar(
          context,
          allTranslations.currentLanguage == "ar"
              ? "قم بإضافة الصورة الثالثة اولا"
              : "Image 3 Requird");
    } else if (imageUrl4 == true && mutlimageUrl4 == null) {
      showInSnackBar(
          context,
          allTranslations.currentLanguage == "ar"
              ? "قم بإضافة الصورة الرابعة اولا"
              : "Image 4 Requird");
    } else if (imageUrl5 == true && mutlimageUrl5 == null) {
      showInSnackBar(
          context,
          allTranslations.currentLanguage == "ar"
              ? "قم بإضافة الصورة الخامسة اولا"
              : "Image 5 Requird");
    } else if (nameAds.text.isEmpty) {
      showInSnackBar(
          context,
          allTranslations.currentLanguage == "ar"
              ? "إسم الإعلان مطلوب"
              : "Title is Required");
    } else if (discribtionName.text.isEmpty) {
      showInSnackBar(
          context,
          allTranslations.currentLanguage == "ar"
              ? "وصف الإعلان مطلوب"
              : "Discribtion is Required");
    } else {
      print("jhjhjhsadsadasdjhjhjhjhj");
      isUpdate = true;
      List<dynamic> list;
      setState(() {
        url1 = mutlimageUrl1 == null
            ? null
            : MultipartFile.fromFileSync(mutlimageUrl1.path,
                filename: basename(mutlimageUrl1.path));

        print("jhjhjhsadsadasdjasdsadasdsahjhjhjhj");
        url2 = mutlimageUrl2 == null
            ? null
            : MultipartFile.fromFileSync(mutlimageUrl2.path,
                filename: basename(mutlimageUrl2.path));

        url3 = mutlimageUrl3 == null
            ? null
            : MultipartFile.fromFileSync(mutlimageUrl3.path,
                filename: basename(mutlimageUrl3.path));

        url4 = mutlimageUrl4 == null
            ? null
            : MultipartFile.fromFileSync(mutlimageUrl4.path,
                filename: basename(mutlimageUrl4.path));

        url5 = mutlimageUrl5 == null
            ? null
            : MultipartFile.fromFileSync(mutlimageUrl5.path,
                filename: basename(mutlimageUrl5.path));
        list = [url1, url2, url3, url4, url5];
      });

//       newImages.forEach((element) {
//  return list=   MultipartFile.fromFileSync(element.path,
//                   filename: basename(element.path)});
      list.removeWhere((value) => value == null);

      print(list.toString() + "____________");
      Map<String, dynamic> addData = {
        // 'type': 'normal',

        'Title': nameAds.text,
        "Description": discribtionName.text,
        "AdID": adsDetailsModels.adId,
        "UserId": jwt,
        // "country_id": currentCountries.id,
        "CategoryID": catId,

        "IsPact": true,
        "IsPaid": false,
        "CityID": cityId,
        "userPhone": preferences.getString("mobile"),
        "": list,
        "IsImageChanged[0]": imageUrl1,
        "IsImageChanged[1]": imageUrl2,
        "IsImageChanged[3]": imageUrl3,
        "IsImageChanged[4]": imageUrl4,
        "IsImageChanged[5]": imageUrl5,
        "ImageUrl1": adsDetailsModels.imageUrl1,
        "ImageUrl2": adsDetailsModels.imageUrl2,
        "ImageUrl3": adsDetailsModels.imageUrl3,
        "ImageUrl4": adsDetailsModels.imageUrl4,
        "ImageUrl5": adsDetailsModels.imageUrl5,
      };

      print(addData.toString());
      FormData _formData = FormData.fromMap(addData);
      // _formData.files.add(MapEntry("",
      // MultipartFile.fromFileSync(e.path, filename: basename(e.path))

      // ));
      _util
          .put(
        'Advertisments',
        body: _formData,
      )
          .then((result) {
        // print("-------------------------- $result");
        // Navigator.pop(context);

        if (result.statusCode == 201) {
          showInSnackBar(
              context,
              allTranslations.currentLanguage == "ar"
                  ? "تم التعديل على الإعلان بنجاح"
                  : "Ad has been modified successfully.");
          setState(() {});

          // pr.hide();
          // createAdvertiseModels = CreateAdvertiseModels.fromJson(result.data);
          Timer(Duration(seconds: 2), () async {
            isUpdate = false;

            Navigator.push(context,
                MaterialPageRoute(builder: (context) => BottomPageBar()));
          });
        } else {
          setState(() {
            isUpdate = false;
          });
          // pr.hide();
          showInSnackBar(context, result.data['massage']);
        }
      }).catchError((err) {
        setState(() {
          isUpdate = false;
        });
        showInSnackBar(
            context,
            allTranslations.currentLanguage == 'ar'
                ? 'برجاء التأكد من الانترنت'
                : 'Please Check Internet');

        print("333333333333333333333333#########" + err.toString());
      });
    }
    // SharedPreferences prfs = await SharedPreferences.getInstance();
    // pr = ProgressDialog(
    //   context,
    //   isDismissible: false,
    //   type: ProgressDialogType.Normal,
    // );

    // int priceAds = int.parse(price.text);

    // pr.show();
  }
}
