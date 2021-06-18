import 'package:milyar/pages/Auth/LoginScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:milyar/Language/all_translations.dart';
import 'package:milyar/Models/AuthModels/GetProfileModels.dart';
import 'package:milyar/ScoppedModels/ScoppedModels/Network_Utils.dart';
import 'package:milyar/Utils/color.dart';
import 'package:milyar/Widget/text.dart';
import 'package:milyar/main.dart';
import 'package:milyar/pages/MoreScreens/EditProfile/EditProfile.dart';
import 'package:milyar/pages/MoreScreens/ScreenForMore/AboutApp.dart';
import 'package:milyar/pages/MoreScreens/ScreenForMore/BanckAcounntPage.dart';
import 'package:milyar/pages/MoreScreens/ScreenForMore/Fav_Ads.dart';
import 'package:milyar/pages/MoreScreens/ScreenForMore/My_Ads.dart';

import 'package:milyar/pages/MoreScreens/ScreenForMore/terms.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:toast/toast.dart';

class MoreScreens extends StatefulWidget {
  @override
  _MoreScreensState createState() => _MoreScreensState();
}

class _MoreScreensState extends State<MoreScreens> {
  GetProfileModels getProfileModels = GetProfileModels();
  NetworkUtil util = NetworkUtil();
  bool isLoading = false;
  String jwt;
  String username;
  _getFromCach() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      jwt = preferences.getString('id');
      username = preferences.getString('full_name');
      isLoading = false;

      print(jwt);
    });
  }

  submit(BuildContext context) async {
    SharedPreferences prfs = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> _headers = {
      "Authorization": "Bearer " + prfs.getString("jwt"),
    };
    print(_headers);

    util.get('client/my/profile', headers: _headers).then((result) {
      print("---------> $result");
      if (result.statusCode == 200) {
        setState(() {
          getProfileModels = GetProfileModels.fromJson(result.data);
          isLoading = false;
        });
      } else {}
    });
  }

  final String language = allTranslations.currentLanguage;
  String fcmToken;
  _fcmToken() async {
    SharedPreferences.getInstance().then((prefs) {
      fcmToken = prefs.getString('msgToken');
      print("gggggggggggggg ${prefs.getString('msgToken')}");
    });
  }

  @override
  void initState() {
    // submit(context);
    _getFromCach();
    // _fcmToken();
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
    return Directionality(
      textDirection: allTranslations.currentLanguage == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          body: isLoading
              ? Center(
                  child: CupertinoActivityIndicator(
                    animating: true,
                    radius: 15,
                  ),
                )
              : ListView(
                  children: <Widget>[
                    Center(
                        child: text(context, allTranslations.text('more'),
                            EdgeInsets.only(top: 10), Colors.blue, 23)),

                    SizedBox(
                      height: 20,
                    ),

                    (() {
                      if (jwt == null) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(getColorHexFromStr('020202'))),
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        "https://cdn.pixabay.com/photo/2015/01/21/14/14/imac-606765_1280.jpg"),
                                    fit: BoxFit.fill),
                              ),
                              height: 100,
                              width: 100,
                            ),
                            Text(
                              "زائر",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17),
                            )
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            Divider(),
//----------------------about_app----------
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 14, top: 15, left: 14),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditProfileScreen()));
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                    ),
                                    text(
                                        context,
                                        allTranslations.currentLanguage == "ar"
                                            ? " البيانات الشخصية"
                                            : " Profile",
                                        EdgeInsets.only(right: 19, left: 19),
                                        Colors.black,
                                        17)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }()),
                    SizedBox(
                      height: 20,
                    ),
//------------------------my_ads--------------
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 14, top: 10, left: 14),
                      child: InkWell(
                        onTap: () {
                          jwt == null
                              ? Toast.show(
                                  "من فضلك قم بتسجيل الدخول اولا", context,
                                  gravity: Toast.CENTER)
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyAds()));
                        },
                        child: Row(
                          children: <Widget>[
                            Image(
                              image: AssetImage('assets/mads.png'),
                              height: 22,
                            ),
                            text(
                                context,
                                allTranslations.text('my_ads'),
                                EdgeInsets.only(right: 19, left: 19),
                                Color(getColorHexFromStr('082434')),
                                18)
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 14, top: 15, left: 14),
                      child: InkWell(
                        onTap: () {
                          jwt == null
                              ? Toast.show(
                                  "من فضلك قم بتسجيل الدخول اولا", context,
                                  gravity: Toast.CENTER)
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FavouriteAds()));
                        },
                        child: Row(
                          children: <Widget>[
                            Image(
                              image: AssetImage('assets/fav_ads.png'),
                              height: 22,
                            ),
                            text(
                                context,
                                allTranslations.text('fav_adv'),
                                EdgeInsets.only(right: 19, left: 19),
                                Colors.black,
                                17)
                          ],
                        ),
                      ),
                    ),
                    // Divider(),
                    // Padding(
                    //   padding: const EdgeInsets.only(right: 14, top: 15, left: 14),
                    //   child: InkWell(
                    //     onTap: () {
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => CommissionsScreens()));
                    //     },
                    //     child: Row(
                    //       children: <Widget>[
                    //         Image(
                    //           image: AssetImage('assets/commision.png'),
                    //           height: 22,
                    //         ),
                    //         text(
                    //             context,
                    //             allTranslations.currentLanguage == 'ar'
                    //                 ? "حساب العمولة"
                    //                 : "Commission",
                    //             EdgeInsets.only(right: 19, left: 19),
                    //             Colors.black,
                    //             17)
                    //       ],
                    //     ),
                    //   ),
                    // ),
