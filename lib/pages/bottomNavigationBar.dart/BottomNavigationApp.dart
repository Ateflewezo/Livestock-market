import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:milyar/Language/all_translations.dart';

import 'package:milyar/pages/Adv_Screens/Adv_Screen.dart';
import 'package:milyar/pages/ChatScreens/ChatScreen.dart';
import 'package:milyar/pages/HomeScreen/HomeScreen.dart';
import 'package:milyar/pages/MoreScreens/MoreScreens.dart';
import 'package:milyar/pages/Nearest/view.dart';
import 'package:milyar/pages/SearchScreen/Search_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class BottomPageBar extends StatefulWidget {
  @override
  _BottomPageBarState createState() => _BottomPageBarState();
}

class _BottomPageBarState extends State<BottomPageBar> {
  PageController _myPage = PageController(
    initialPage: 0,
    keepPage: true,
  );

  String jwt;
  _getFromCach() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      jwt = preferences.getString('id');
      print(jwt);
    });
  }

  Location _location = Location();
  dynamic lat, lng;
  @override
  void initState() {
    _getFromCach();
    _location.getLocation().then((value) {
      setState(() {
        lat = value.latitude;
        lng = value.longitude;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: allTranslations.currentLanguage == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: Padding(
        //   padding: const EdgeInsets.only(bottom: 0.0),
        //   child: InkWell(
        //     onTap: () {
        //       if (jwt == null) {
        //         return Toast.show("من فضلك قم بتسجيل الدخول اولا", context,
        //             gravity: Toast.CENTER);
        //       } else {
        //         Navigator.pushReplacement(context,
        //             MaterialPageRoute(builder: (context) => NormalAdsScreen()));
        //       }
        //     },
        //     child: Container(
        //       height:70.0,
        //       width:70.0,
        //       decoration: BoxDecoration(

        //         borderRadius: BorderRadius.circular(15),
        //         gradient: LinearGradient(
                   
        //             begin: Alignment.centerRight,
        //             end: Alignment.centerLeft,
        //             stops: [0.01, 0.9],
        //             colors: [Colors.blue, Colors.blue[300]]),
        //       ),
        //       child: Center(
        //           child: Text(
        //         "أضف إعلان",
        //        textAlign:TextAlign.center ,
        //         style: TextStyle(color: Colors.white),
        //       )),
        //     ),
        //   ),
        // ),
        bottomNavigationBar: _SystemPadding(
          child: BottomAppBar(
            
            elevation: 0,
            // shape: CircularNotchedRectangle(),
            child: Container(
              height: 70,
              child: Row(
              //  mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    iconSize: 35.0,
                    icon: Icon(
                      Icons.home,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      _myPage.jumpToPage(0);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10, top: 5),
                    child: IconButton(
                      iconSize: 35.0,
                      icon: Icon(
                        Icons.search,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        setState(() {
                          _myPage.jumpToPage(1);
                        });
                      },
                    ),
                  ),
                         IconButton(
                      iconSize: 70.0,
                      alignment:Alignment.center ,
                    icon: Text(
                       "أضف إعلان",
                       textAlign:TextAlign.center ,
                        overflow: TextOverflow.visible,
                      style: TextStyle(
                        color: Colors.blue,
                      
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        if (jwt == null) {
                          return Toast.show(
                              "من فضلك قم بتسجيل الدخول اولا", context,
                              gravity: Toast.CENTER);
                        } else {
                           Navigator.pushReplacement(context,
                     MaterialPageRoute(builder: (context) => NormalAdsScreen()));
                        }
                      });
                    },
                  ),
                 
                  IconButton(
                    iconSize: 70.0,
                  
                    icon: Text(
                      "إعلان ممول",
                    
                        textAlign:TextAlign.center ,
                         overflow: TextOverflow.visible,
                      style: TextStyle(
                        color: Colors.blue,
                      
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        if (jwt == null) {
                          return Toast.show(
                              "من فضلك قم بتسجيل الدخول اولا", context,
                              gravity: Toast.CENTER);
                        } else {
                          _myPage.jumpToPage(2);
                        }
                      });
                    },
                  ),
                
                  // IconButton(
                  //     iconSize: 65.0,
                  //     alignment:Alignment.center ,
                  //   icon: Text(
                  //      "الأقرب",
                      
                  //      textAlign:TextAlign.center ,
                  //       overflow: TextOverflow.visible,
                  //     style: TextStyle(
                  //       color: Colors.blue,
                  //     ),
                  //   ),
                  //   onPressed: () {
                  //     setState(() {
                  //       if (jwt == null) {
                  //         return Toast.show(
                  //             "من فضلك قم بتسجيل الدخول اولا", context,
                  //             gravity: Toast.CENTER);
                  //       } else {
                  //         _myPage.jumpToPage(3);
                  //       }
                  //     });
                  //   },
                  // ),
                  IconButton(
                    iconSize: 35.0,
                    icon: Icon(
                      Icons.settings,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      setState(() {
                        _myPage.jumpToPage(4);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        body: PageView(
          controller: _myPage,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            HomeScreen(),
            SearchScreen(),
            ChatScreen(),
            NearestPage(
              lat: lat,
              lng: lng,
            ),
            MoreScreens()
          ],
        ),
      ),
    );
  }
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
