import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:milyar/Language/all_translations.dart';
import 'package:milyar/Models/AuthModels/Cities.dart';
import 'package:milyar/Models/AuthModels/GetProfileModels.dart';
import 'package:milyar/Models/AuthModels/UpdateProfile.dart';
import 'package:milyar/ScoppedModels/ScoppedModels/Network_Utils.dart';

import 'package:milyar/Utils/color.dart';
import 'package:milyar/Widget/Buttons.dart';
import 'package:milyar/Widget/text.dart';
import 'package:milyar/pages/MoreScreens/EditProfile/EditPassword.dart';
import 'package:milyar/pages/bottomNavigationBar.dart/BottomNavigationApp.dart';
import 'package:path/path.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File _imageFile;
  File _imageProfile;

  String profileImage;
  _getCach() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      profileImage = sharedPreferences.getString('image');
    });
  }

  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 1000.0, maxHeight: 1000.0)
        .then((File image) {
      setState(() {
        _imageFile = image;
      });
      Navigator.pop(context);
    });
  }

  void _getImageProfile(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(
      source: source,
      maxWidth: 400.0,
    ).then((File image) {
      setState(() {
        _imageProfile = image;
      });
      Navigator.pop(context);
    });
  }

  void _openImageBottomSheet(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: (MediaQuery.of(context).size.height / 2) + 100,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoActionSheet(
                    cancelButton: CupertinoButton(
                      child: Text(
                        allTranslations.currentLanguage == 'ar'
                            ? "الرجوع"
                            : "Cancel",
                        style: TextStyle(
                            fontFamily: "Cairo",
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    actions: [
                      CupertinoButton(
                        child: Center(
                          child: Text(
                            allTranslations.currentLanguage == 'ar'
                                ? "الكاميرا"
                                : "Camera",
                            style: TextStyle(
                                fontFamily: "Cairo",
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        onPressed: () {
                          _getImage(context, ImageSource.camera);
                        },
                      ),
                      CupertinoButton(
                        child: Center(
                          child: Text(
                            allTranslations.currentLanguage == 'ar'
                                ? "الاستديو"
                                : "Gallery",
                            style: TextStyle(
                                fontFamily: "Cairo",
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        onPressed: () {
                          _getImage(context, ImageSource.gallery);
                        },
                      ),
                    ]),
              ));
        });
  }

  void _openImageProfileBottomSheet(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: (MediaQuery.of(context).size.height / 2) + 100,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoActionSheet(
                    cancelButton: CupertinoButton(
                      child: Text(
                        allTranslations.currentLanguage == 'ar'
                            ? "الرجوع"
                            : "Cancel",
                        style: TextStyle(
                            fontFamily: "Cairo",
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    actions: [
                      CupertinoButton(
                        child: Center(
                          child: Text(
                            allTranslations.currentLanguage == 'ar'
                                ? "الكاميرا"
                                : "Camera",
                            style: TextStyle(
                                fontFamily: "Cairo",
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        onPressed: () {
                          _getImageProfile(context, ImageSource.camera);
                        },
                      ),
                      CupertinoButton(
                        child: Center(
                          child: Text(
                            allTranslations.currentLanguage == 'ar'
                                ? "الاستديو"
                                : "Gallery",
                            style: TextStyle(
                                fontFamily: "Cairo",
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        onPressed: () {
                          _getImageProfile(context, ImageSource.gallery);
                        },
                      ),
                    ]),
              ));
        });
  }

  GetProfileModels getProfileModels = GetProfileModels();
  NetworkUtil util = NetworkUtil();
  bool isLoading = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController citiesController = TextEditingController();

  TextEditingController addressController = TextEditingController();

  submit(BuildContext context) async {
    SharedPreferences prfs = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });
    print("v1/GetDataOfUser?user_id=${prfs.getString("id")}");
    util
        .post(
      'v1/GetDataOfUser?user_id=${prfs.getString("id")}',
    )
        .then((result) {
      print("---------> $result");
      if (result.data['key'] == 1) {
        setState(() {
          getProfileModels = GetProfileModels.fromJson(result.data);
          nameController.text = getProfileModels.data.userName;
          emailController.text = getProfileModels.data.email;
          mobileController.text = getProfileModels.data.phone;
          // image = getProfileModels.data.image;
          cityId = getProfileModels.data.cityId;
          addressController.text = getProfileModels.data.address;

          // print(image + 'asdddddddddddddddddddddddddddddddddddddd');
          isLoading = false;
        });
      } else {}
    });
  }

  bool cities = false;
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
        // allCitiesModels = AllCitiesModels.fromJson(response.data);
        cities = false;
      });
    } else {}
  }

  double lat, lng;
  String address;
  Widget location(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 20, left: 20, top: 10),
      child: InkWell(
        onTap: () async {

          // LocationResult result = await showLocationPicker(
          //     context, "AIzaSyD8of-XmJr7P140k3J1Bs0ixcXh2JvxFN0");
          // setState(() {
          //   lat = result.latLng.latitude;
          //   lng = result.latLng.longitude;
          //   // _getPlace();
          //   address = result.address;
          // });
         
        },
        child: Container(
          decoration: BoxDecoration(
              color: Color(getColorHexFromStr('#FAFAFA')),
              borderRadius: BorderRadius.circular(15)),
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: address != null
              ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    address,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Color(getColorHexFromStr('#FC7D3C')),
                        fontWeight: FontWeight.bold),
                  ),
              )
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    allTranslations.text('location'),
                    style: TextStyle(
                        color: Color(getColorHexFromStr('#A9A9A9')),
                        fontWeight: FontWeight.bold),
                  ),
              ),
        ),
      ),
    );
  }

  String cityName;
  int cityId;
  void displaySubBottomSheet(
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

  @override
  void initState() {
    _getCach();
    _getallCitiesClient();
    submit(this.context);
    super.initState();
  }

  String name, mobile, email;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: allTranslations.currentLanguage == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            elevation: 0,
            leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.blue,
                )),
            title: Text(
              allTranslations.text('edit_profile'),
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
            centerTitle: true,
          ),
          body: ListView(
            children: <Widget>[
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
//-----------------------------ImagesCover---------------------------

//--------------------------------TextFormname------------------------------

                    // Padding(
                    //   padding: const EdgeInsets.only(right: 25, left: 25),
                    //   child: Row(
                    //     children: <Widget>[
                    //       text(
                    //           context,
                    //           allTranslations.currentLanguage == 'ar'
                    //               ? "الاسم"
                    //               : "Name",
                    //           EdgeInsets.only(top: 30),
                    //           Colors.black,
                    //           20),
                    //     ],
                    //   ),
                    // ),
                    // textFormFiledUpdate(
                    //     context,
                    //     (val) {
                    //       if (val.isEmpty) {
                    //         return allTranslations.currentLanguage == 'ar'
                    //             ? 'من فضلك ادخل الاسم'
                    //             : "Please Enter Name";
                    //       } else {
                    //         return null;
                    //       }
                    //     },
                    //     TextInputType.text,
                    //     (val) {
                    //       setState(() {
                    //         name = val;
                    //       });
                    //     },
                    //     allTranslations.currentLanguage == 'ar'
                    //         ? "الاسم"
                    //         : "Name",
                    //     false,
                    //     nameController,false),

//------------------------------Phone---------------------------------------
                    Padding(
                      padding: const EdgeInsets.only(right: 25, left: 25),
                      child: Row(
                        children: <Widget>[
                          text(
                              context,
                              allTranslations.currentLanguage == 'ar'
                                  ? "رقم الجوال"
                                  : "Phone",
                              EdgeInsets.only(top: 30),
                              Colors.black,
                              20),
                        ],
                      ),
                    ),
                    textFormFiledUpdate(
                        context,
                        (val) {
                          if (val.isEmpty) {
                            return allTranslations.currentLanguage == 'ar'
                                ? 'من فضلك ادخل الاسم'
                                : "Please Enter Name";
                          } else {
                            return null;
                          }
                        },
                        TextInputType.text,
                        (val) {
                          setState(() {
                            mobile = val;
                          });
                        },
                        allTranslations.currentLanguage == 'ar'
                            ? "رقم الجوال"
                            : "Phone Number",
                        false,
                        mobileController,false),
//------------------------------Email---------------------------------------
                    // Padding(
                    //   padding: const EdgeInsets.only(right: 25, left: 25),
                    //   child: Row(
                    //     children: <Widget>[
                    //       text(
                    //           context,
                    //           allTranslations.currentLanguage == 'ar'
                    //               ? "البريد الألكترونى"
                    //               : "Email",
                    //           EdgeInsets.only(top: 30),
                    //           Colors.black,
                    //           20),
                    //     ],
                    //   ),
                    // ),
                    // textFormFiledUpdate(
                    //     context,
                    //     (val) {
                    //       if (val.isEmpty) {
                    //         return allTranslations.currentLanguage == 'ar'
                    //             ? 'من فضلك ادخل الايميل'
                    //             : "Please Enter Email";
                    //       } else {
                    //         return null;
                    //       }
                    //     },
                    //     TextInputType.text,
                    //     (val) {
                    //       setState(() {
                    //         email = val;
                    //       });
                    //     },
                    //     allTranslations.currentLanguage == 'ar'
                    //         ? "البريد الألكترونى"
                    //         : "Email",
                    //     false, 
                    //     emailController,false),
//---------------------------Cities--------------------------------------
                    // Padding(
                    //   padding: const EdgeInsets.only(right: 25, left: 25),
                    //   child: Row(
                    //     children: <Widget>[
                    //       text(
                    //           context,
                    //           allTranslations.currentLanguage == 'ar'
                    //               ? "المدينة"
                    //               : "City",
                    //           EdgeInsets.only(top: 30),
                    //           Colors.black,
                    //           20),
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding:
                    //       const EdgeInsets.only(top: 15, right: 20, left: 20),
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //         color: Color(getColorHexFromStr('#FAFAFA')),
                    //         borderRadius: BorderRadius.circular(15)),
                    //     width: MediaQuery.of(context).size.width,
                    //     child: InkWell(
                    //         onTap: () {
                    //           // displaySubBottomSheet(
                    //           //     citiees: citiees, context: context);
                    //         },
                    //         child: Padding(
                    //           padding: const EdgeInsets.all(8.0),
                    //           child: Text(
                    //             cityName == null ? "اختر المدينة" : cityName,
                    //             style: TextStyle(
                    //                 color: cityName == null
                    //                     ? Color(getColorHexFromStr('#A3A3A3'))
                    //                     : Colors.blue),
                    //           ),
                    //         )),
                    //   ),
                    // ),
                    // // Padding(
                    // //   padding: const EdgeInsets.only(right: 29, left: 20,top: 10),
                    // //   child: Container(
                    // //     // color: Colors.grey,
                    // //     width: MediaQuery.of(context).size.width,
                    // //     height: 2,
                    // //   ), 
                    // // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(right: 25, left: 25),
                    //   child: Row(
                    //     children: <Widget>[
                    //       text(
                    //           context,
                    //           allTranslations.currentLanguage == 'ar'
                    //               ? "الموقع على الخريطة"
                    //               : "Locations",
                    //           EdgeInsets.only(top: 30),
                    //           Colors.black,
                    //           20),
                    //     ],
                    //   ),
                    // ),
                    // location(context),
//---------------------------Locations-------------------------------
                    // Padding(
                    //   padding: const EdgeInsets.only(right: 25, left: 25),
                    //   child: Row(
                    //     children: <Widget>[
                    //       text(
                    //           context,
                    //           allTranslations.currentLanguage == 'ar'
                    //               ? "العنوان على الخريطه"
                    //               : "Locations",
                    //           EdgeInsets.only(top: 30),
                    //           Colors.black,
                    //           20),
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(right: 29, left: 20),
                    //   child: Container(
                    //     child: InkWell(
                    //       onTap: () {
                    //         Navigator.push(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                     builder: (context) => LocationsMaps()))
                    //             .then((location) {
                    //           print("----------------------$location");
                    //           print("LAAAAATTTTTT" +
                    //               '${location['lat']}' +
                    //               'asdasdasdasdasd');
                    //           print("LLLLNNNNN" +
                    //               '${location['long']}' +
                    //               'dsdsdfsdfsdfsdfsdfsdf');
                    //           setState(() {
                    //             lat = location['lat'];
                    //             lng = location['long'];

                    //             address = location['address'];
                    //           });
                    //         });
                    //       },
                    //       child: Row(
                    //         crossAxisAlignment: CrossAxisAlignment.end,
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: <Widget>[
                    //           address != null
                    //               ? Text(
                    //                   address,
                    //                   style: TextStyle(
                    //                       color: Color(
                    //                           getColorHexFromStr('#E8883E')),
                    //                       fontWeight: FontWeight.bold),
                    //                 )
                    //               : text(
                    //                   context,
                    //                   addressController.text,
                    //                   EdgeInsets.only(top: 30),
                    //                   Color(getColorHexFromStr('#A4A4A4')),
                    //                   17),
                    //           Icon(
                    //             Icons.edit,
                    //             color: Color(getColorHexFromStr('#0F0F0F')),
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(right: 29, left: 20),
                    //   child: Container(
                    //     color: Colors.grey,
                    //     width: MediaQuery.of(context).size.width,
                    //     height: 2,
                    //   ),
                    // ),
//--------------------Password-----------------------------------
                    Padding(
                      padding: const EdgeInsets.only(right: 25, left: 25),
                      child: Row(
                        children: <Widget>[
                          text(
                              context,
                              allTranslations.currentLanguage == 'ar'
                                  ? "كلمه المرور"
                                  : "Password",
                              EdgeInsets.only(top: 30),
                              Colors.black,
                              20),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 29, left: 20),
                      child: Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            text(
                                context,
                                '************',
                                EdgeInsets.only(top: 30),
                                Color(getColorHexFromStr('#A4A4A4')),
                                17),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditPassword()));
                              },
                              child: Icon(
                                Icons.edit,
                                color: Color(getColorHexFromStr('#0F0F0F')),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
SizedBox(height: 31,)
//-------------------------------Buttons--------------------------
                    // InkWell(
                    //   onTap: () {
                    //     submitEditProfile(context);
                    //   },
                    //   child: buttons(
                    //       context,
                    //       allTranslations.currentLanguage == 'ar'
                    //           ? 'حفظ التعديل'
                    //           : "Save Edits",
                    //       EdgeInsets.only(
                    //           top: 20, left: 20, right: 20, bottom: 30)),
                    // )
                  ],
                ),
              ),
            ],
          )),
    );
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UpdateProfileModels updateProfileModels = UpdateProfileModels();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  ProgressDialog pr;
  void showInSnackBar(BuildContext context, String text) {
    scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
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

  submitEditProfile(BuildContext context) async {
    pr = ProgressDialog(
      context,
      isDismissible: false,
      type: ProgressDialogType.Normal,
    );

    FormState formState = formKey.currentState;
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if (formState.validate()) {
      formState.save();
      FormData _formData = FormData.fromMap({
        "name": name != null ? name : nameController.text,
        "latitude": lng,
        // "city_id": citiesData == null ? null : citiesData.id,
        "email": email != null ? email : emailController.text,
        "mobile": mobile != null ? mobile : mobileController.text,
        "image": _imageProfile == null
            ? null
            : MultipartFile.fromFileSync(_imageProfile.path,
                filename: basename(_imageProfile.path)),
        "cover_image": _imageFile == null
            ? null
            : MultipartFile.fromFileSync(_imageFile.path,
                filename: basename(_imageFile.path)),
      });

      Map<String, dynamic> _headers = {
        "Authorization": "Bearer " + preferences.getString("jwt"),
      };
      //  pr.update(message: allTranslations.currentLanguage=='ar'?"يرجى الانتظار":"Loading",progress: 4,maxProgress: 10.0);

      pr.show();
      util
          .post('client/update/profile', body: _formData, headers: _headers)
          .then((result) {
        print("---------> $result");
        if (result.statusCode == 200) {
          pr.hide();
          setState(() {
            updateProfileModels = UpdateProfileModels.fromJson(result.data);
            Alert(
              buttons: [
                DialogButton(
                  child: Text(
                    "الرجوع",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () => Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => BottomPageBar())),
                  width: 120,
                )
              ],
              context: context,
              title: "تم تعديل البيانات بنجاح",
            ).show();
          });
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

  // CitiesData citiesData;

  // Widget _dropDwon() {
  //   return StatefulBuilder(
  //     builder: (BuildContext context, StateSetter setXState) {
  //       return Padding(
  //         padding: const EdgeInsets.only(right: 31),
  //         child: cities
  //             ? Center(
  //                 child: CupertinoActivityIndicator(
  //                   animating: true,
  //                   radius: 15,
  //                 ),
  //               )
  //             : DropdownButton<CitiesData>(
  //                 hint: Center(
  //                   child: citiesController.text == null
  //                       ? Text(
  //                           allTranslations.currentLanguage == 'ar'
  //                               ? 'المدينه'
  //                               : "City",
  //                           style: TextStyle(
  //                               fontWeight: FontWeight.bold,
  //                               color: Color(getColorHexFromStr('#A9A9A9')),
  //                               fontFamily: "Cairo",
  //                               fontSize: 15),
  //                         )
  //                       : Text(
  //                           citiesController.text,
  //                           style: TextStyle(
  //                               fontWeight: FontWeight.bold,
  //                               color: Color(getColorHexFromStr('#A9A9A9')),
  //                               fontFamily: "Cairo",
  //                               fontSize: 15),
  //                         ),
  //                 ),
  //                 iconEnabledColor: Colors.grey,
  //                 iconDisabledColor: Colors.grey,
  //                 isExpanded: false,
  //                 icon: Padding(
  //                   padding: EdgeInsets.only(right: 20, left: 20),
  //                   child: Icon(
  //                     Icons.arrow_drop_down,
  //                     size: 30,
  //                   ),
  //                 ),
  //                 style: TextStyle(
  //                   color: Colors.black,
  //                   fontSize: 20.0,
  //                 ),
  //                 items: allCitiesModels.data.map((item) {
  //                   return DropdownMenuItem<CitiesData>(
  //                       value: item,
  //                       child: Center(
  //                         child: Padding(
  //                           padding: const EdgeInsets.only(left: 30),
  //                           child: item.id == 0
  //                               ? Text(
  //                                   item.name,
  //                                   style: TextStyle(
  //                                       fontWeight: FontWeight.bold,
  //                                       color: Color(
  //                                           getColorHexFromStr('#A9A9A9')),
  //                                       fontFamily: "Cairo",
  //                                       fontSize: 15),
  //                                 )
  //                               : Text(
  //                                   item.name,
  //                                   style: TextStyle(
  //                                       fontWeight: FontWeight.bold,
  //                                       color: Color(
  //                                           getColorHexFromStr('#A9A9A9')),
  //                                       fontFamily: "Cairo",
  //                                       fontSize: 15),
  //                                 ),
  //                         ),
  //                       ));
  //                 }).toList(),
  //                 onChanged: (CitiesData value) async {
  //                   setXState(() {
  //                     citiesData = value;
  //                   });
  //                 },
  //                 value: citiesData,
  //               ),
  //       );
  //     },
  //   );
  // }
}