//               Divider(),
// //------------------------my_ads--------------
//               Padding(
//                 padding: const EdgeInsets.only(right: 14, top: 15, left: 14),
//                 child: InkWell(
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => CandidatesWinner()));
//                   },
//                   child: Row(
//                     children: <Widget>[
//                       Image(
//                         image: AssetImage('assets/userwinner.png'),
//                         height: 18,
//                       ),
//                       text(
//                           context,
//                           allTranslations.currentLanguage == "ar"
//                               ? "المرشحين للفوز"
//                               : "The candidates to win",
//                           EdgeInsets.only(right: 19, left: 19),
//                           Color(getColorHexFromStr('082434')),
//                           18)
//                     ],
//                   ),
//                 ),
//               ),
//               Divider(),
//               Padding(
//                 padding: const EdgeInsets.only(right: 14, top: 15, left: 14),
//                 child: InkWell(
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => WinnerScreen(
//                                   type: "winners_show",
//                                   title: allTranslations.currentLanguage == "ar"
//                                       ? "الفائزين"
//                                       : "Winners",
//                                 )));
//                   },
//                   child: Row(
//                     children: <Widget>[
//                       Image(
//                         image: AssetImage('assets/winner.png'),
//                         height: 18,
//                       ),
//                       text(
//                           context,
//                           allTranslations.currentLanguage == "ar"
//                               ? "الفائزين"
//                               : "Winners",
//                           EdgeInsets.only(right: 19, left: 19),
//                           Color(getColorHexFromStr('082434')),
//                           18)
//                     ],
//                   ),
//                 ),
//               ),
// //---------------------Fav_Ads---------------------------

                    Divider(),
// //--------------------Question--------------------------------------------

//               Padding(
//                 padding: const EdgeInsets.only(right: 14, top: 15, left: 14),
//                 child: InkWell(
//                   onTap: () {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) => Questions()));
//                   },
//                   child: Row(
//                     children: <Widget>[
//                       Image(
//                         image: AssetImage('assets/questions.png'),
//                         height: 22,
//                       ),
//                       text(
//                           context,
//                           allTranslations.text('question'),
//                           EdgeInsets.only(right: 19, left: 19),
//                           Colors.black,
//                           17)
//                     ],
//                   ),
//                 ),
//               ),

//               Divider(),

// //-----------------------privacy--------------
//               Padding(
//                 padding: const EdgeInsets.only(right: 14, top: 15, left: 14),
//                 child: InkWell(
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => PolicyScreen()));
//                   },
//                   child: Row(
//                     children: <Widget>[
//                       Image(
//                         image: AssetImage('assets/privacy.png'),
//                         height: 22,
//                       ),
//                       text(
//                           context,
//                           allTranslations.text('privacy'),
//                           EdgeInsets.only(right: 19, left: 19),
//                           Colors.black,
//                           17)
//                     ],
//                   ),
//                 ),
//               ),
//               Divider(),
//-------------------------Terms-------------------
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 14, top: 15, left: 14),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TermsScreen()));
                        },
                        child: Row(
                          children: <Widget>[
                            Image(
                              image: AssetImage('assets/terms.png'),
                              height: 22,
                            ),
                            text(
                                context,
                                allTranslations.currentLanguage == "ar"
                                    ? "إتصل بنا"
                                    : "Contact Us",
                                EdgeInsets.only(right: 19, left: 19),
                                Colors.black,
                                17)
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                     Padding(
                      padding:
                          const EdgeInsets.only(right: 14, top: 15, left: 14),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BanckAcountScreen()));
                        },
                        child: 
                        Row(
                          children: <Widget>[
                            Image(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/Banck_logo.png'),
                              height: 25,
                              
                            ),
                            text(
                                context,
                                allTranslations.currentLanguage == "ar"
                                    ? " الحساب البنكي"
                                    : "Bank account",
                                EdgeInsets.only(right: 19, left: 19),
                                Colors.black,
                                17)
                          ],
                        ),
                      ),
                    ),
                    Divider(),
