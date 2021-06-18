import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:milyar/Language/all_translations.dart';
import 'package:milyar/Models/AuthModels/DeleteMessageModels.dart';
import 'package:milyar/Models/AuthModels/GetAllMessageModels.dart';
import 'package:milyar/ScoppedModels/ScoppedModels/Network_Utils.dart';
import 'package:milyar/Utils/color.dart';
import 'package:milyar/Widget/text.dart';
import 'package:milyar/pages/ChatScreens/ChatDetailsScreen.dart';
import 'package:milyar/pages/bottomNavigationBar.dart/BottomNavigationApp.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart' as formDateTime;
import 'package:shimmer/shimmer.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  GetAllPaiyAds getAllMessageChatModel = GetAllPaiyAds();

  NetworkUtil util = NetworkUtil();
  bool isLoading = false;

  _getAboutClient() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();

    Response response = await util.post(
      'v1/GetAllPaidAdv',
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      setState(() {
        getAllMessageChatModel = GetAllPaiyAds.fromJson(response.data);
        isLoading = false;
      });
    } else {}
  }

  ProgressDialog pr;
  DeleteMessage deleteMessage = DeleteMessage();
  submitDeleteMessage(BuildContext context, int index) async {
    pr = ProgressDialog(
      context,
      isDismissible: false,
      type: ProgressDialogType.Normal,
    );

    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map<String, dynamic> _headers = {
      "Authorization": "Bearer " + preferences.getString("jwt"),
    };

    pr.update(
        message: allTranslations.currentLanguage == 'ar'
            ? "يرجى الانتظار"
            : "Loading",
        progress: 4,
        maxProgress: 10.0);

    pr.show();
    util.post('delete/conversation/$index', headers: _headers).then((result) {
      pr.hide();
      print("---------> $result");
      if (result.statusCode == 200) {
        setState(() {
          deleteMessage = DeleteMessage.fromJson(result.data);
          Alert(
            buttons: [
              DialogButton(
                child: Text(
                  allTranslations.currentLanguage == 'ar' ? "الرجوع" : " Back",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => BottomPageBar())),
                width: 120,
              )
            ],
            context: context,
            title: allTranslations.currentLanguage == 'ar'
                ? "تم حذف المحادثه بنجاح"
                : 'Success',
          ).show();
        });
      } else {
        // showInSnackBar(context,'' , result.data['message']);
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

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(BuildContext context, String text) {
    scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  @override
  void initState() {
    _getAboutClient();
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
          key: scaffoldKey,
          body: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: text(
                    context,
                    allTranslations.currentLanguage == 'ar'
                        ? "الإعلانات المدفوعة"
                        : "Paid ads",
                    EdgeInsets.only(top: 20),
                    Colors.blue,
                    18),
              ),
              Expanded(
                child: isLoading
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
                                    highlightColor:
                                        Colors.black.withOpacity(0.2),
                                    child: Container(
                                      color: Colors.red,
                                      width: MediaQuery.of(context).size.width,
                                      height: 80,
                                      margin: EdgeInsets.all(10),
                                    )),
                              );
                            }),
                      )
                    : getAllMessageChatModel.data != null &&
                            getAllMessageChatModel.data.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: getAllMessageChatModel.data.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, right: 10, left: 10),
                                child: InkWell(
                                  onTap: () async {
                                    String url =
                                        getAllMessageChatModel.data[index].url;
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      Toast.show(
                                          allTranslations.currentLanguage ==
                                                  "ar"
                                              ? "نأسف الرابط غير صحيح"
                                              : "We are sorry. The link is incorrect.",
                                          context,
                                          gravity: Toast.CENTER);
                                    }
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Container(
                                      height: 200,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image(
                                              image: NetworkImage(
                                                  "https://souq-mawashi.com" +
                                                      getAllMessageChatModel
                                                          .data[index]
                                                          .imageUrl1),
                                              height: 150,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          Text(
                                            getAllMessageChatModel
                                                .data[index].title,
                                            style: TextStyle(
                                              color: Colors.blue,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Align(
                              child: Text(
                                allTranslations.currentLanguage == 'ar'
                                    ? 'لا توجد إعلانات'
                                    : "No Data",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
