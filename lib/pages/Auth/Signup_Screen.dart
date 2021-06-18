import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milyar/Language/all_translations.dart';
import 'package:milyar/Models/AuthModels/Cities.dart';
import 'package:milyar/Models/AuthModels/Resgister_models.dart';
import 'package:milyar/ScoppedModels/ScoppedModels/Network_Utils.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/services.dart';
import 'package:milyar/Utils/color.dart';
import 'package:milyar/Widget/Buttons.dart';
import 'package:milyar/Widget/text.dart';
import 'package:milyar/pages/Auth/CodeScreen.dart';
import 'package:milyar/pages/Auth/LoginScreen.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String name, mobile, email, password;

  NetworkUtil util = NetworkUtil();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RegisterModels registerModels = RegisterModels();
  TextEditingController controller = TextEditingController();
  // bool cities = false;
  // List<AllCitiesModels> citiees;
  // AllCitiesModels allCitiesModels = AllCitiesModels();
  // _getallCitiesClient() async {
  //   setState(() {
  //     cities = true;
  //   });
  //   Response response = await util.post('v1/GetCities');
  //   if (response.statusCode >= 200 && response.statusCode < 300) {
  //     setState(() {
  //       citiees = allCitiesModelsFromJson(jsonEncode(response.data));
  //       print(citiees.length);
  //       // allCitiesModels = AllCitiesModels.fromJson(response.data);
  //       cities = false;
  //     });
  //   } else {}
  // }

  String fcmToken;
  _fcmToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    fcmToken = sharedPreferences.getString('msgToken');
    print("++++++++from user login+++++++++ $fcmToken ");
  }

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

  submit(BuildContext context) async {
    pr = ProgressDialog(
      context,
      isDismissible: false,
      type: ProgressDialogType.Normal,
    );

    FormState formState = formKey.currentState;

    if (formState.validate()) {
      formState.save();
      formState.reset();
      FormData _formData = FormData.fromMap({
        "password": password,
       // "email": email,
        "phone": mobile,
        // "user_name": name,
        // "CityID": cityId,
        // "address": _address,
        // "lat": lat,
        // "lng": lng,
        // "lang": allTranslations.currentLanguage
      });

      pr.update(
          message: allTranslations.currentLanguage == 'ar'
              ? "يرجى الانتظار"
              : "Loading",
          progress: 4,
          maxProgress: 10.0);

      pr.show();
      util
          .post(
        'v1/register',
        body: _formData,
      )
          .then((result) {
        print("---------> $result");
        if (result.data['key'] == 1) {
          setState(() {
            pr.hide();
            registerModels = RegisterModels.fromJson(result.data);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CodeScreen(
                          mobile: registerModels.data.phone,
                          id: registerModels.data.id,
                        )));
          });
        } else {
          pr.hide();
          showInSnackBar(context, result.data['msg']);
        }
      }).catchError((err) {
        pr.hide();
        showInSnackBar(
            context,
            allTranslations.currentLanguage == 'ar'
                ? 'برجاء التأكد من الانترنت'
                : 'Please Check Internet');
      });
    }
  }

  @override
  void initState() {
   // _getallCitiesClient();
    _fcmToken();
    super.initState();
  }

 // String _address; // create this variable
  // _getPlace() async {
  //   //call this async method from whereever you need

  //   // LocationData myLocation;
  //   // String error;
  //   // Location location = new Location();
  //   // try {
  //   //   myLocation = await location.getLocation();
  //   // } on PlatformException catch (e) {
  //   //   if (e.code == 'PERMISSION_DENIED') {
  //   //     error = 'please grant permission';
  //   //     print(error);
  //   //   }
  //   //   if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
  //   //     error = 'permission denied- please enable it from app settings';
  //   //     print(error);
  //   //   }
  //   //   myLocation = null;
  //   // }
  //   // // currentLocation = myLocation;
  //   // final coordinates = new Coordinates(lat, lng);
  //   // var addresses =
  //   //     await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //   // var first = addresses.first;
  //   // setState(() {
  //   //   _address = first.subAdminArea;
  //   // });
  //   // print(
  //   //     ' ${first.locality + "_______________"}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
  //   // return _address;
  // }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: allTranslations.currentLanguage == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
          key: scaffoldKey,
          body: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: ListView(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Image(
                        width: 200,
                        height: 100,
                        // color: Colors.black,
                        image: AssetImage("assets/logo_wide.png"),
                      )),
                ),
                text(
                    context,
                    allTranslations.currentLanguage == 'ar'
                        ? 'انشاء الحساب'
                        : "SignUp",
                    const EdgeInsets.only(top: 50),
                    Colors.black,
                    23),
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: text2(
                        context,
                        allTranslations.currentLanguage == 'ar'
                            ? "تسجيل الدخول  "
                            : "Login",
                        allTranslations.currentLanguage == 'ar'
                            ? '     لديك حساب بالفعل ؟'
                            : "Have An Account?    ")),
                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      // textFormFiled(
                      //     context,
                      //     TextInputType.text,
                      //     (String value) {
                      //       name = value;
                      //     },
                      //     allTranslations.text('name'),
                      //     false,
                      //     null,
                      //     (String value) {
                      //       if (value.isEmpty) {
                      //         return allTranslations.text(
                      //           'valid_name',
                      //         );
                      //       } else {
                      //         return null;
                      //       }
                      //     }),
                      textFormFiledPhone(
                          context,
                          TextInputType.number,
                          (String value) {
                            mobile = value;
                          },
                          allTranslations.text('mobile'),
                          false,
                          null,
                          (String value) {
                            if (value.isEmpty) {
                              return allTranslations.text('vaild_mobile');
                            } else {
                              return null;
                            }
                          }),

                      // textFormFiled(
                      //     context,
                      //     TextInputType.text,
                      //     (String value) {
                      //       email = value;
                      //     },
                      //     allTranslations.text('email'),
                      //     false,
                      //     null,
                      //     (String value) {
                      //       if (value.isEmpty) {
                      //         return allTranslations.text('valid_email');
                      //       } else {
                      //         return null;
                      //       }
                      //     }),
