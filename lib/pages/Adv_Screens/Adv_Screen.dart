import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http_parser/http_parser.dart';
import 'package:milyar/Models/AuthModels/Cities.dart';
import 'package:milyar/Models/PortableModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:milyar/Language/all_translations.dart';
import 'package:milyar/Models/AdsDetailsModel.dart';
import 'package:milyar/Models/AdsDetailsModel.dart' as prefix1;
import 'package:milyar/Models/AuthModels/AllCreateAdsModels.dart';
import 'package:milyar/Models/AuthModels/DeleteMessageModels.dart';
import 'package:milyar/Models/AuthModels/UpdateAdsModels.dart';
import 'package:milyar/Models/cataogriesModels.dart';
import 'package:milyar/Models/general/AllCategoriesModels.dart';
import 'package:milyar/Models/general/AllCountriesModels.dart';
import 'package:milyar/ScoppedModels/ScoppedModels/Network_Utils.dart';
import 'package:milyar/Utils/color.dart';
import 'package:milyar/Widget/Buttons.dart';
import 'package:milyar/Widget/text.dart';
import 'package:milyar/pages/bottomNavigationBar.dart/BottomNavigationApp.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path/path.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:flutter/services.dart';
import 'package:milyar/Models/general/AllCountriesModels.dart' as prefix;

class NormalAdsScreen extends StatefulWidget {
  final int idAds;
  final String price;

  const NormalAdsScreen({
    Key key,
    this.idAds,
    this.price,
  }) : super(key: key);
  @override
  _NormalAdsScreenState createState() => _NormalAdsScreenState();
}

