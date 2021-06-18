import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milyar/Language/all_translations.dart';
import 'package:milyar/Models/ProfileProviderModels.dart';
import 'package:milyar/ScoppedModels/ScoppedModels/Network_Utils.dart';
import 'package:milyar/Utils/color.dart';
import 'package:milyar/Widget/text.dart';
import 'package:milyar/pages/ChatScreens/ChatDetailsScreen.dart';
import 'package:milyar/pages/MoreScreens/EditProfile/EditProfile.dart';
import 'package:milyar/pages/MoreScreens/EditProfile/ads.dart';
import 'package:milyar/pages/MoreScreens/EditProfile/rating.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowProfile extends StatefulWidget {
  final int id;
  final String countr, cities;
  const ShowProfile({Key key, this.id, this.countr, this.cities})
      : super(key: key);
  @override
  _ShowProfileState createState() => _ShowProfileState();
}

class _ShowProfileState extends State<ShowProfile> {
  TabController tabController;
  ProfileProviderModels profileProviderModels = ProfileProviderModels();
  ProgressDialog pr;

  NetworkUtil util = NetworkUtil();
  bool isLoading = false;
  submit(BuildContext context) async {
    SharedPreferences prfs = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> _headers = {
      "Authorization": "Bearer " + prfs.getString("jwt"),
    };
    print(_headers);

    util.post('user/profile/${widget.id}', headers: _headers).then((result) {
      print("---------> $result");
      if (result.statusCode == 200) {
        setState(() {
          profileProviderModels = ProfileProviderModels.fromJson(result.data);
          isLoading = false;
        });
      } else {
        // showInSnackBar(context,'' , result.data['message']);
      }
    }).catchError((err) {
      // Navigator.pop(context);
      //   showInSnackBar(context, '',allTranslations.currentLanguage == 'ar'?
      //    'برجاء التأكد من الانترنت':'Please Check Internet'
      //    );
      print("333333333333333333333333#########" + err.toString());
    });
  }

  int idUser;
  _getIdFromCach() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      idUser = sharedPreferences.getInt('id');
    });
  }

  @override
  initState() {
    _getIdFromCach();
    submit(context);
    super.initState();
    tabController =
        new TabController(vsync: DrawerControllerState(), length: 2);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: allTranslations.currentLanguage == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        body: isLoading
            ? Center(
                child: CupertinoActivityIndicator(
                  animating: true,
                  radius: 15,
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 35),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        isLoading
                            ? Center(
                                child: CupertinoActivityIndicator(
                                  animating: true,
                                  radius: 15,
                                ),
                              )
                            : Container(
                                height: 150,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            profileProviderModels
                                                .data.coverImage),
                                        fit: BoxFit.cover)),
                              ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                        isLoading
                            ? Center(
                                child: CupertinoActivityIndicator(
                                  animating: true,
                                  radius: 15,
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(top: 100),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 4)),
                                    child: Image(
                                      image: NetworkImage(
                                          profileProviderModels.data.image),
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
//-----------------------IconsEditProfile--------------------
                    profileProviderModels.data?.id == idUser
                        ? Padding(
                            padding: const EdgeInsets.only(right: 10, left: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditProfileScreen()));
                                    },
                                    child: Icon(Icons.edit)),
                              ],
                            ),
                          )
                        : Container(),
//----------------------Name------------------------------------
                    isLoading
                        ? Center(
                            child: CupertinoActivityIndicator(
                              animating: true,
                              radius: 15,
                            ),
                          )
                        : text(context, profileProviderModels.data.fullName,
                            EdgeInsets.only(), Colors.black, 20),
//-------------------------Locations----------------------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Image(
                          image: AssetImage('assets/location.png'),
                          height: 20,
                          color:  Colors.blue,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 7, left: 10, right: 10),
                          child: text(
                              context,
                             "السعودية",
                              EdgeInsets.only(),
                              Colors.blue,
                              14),
                        ),
                      ],
                    ),
                    profileProviderModels.data?.id != idUser
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 35,
                                      width: 50,
                                      color:
                                          Color(getColorHexFromStr('#F8F8F8')),
                                      child: Center(
                                          child: Icon(
                                        Icons.phone,
                                        color: Colors.black,
                                      )),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatScreenDetails(
                                                      conversationId:
                                                          profileProviderModels
                                                              .data.id,
                                                      name:
                                                          profileProviderModels
                                                              .data.fullName,
                                                    )));
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 50,
                                        color: Color(
                                            getColorHexFromStr('#F8F8F8')),
                                        child: Center(
                                            child: Image(
                                          image: AssetImage('assets/chat.png'),
                                          color: Colors.black,
                                          height: 20,
                                        )),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Container(),
//---------------------------TabBar--------------------------------
                    new TabBar(
                      controller: tabController,
                      indicatorColor: Colors.blue,
                      unselectedLabelColor:
                          Color(getColorHexFromStr('#B3B3B3')),
                      isScrollable: true,
                      labelColor:  Colors.blue,
                      tabs: <Widget>[
                        new Tab(
                          child: Text(
                            allTranslations.text('mads'),
                          ),
                        ),
                        new Tab(
                          child: Text(
                            allTranslations.text('rating'),
                          ),
                        ),
                      ],
                    ),

                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height - 130,
                        child: new TabBarView(
                          controller: tabController,
                          children: <Widget>[
                            AdsScreen(
                              id: widget.id,
                            ),
                            RatingScreen(
                              id: widget.id,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