//---------------------Cities----------------------
                      // Padding(
                      //   padding:
                      //       const EdgeInsets.only(top: 15, right: 20, left: 20),
                      //   child: Container(
                      //     height: 50,
                      //     width: MediaQuery.of(context).size.width,
                      //     decoration: BoxDecoration(
                      //         color: Color(getColorHexFromStr('#FAFAFA')),
                      //         borderRadius: BorderRadius.circular(15)),
                      //     child: InkWell(
                      //         onTap: () {
                      //           displaySubBottomSheet(
                      //               citiees: citiees, context: context);
                      //         },
                      //         child: Center(
                      //             child: Text(
                      //           cityName == null ? "اختر المدينة" : cityName,
                      //           style: TextStyle(
                      //               color: cityName == null
                      //                   ? Color(getColorHexFromStr('#A3A3A3'))
                      //                   : Color(getColorHexFromStr('#5FBB55'))),
                      //         ))),
                      //   ),
                      // ),
                      // location(),
//---------------------Locations-------------------
                      textFormFiled(
                          context,
                          TextInputType.text,
                          (String value) {
                            password = value;
                          },
                          allTranslations.text('password'),
                          true,
                          null,
                          (String value) {
                            if (value.isEmpty) {
                              return allTranslations.text('vaild_password');
                            } else {
                              return null;
                            }
                          }),

                      textFormFiled(
                          context,
                          TextInputType.text,
                          null,
                          allTranslations.text('cof_password'),
                          true,
                          controller, (value) {
                        if (controller.text != value) {
                          return allTranslations.text('vaild_cofPassw');
                        } else {
                          return null;
                        }
                      }),
                    ],
                  ),
                ),

                //------------------------ButtonsRegister-------------
                Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 20),
                  child: InkWell(
                      onTap: () {
                        submit(context);
                      },
                      child: buttons(
                          context,
                          allTranslations.currentLanguage == 'ar'
                              ? 'انشاء حساب'
                              : "Sign Up",
                          const EdgeInsets.only(right: 14, left: 15))),
                )
              ],
            ),
          )),
    );
  }

  // double lat, lng;
  // String address;
  // Widget location() {
  //   return Padding(
  //     padding: EdgeInsets.only(right: 20, left: 20, top: 10),
  //     child: InkWell(
  //       onTap: () async {
  //         LocationResult result = await showLocationPicker(
  //             context, "AIzaSyD8of-XmJr7P140k3J1Bs0ixcXh2JvxFN0");
  //         setState(() {
  //           lat = result.latLng.latitude;
  //           lng = result.latLng.longitude;
  //           _getPlace();
  //           address = result.address;
  //         });
  //         // // Navigator.push(context,
  //         //         MaterialPageRoute(builder: (context) => LocationsMaps()))
  //         //     .then((location) {
  //         //   print("----------------------$location");
  //         //   print("LAAAAATTTTTT" + '${location['lat']}' + 'asdasdasdasdasd');
  //         //   print(
  //         //       "LLLLNNNNN" + '${location['long']}' + 'dsdsdfsdfsdfsdfsdfsdf');
  //         //   setState(() {
  //         //     lat = location['lat'];
  //         //     lng = location['long'];

  //         //     address = location['address'];
  //         //   });
  //         // });
  //       },
  //       child: Container(
  //         decoration: BoxDecoration(
  //             color: Color(getColorHexFromStr('#FAFAFA')),
  //             borderRadius: BorderRadius.circular(15)),
  //         width: MediaQuery.of(context).size.width,
  //         height: 50,
  //         child: _address != null
  //             ? Center(
  //                 child: Text(
  //                   _address,
  //                   overflow: TextOverflow.ellipsis,
  //                   style: TextStyle(
  //                       color: Color(getColorHexFromStr('#FC7D3C')),
  //                       fontWeight: FontWeight.bold),
  //                 ),
  //               )
  //             : Center(
  //                 child: Text(
  //                   allTranslations.text('location'),
  //                   style: TextStyle(
  //                       color: Color(getColorHexFromStr('#A9A9A9')),
  //                       fontWeight: FontWeight.bold),
  //                 ),
  //               ),
  //       ),
  //     ),
  //   );
  // }

  // String cityName;
  // int cityId;
  // void displaySubBottomSheet(
  //     {BuildContext context, List<AllCitiesModels> citiees}) {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (context) {
  //         return Container(
  //           width: double.infinity,
  //           height: 400,
  //           padding: EdgeInsets.all(9),
  //           child: Column(
  //             children: [
  //               (() {
  //                 return Text(allTranslations.currentLanguage == "en"
  //                     ? "Please choose your city"
  //                     : "من فضلك قم باختيار المدينة ");
  //               }()),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               cities
  //                   ? Center(
  //                       child: CupertinoActivityIndicator(
  //                         animating: true,
  //                         radius: 14,
  //                       ),
  //                     )
  //                   : Expanded(
  //                       child: ListView.separated(
  //                           shrinkWrap: true,
  //                           separatorBuilder: (context, index) => Divider(),
  //                           itemCount: citiees.length,
  //                           itemBuilder: (BuildContext context, int index) {
  //                             return InkWell(
  //                               onTap: () {
  //                                 setState(() {
  //                                   cityName = citiees[index].cityName;
  //                                   cityId = citiees[index].cityId;
  //                                 });
  //                                 Navigator.of(context).pop();
  //                               },
  //                               child: Padding(
  //                                 padding: const EdgeInsets.all(8.0),
  //                                 child: Center(
  //                                   child: Text(
  //                                     citiees[index].cityName ?? "",
  //                                     style: TextStyle(
  //                                         color: Color(
  //                                             getColorHexFromStr('#5FBB55'))),
  //                                   ),
  //                                 ),
  //                               ),
  //                             );
  //                           }),
  //                     )
  //             ],
  //           ),
  //         );
  //       });
  // }

  // CitiesData citiesData;