class _NormalAdsScreenState extends State<NormalAdsScreen> {
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
      isLoading = true;
    });

    Response response = await _util.post(
      'v1/Shop',
    );
    setState(() {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        setState(() {
          allCategoryModel = AllCategoryModel.fromJson(response.data);

          isLoading = false;
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
  AllCountryModels allCountryModels = AllCountryModels();

  _getCountryClient() async {
    setState(() {
      isLoading = true;
    });

    Response response = await _util.get('country/all');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      setState(() {
        allCountryModels = AllCountryModels.fromJson(response.data);
        isLoading = false;
      });
    } else {}
  }

  // List<City> cities;

//----------------------------------------------------
  List<dynamic> selectedImages = [];

  // void _imagePicker(BuildContext context) {
  //   showCupertinoModalPopup(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return CupertinoActionSheet(
  //           cancelButton: CupertinoButton(
  //             child: Text(
  //               allTranslations.currentLanguage == 'ar' ? "الرجوع" : "Cancel",
  //               style: TextStyle(
  //                 fontFamily: 'Cairo',
  //                 color: Color(getColorHexFromStr("#2c6468")),
  //               ),
  //             ),
  //             onPressed: () => Navigator.of(context).pop(),
  //           ),
  //           actions: <Widget>[
  //             CupertinoButton(
  //               child: Row(
  //                 children: <Widget>[
  //                   Icon(
  //                     CupertinoIcons.photo_camera_solid,
  //                     color: Color(getColorHexFromStr("#2c6468")),
  //                   ),
  //                   SizedBox(
  //                     width: 20,
  //                   ),
  //                   Text(
  //                     allTranslations.currentLanguage == 'ar'
  //                         ? "الكاميرا"
  //                         : "camera",
  //                     style: TextStyle(
  //                       color: Color(getColorHexFromStr("#307e85")),
  //                       fontSize: 15,
  //                       fontFamily: 'Cairo',
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               onPressed: () => _getImage(context, ImageSource.camera),
  //             ),
  //             CupertinoButton(
  //               child: Row(
  //                 children: <Widget>[
  //                   Icon(
  //                     Icons.insert_photo,
  //                     color: Color(getColorHexFromStr("#2c6468")),
  //                   ),
  //                   SizedBox(
  //                     width: 20,
  //                   ),
  //                   Text(
  //                     allTranslations.currentLanguage == 'ar'
  //                         ? "الاستديو"
  //                         : "gallery",
  //                     style: TextStyle(
  //                       color: Color(getColorHexFromStr("#307e85")),
  //                       fontSize: 15,
  //                       fontFamily: 'Cairo',
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               onPressed: () => _getImage(context, ImageSource.gallery),
  //             ),
  //           ],
  //         );
  //       });
  // }

  // void _getImage(BuildContext context, ImageSource source) {
  //   ImagePicker.pickImage(source: source, maxWidth: 400.0).then((File image) {
  //     if (image != null) {
  //       setState(() {
  //         selectedImages.add(image);
  //       });
  //     }
  //     Navigator.pop(context);
  //   });
  // }

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
  AdsDetailsModels adsDetailsModels = AdsDetailsModels();
  TextEditingController nameAds = TextEditingController();
  TextEditingController discribtionName = TextEditingController();
  // TextEditingController catName = TextEditingController();
  TextEditingController citiesName = TextEditingController();
  TextEditingController countName = TextEditingController();
  TextEditingController whatsAppMobile = TextEditingController();
  TextEditingController price = TextEditingController();
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
    // setState(() {
    //   isLoading = true;
    // });

    // FormData _formData = FormData.fromMap({
    //   'ad_id': widget.idAds,
    // });

    // _util.post('client/ad/details', body: _formData).then((result) {
    //   print("-------------------------- $result");

    //   if (result.statusCode == 200) {
    //     setState(() {
    //       adsDetailsModels = AdsDetailsModels.fromJson(result.data);
    //       nameAds.text = adsDetailsModels.data.name;
    //       discribtionName.text = adsDetailsModels.data.description;
    //       // catName.text = adsDetailsModels.data.categoryName;
    //       citiesName.text = adsDetailsModels.data.cityName;
    //       countName.text = adsDetailsModels.data.countryName;
    //       countriesId = adsDetailsModels.data.countryId;
    //       citiesId = adsDetailsModels.data.cityId;
    //       coutId = adsDetailsModels.data.categoryId;
    //       imagea = adsDetailsModels.data.images[0];
    //       whatsAppMobile.text = adsDetailsModels.data.whatsApp;
    //       price.text = widget.price;

    //       isLoading = false;
    //       if (adsDetailsModels != null) {
    //         selectedImages.addAll(adsDetailsModels.data.images
    //             .map((image) => image.image.toString()));
    //       } else {
    //         return null;
    //       }
    //     });
    //   }
    // });

    // _getCountryClient();
    // _getCategories();
    super.initState();
  }

  void _onRememberMeChanged(bool newValue) => setState(() {
        rememberMe = newValue;
      });
  bool rememberMe = false;

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

  List<bool> k = [false, false, false, false, false];
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BottomPageBar()));
            },
          ),
          title: adsDetailsModels.data != null
              ? Text(
                  allTranslations.currentLanguage == 'ar'
                      ? "تعديل الإعلان"
                      : "Edit Ads",
                  style: TextStyle(color: Colors.blue),
                )
              : Text(
                  allTranslations.currentLanguage == 'ar'
                      ? "اضافه اعلان "
                      : "Add Ads",
                  style: TextStyle(color: Colors.blue),
                ),
          centerTitle: true,
        ),
        key: scaffoldKey,
        body: ListView(
          children: <Widget>[
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          loadAssets();
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(.09),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                              child: Icon(
                            Icons.camera_alt,
                            size: 50,
                            color: Colors.black,
                          )),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  selectedImages.isEmpty
                      ? Container()
                      : Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              itemCount: selectedImages.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      margin: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(9),
                                      ),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: AssetThumb(
                                              asset: selectedImages[index],
                                              width: 80,
                                              height: 80,
                                              quality: 100,
                                              spinner: Center(
                                                  child: SizedBox(
                                                      width: 30,
                                                      height: 30,
                                                      child:
                                                          CircularProgressIndicator())))),
                                    ),
                                    Positioned(
                                      top: 10,
                                      left: 10,
                                      child: InkWell(
                                        onTap: () {
                                          if (index == 0) {
                                            print(selectedImages.length);
                                            k = [
                                              true,
                                              false,
                                              false,
                                              false,
                                              false
                                            ];
                                            print(k);
                                          }

                                          if (selectedImages[index] is Asset) {
                                            print(index);
                                            // k.
                                            selectedImages
                                                .remove(selectedImages[index]);
                                            setState(() {});
                                          } else {}
                                        },
                                        child: Container(
                                          // width: 20,
                                          // height: 20,
                                          margin: EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.red,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              }),
                        ),