//----------------------Lang--------------------

                    // Padding(
                    //   padding:
                    //       const EdgeInsets.only(right: 14, top: 15, left: 14),
                    //   child: InkWell(
                    //     onTap: () async {
                    //       await allTranslations.setNewLanguage(
                    //           language == 'en' ? 'ar' : 'en', true);
                    //       setState(() {
                    //         Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (context) => MyApp()));
                    //       });
                    //     },
                    //     child: Row(
                    //       children: <Widget>[
                    //         Image(
                    //           image: AssetImage('assets/lang.png'),
                    //           height: 22,
                    //         ),
                    //         text(
                    //             context,
                    //             allTranslations.text('lang'),
                    //             EdgeInsets.only(right: 19, left: 19),
                    //             Colors.black,
                    //             17)
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // Divider(),
                    // Container(
                    //   height: 40,
                    //   child: ListTile(
                    //       contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    //       onTap: () {
                    //         _launchURL();
                    //       },
                    //       title: Text(
                    //         allTranslations.currentLanguage == 'ar'
                    //             ? "مركز المساعده"
                    //             : "Help Center",
                    //         style: TextStyle(
                    //           fontSize: 17,
                    //           fontWeight: FontWeight.bold,
                    //           color: Colors.black,
                    //         ),
                    //       ),
                    //       leading: Icon(
                    //         Icons.help,
                    //         color: Colors.black,
                    //       )),
                    // ),
//-------------------------Share-------------------
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 14, top: 15, left: 14),
                      child: InkWell(
                        onTap: () {
                        Share.share(
                                  "https://play.google.com/store/apps/details?id=com.soqu.elmawashii",
                            
                                );
                          // StoreRedirect.redirect(
                          //     androidAppId: "com.soqu.elmawashii",
                          //     iOSAppId: "585027354");
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.share,
                              size: 22,
                            ),
                            text(
                                context,
                                allTranslations.text('share'),
                                EdgeInsets.only(right: 19, left: 19),
                                Colors.black,
                                17)
                          ],
                        ),
                      ),
                    ),
//               Divider(),
// //----------------------about_app----------
//               Padding(
//                 padding: const EdgeInsets.only(right: 14, top: 15, left: 14),
//                 child: InkWell(
//                   onTap: () {
//                     jwt == null
//                         ? Toast.show("من فضلك قم بتسجيل الدخول اولا", context,
//                             gravity: Toast.CENTER)
//                         : Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => SocailScreen()));
//                   },
//                   child: Row(
//                     children: <Widget>[
//                       Image(
//                         image: AssetImage('assets/social.png'),
//                         height: 22,
//                       ),
//                       text(
//                           context,
//                           allTranslations.currentLanguage == "ar"
//                               ? "الربط بحسابات التواصل الإجتماعى"
//                               : "Linking to social media accounts",
//                           EdgeInsets.only(right: 19, left: 19),
//                           Colors.black,
//                           17)
//                     ],
//                   ),
//                 ),
//               ),
                    Divider(),
//----------------------about_app----------
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 14, top: 15, left: 14),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AboutApp()));
                        },
                        child: Row(
                          children: <Widget>[
                            Image(
                              image: AssetImage('assets/aboutapp.png'),
                              height: 22,
                            ),
                            text(
                                context,
                                allTranslations.text('about_app'),
                                EdgeInsets.only(right: 19, left: 19),
                                Colors.black,
                                17)
                          ],
                        ),
                      ),
                    ),
                    Divider(),
//----------------------Logout--------------
                    (() {
                      if (jwt != null) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              right: 14, top: 15, left: 14, bottom: 20),
                          child: InkWell(
                            onTap: () async {
                              SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();
                              sharedPreferences.clear();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyApp()));
                            },
                            child: Row(
                              children: <Widget>[
                                Image(
                                  image: AssetImage('assets/logout.png'),
                                  height: 22,
                                ),
                                text(
                                    context,
                                    allTranslations.text('logout'),
                                    EdgeInsets.only(right: 19, left: 19),
                                    Colors.black,
                                    17)
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(
                              right: 14, top: 15, left: 14, bottom: 20),
                          child: InkWell(
                            onTap: () async {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen(
                                            token: fcmToken,
                                          )));
                            },
                            child: Row(
                              children: <Widget>[
                                Image(
                                  image: AssetImage('assets/logout.png'),
                                  height: 22,
                                ),
                                text(
                                    context,
                                    allTranslations.currentLanguage == 'ar'
                                        ? allTranslations.text("Login")
                                        : allTranslations.text('logout'),
                                    EdgeInsets.only(right: 19, left: 19),
                                    Colors.black,
                                    17)
                              ],
                            ),
                          ),
                        );
                      }
                    }())
                  ],
                ),
        ),
      ),
    );
  }

  Widget editProfile() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // InkWell(
          //   onTap: () {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => ShowProfile(
          //                   id: getProfileModels.data.id,
          //                   cities: getProfileModels.data.city,
          //                   countr: getProfileModels.data.country,
          //                 )));
          //   },
          //   child: Container(
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(25),
          //       image: DecorationImage(
          //         image: NetworkImage(getProfileModels.data.image),
          //       ),
          //     ),
          //     height: 100,
          //     width: 100,
          //   ),
          // ),
          Text(
            username,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
          )
        ],
      ),
    );
  }
}