//   Widget _dropDwon() {
//     return StatefulBuilder(
//       builder: (BuildContext context, StateSetter setXState) {
//         return cities
//             ? Center(
//                 child: CupertinoActivityIndicator(
//                   animating: true,
//                   radius: 15,
//                 ),
//               )
//             : DropdownButton<List<AllCitiesModels>>(
//                 hint: Center(
//                   child: Padding(
//                     padding: const EdgeInsets.only(right: 10, left: 10),
//                     child: Text(
//                       allTranslations.currentLanguage == 'ar'
//                           ? 'المدينه'
//                           : "City",
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Color(getColorHexFromStr('#A9A9A9')),
//                           fontFamily: "Cairo",
//                           fontSize: 15),
//                     ),
//                   ),
//                 ),
//                 isExpanded: true,
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 20.0,
//                 ),
//                 items: citiees.map((item) {
//                   return DropdownMenuItem<List<AllCitiesModels>>(
//                       // value: item.,
//                       child: Center(
//                     child: Padding(
//                       padding: const EdgeInsets.only(right: 10, left: 10),
//                       child: Text(
//                         item.cityName,
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Color(getColorHexFromStr('#FC7D3C')),
//                             fontFamily: "Cairo",
//                             fontSize: 15),
//                       ),
//                     ),
//                   ));
//                 }).toList(),
//                 onChanged: (List<AllCitiesModels> value) async {
//                   setXState(() {
//                     citiees = value;
//                   });
//                 },
//                 value: citiees,
//               );
//       },
//     );
//   }
 }