//---------------------------catareies-------------------
                  Padding(
                    padding: const EdgeInsets.only(right: 25, left: 25),
                    child: Row(
                      children: <Widget>[
                        text(
                            context,
                            allTranslations.currentLanguage == 'ar'
                                ? "عنوان الاعلان"
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
                              ? 'من فضلك ادخل عنوان الإعلان'
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
                          ? "عنوان الاعلان"
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
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  text(
                                      context,
                                      catName,
                                      EdgeInsets.only(top: 30),
                                      catName == null
                                          ? Color(getColorHexFromStr('#A4A4A4'))
                                          : Colors.blue,
                                      17),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: catName == null
                                        ? Color(getColorHexFromStr('#A4A4A4'))
                                        : Colors.blue,
                                  )
                                ],
                              ),
                            )
                          : Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  text(
                                      context,
                                      catName == null ? 'اختر الصنف' : catName,
                                      EdgeInsets.only(top: 30),
                                      catName == null
                                          ? Color(getColorHexFromStr('#A4A4A4'))
                                          : Colors.blue,
                                      17),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Color(getColorHexFromStr('#A4A4A4')),
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

//---------------------Name--------------

                  // Padding(
                  //   padding: const EdgeInsets.only(right: 25, left: 25),
                  //   child: Row(
                  //     children: <Widget>[
                  //       text(
                  //           context,
                  //           allTranslations.currentLanguage == 'ar'
                  //               ? "رقم الواتساب"
                  //               : "WhatsApp",
                  //           EdgeInsets.only(top: 30),
                  //           Colors.black,
                  //           20),
                  //     ],
                  //   ),
                  // ),
                  // textFormFiledUpdate(
                  //     context,
                  //     (value) {
                  //       if (value.isEmpty) {
                  //         return allTranslations.currentLanguage == 'ar'
                  //             ? 'من فضلك ادخل رقم الواتساب '
                  //             : "Please Enter Whatsapp";
                  //       } else
                  //         return null;
                  //     },
                  //     TextInputType.phone,
                  //     (val) {
                  //       setState(() {
                  //         whatsApp = val;
                  //       });
                  //     },
                  //     allTranslations.currentLanguage == 'ar'
                  //         ? "رقم الواتساب"
                  //         : "WhatsApp",
                  //     false,
                  //     whatsAppMobile,
                  //     true),

//------------------------------Cities------------------

//---------------------------------cities--------------------------
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
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  text(
                                      context,
                                      cityName,
                                      EdgeInsets.only(top: 30),
                                      cityName == null
                                          ? Color(getColorHexFromStr('#A4A4A4'))
                                          : Colors.blue,
                                      17),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: cityName == null
                                        ? Color(getColorHexFromStr('#A4A4A4'))
                                        : Colors.blue,
                                  )
                                ],
                              ),
                            )
                          : Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  text(
                                      context,
                                      allTranslations.currentLanguage == 'ar'
                                          ? 'اختر المدينه'
                                          : "City",
                                      EdgeInsets.only(top: 30),
                                      cityName == null
                                          ? Color(getColorHexFromStr('#A4A4A4'))
                                          : Colors.blue,
                                      17),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: cityName == null
                                        ? Color(getColorHexFromStr('#A4A4A4'))
                                        : Colors.blue,
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
                          hintText: allTranslations.currentLanguage == 'ar'
                              ? 'من فضلك ادخل تفاصيل الاعلان'
                              : "Please Enter Ads Details",
                          fillColor: Colors.white.withOpacity(.1),
                          focusColor: Color(getColorHexFromStr('#B7B7B7')),
                          hintStyle: TextStyle(
                              color: Color(getColorHexFromStr('#A4A4A4')),
                              fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(
                      unselectedWidgetColor: Color(getColorHexFromStr('#A4A4A4')),
                    ),
                    child: Checkbox(
                        value: rememberMe,
                        activeColor: Colors.grey,
                        onChanged: _onRememberMeChanged),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          allTranslations.currentLanguage == "ar"
                              ? "اتعهد بدفع 15ريال فى كل  راس يتم بيعه   \n عن طريق الموقع"
                              : "I pledge to pay 15 riyals for every head sold \n through the site",
                          style: TextStyle(
                              color: Color(getColorHexFromStr('#A4A4A4'))),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            isCreated
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
                        allTranslations.currentLanguage == 'ar'
                            ? "اضافه اعلان"
                            : "Edit Ads",
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
      newImages.addAll(resultList);

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

  bool isCreated = false;
  _submitCreateAdv(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // if (newImages.isEmpty) {
    //   showInSnackBar(
    //       context,
    //       allTranslations.currentLanguage == "ar"
    //           ? "برجاء اختيار الصور"
    //           : "Choose Images");
    //  }
    //  else if (newImages.length < 5) {
    //   showInSnackBar(
    //       context,
    //       allTranslations.currentLanguage == "ar"
    //           ? "عدد الصور يجب ان لا يقل عن خمس صور"
    //           : "The number of photos must be at least five pictures.");
    // } 
    //  else 
     if (catId == null) {
      showInSnackBar(
          context,
          allTranslations.currentLanguage == "ar"
              ? "قم بإختيار الصنف "
              : "Choose the item");
    } else if (cityId == null) {
      showInSnackBar(
          context,
          allTranslations.currentLanguage == "ar"
              ? "قم بإختيار المدينة "
              : "Choose the City");
    } else if (rememberMe == false) {
      showInSnackBar(
          context,
          allTranslations.currentLanguage == "ar"
              ? "برجاء تأكيد التعهد بدفع المبلغ"
              : "Please confirm your commitment to pay the amount");
    } else {
      FormState formState = formKey.currentState;
      // SharedPreferences prfs = await SharedPreferences.getInstance();

      if (formState.validate()) {
        formState.save();
        setState(() {
          isCreated = true;
        });
        // int priceAds = int.parse(price.text);
        if (newImages.isNotEmpty) {
          print("here heree erere here here");
          List<MultipartFile> multipartImageList = new List<MultipartFile>();

          for (Asset asset in newImages) {
            ByteData byteData = await asset.getByteData();
            List<int> imageData = byteData.buffer.asUint8List();
            List<int> resultList = await compressImageList(imageData);
            MultipartFile multipartFile = new MultipartFile.fromBytes(
              resultList,
              filename: asset.name,
              contentType: MediaType("image", "jpg"),
            );
            multipartImageList.add(multipartFile);
          }

          setState(() {
            newImages = multipartImageList;
          });
        }
        Map<String, dynamic> addData = {
          // 'type': 'normal',
          'Title': name,
          "Description": discribion,

          // "country_id": currentCountries.id,
          "CategoryID": catId,
          "UserId": jwt,
          "IsPact": rememberMe,
          "IsPaid": false,
          "CityID": cityId,
          "userPhone": preferences.getString("mobile"),
          "Files": newImages
        };

        print(addData.toString());
        FormData _formData = FormData.fromMap(addData);

        _util
            .post(
          'Advertisments',
          body: _formData,
        )
            .then((result) {
          print("-------------------------- $result");
          // Navigator.pop(context);

          if (result.statusCode == 201) {
            // createAdvertiseModels = CreateAdvertiseModels.fromJson(result.data);
            showInSnackBar(
                context,
                allTranslations.currentLanguage == "ar"
                    ? "تم إضافة على الإعلان بنجاح"
                    : "Ad has been Added successfully.");
            setState(() {});

            // pr.hide();
            // createAdvertiseModels = CreateAdvertiseModels.fromJson(result.data);
            Timer(Duration(seconds: 2), () async {
              isCreated = false;

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BottomPageBar()));
            });
          } else {
            isCreated = false;
            showInSnackBar(context, result.data['message']);
          }
        }).catchError((err) {
          isCreated = false;
          showInSnackBar(
              context,
              allTranslations.currentLanguage == 'ar'
                  ? 'برجاء التأكد من الانترنت'
                  : 'Please Check Internet');

          print("333333333333333333333333#########" + err.toString());
        });
      }
    }
  }

  UpdateAdsModels updateAdsModels = UpdateAdsModels();
  _submitCreateUpdate(BuildContext context) async {
    FormState formState = formKey.currentState;
    SharedPreferences prfs = await SharedPreferences.getInstance();
    pr = ProgressDialog(
      context,
      isDismissible: false,
      type: ProgressDialogType.Normal,
    );
    if (formState.validate()) {
      int priceAds = int.parse(price.text);
      print(selectedImages.length.toString() + '=================>>>>>>>>');

      formState.save();
      formState.reset();
      Map<String, dynamic> addData = {
        // 'type': 'normal',
        "price": priceAds,

        'name': nameAds.text,
        "description": discribtionName.text,
        "city_id": selectCities == null ? citiesId : selectCities.id,

        "category_id": subs == null ? coutId : subs.id,
        "whatsApp": whatsApp,
        "payment_type": "One_Pay",
        "transaction_id": 234234324234,
        "amount": 12,
        "status": "success",
      };

      int imageIndex = 0;
      selectedImages.forEach((file) {
        if (file != null && file is File) {
          print(
              imageIndex.toString() + "====================================>");
          addData.putIfAbsent(
              "images[${imageIndex++}]",
              () => MultipartFile.fromFileSync(file.path,
                  filename: basename(file.path)));
        }
      });
      FormData _formData = FormData.fromMap(addData);
      Map<String, dynamic> _headers = {
        "Authorization": "Bearer " + prfs.getString("jwt"),
      };

      pr.show();
      _util
          .post('client/advertise/${widget.idAds}/update',
              body: _formData, headers: _headers)
          .then((result) {
        print("-------------------------- $result");
        Navigator.pop(context);

        if (result.statusCode == 200) {
          // updateAdsModels = UpdateAdsModels.fromJson(result.data);
          Alert(
            buttons: [
              DialogButton(
                child: Text(
                  allTranslations.currentLanguage == 'ar' ? "الرجوع" : "Back",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => BottomPageBar())),
                width: 120,
              )
            ],
            context: context,
            title: allTranslations.currentLanguage == 'ar'
                ? "تم تعديل الاعلان بنجاح"
                : "Success",
          ).show();
        } else {
          showInSnackBar(context, result.data['message']);
        }
      }).catchError((err) {
        Navigator.pop(context);
        showInSnackBar(
            context,
            allTranslations.currentLanguage == 'ar'
                ? 'برجاء التأكد من الانترنت'
                : 'Please Check Internet');

        print("333333333333333333333333#########" + err.toString());
      });
    }
  }

  DeleteMessage deleteMessage = DeleteMessage();
  _deleteImage(BuildContext context, index) async {
    FormState formState = formKey.currentState;
    SharedPreferences prfs = await SharedPreferences.getInstance();
    pr = ProgressDialog(
      context,
      isDismissible: false,
      type: ProgressDialogType.Normal,
    );
    if (formState.validate()) {
      formState.save();

      FormData _formData = FormData.fromMap({
        'image_id': index,
      });

      Map<String, dynamic> _headers = {
        "Authorization": "Bearer " + prfs.getString("jwt"),
      };

      pr.show();
      _util
          .post('client/image/delete', body: _formData, headers: _headers)
          .then((result) {
        print("-------------------------- $result");
        pr.hide();

        if (result.statusCode == 200) {
          deleteMessage = DeleteMessage.fromJson(result.data);
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
                ? "تم  حذف الصوره بنجاح"
                : "Success",
          ).show();
        } else {
          showInSnackBar(context, result.data['message']);
        }
      }).catchError((err) {
        Navigator.pop(context);
        showInSnackBar(
            context,
            allTranslations.currentLanguage == 'ar'
                ? 'برجاء التأكد من الانترنت'
                : 'Please Check Internet');

        print("333333333333333333333333#########" + err.toString());
      });
    }
  }
}
