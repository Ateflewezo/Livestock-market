import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milyar/Language/all_translations.dart';
import 'package:milyar/Models/ProfileProviderModels.dart';
import 'package:milyar/ScoppedModels/ScoppedModels/Network_Utils.dart';
import 'package:milyar/pages/HomeScreen/ProductCard.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdsScreen extends StatefulWidget {
  final int id;

  const AdsScreen({Key key, this.id}) : super(key: key);
  @override
  _AdsScreenState createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {
  ProfileProviderModels profileProviderModels = ProfileProviderModels();
  ProgressDialog pr;

  NetworkUtil util = NetworkUtil();
  bool isLoading = true;

  int idUser;
  _getIdFromCach() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      idUser = sharedPreferences.getInt('id');
    });
  }

  submit(BuildContext context) async {
    pr = ProgressDialog(
      context,
      isDismissible: false,
      type: ProgressDialogType.Normal,
    );

    setState(() {
      isLoading = true;
    });
    SharedPreferences prfs = await SharedPreferences.getInstance();

    Map<String, dynamic> _headers = {
      "Authorization": "Bearer " + prfs.getString("jwt"),
    };
// print(_headers);
//       pr.update(
//           message: allTranslations.currentLanguage == 'ar'
//               ? "يرجى الانتظار"
//               : "Loading",
//           progress: 4,
//           maxProgress: 10.0);

    print(widget.id);
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

  // bool deleteAds = false;
  // DeleteAdsModels deleteAdsModels = DeleteAdsModels();
  // _submit(BuildContext context, int index) async {
  //   SharedPreferences prfs = await SharedPreferences.getInstance();

  //   FormData _formData = FormData.fromMap({
  //     'ad_id': index,
  //   });
  //   Map<String, dynamic> _headers = {
  //     "Authorization": "Bearer " + prfs.getString("jwt"),
  //   };

  //   util
  //       .post('client/advertise/delete', body: _formData, headers: _headers)
  //       .then((result) {
  //     print("-------------------------- $result");
  //     pr.hide();

  //     if (result.statusCode == 200) {
  //       setState(() {
  //         deleteAdsModels = DeleteAdsModels.fromJson(result.data);
  //       });
  //     } else {}
  //   }).catchError((err) {
  //     print("333333333333333333333333#########" + err.toString());
  //   });
  // }

  @override
  void initState() {
    _getIdFromCach();
    submit(context);
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
    util.post('client/toggle_fav_ad/$id', headers: _headers).then((result) {
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
    return isLoading
        ? Center(
            child: CupertinoActivityIndicator(
              animating: true,
              radius: 15,
            ),
          )
        : profileProviderModels.data.ads != null &&
                profileProviderModels.data.ads.isNotEmpty
            ? ListView.builder(
                itemCount: profileProviderModels.data.ads.length,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {
                  return productCard(
                      context: context,
                      name: profileProviderModels.data.ads[index].name,
                      img: 
                          "https://cdn.pixabay.com/photo/2015/01/21/14/14/imac-606765_1280.jpg",
                      address: profileProviderModels.data.ads[index].cityName,
                      brandName: profileProviderModels
                          .data.ads[index].userData.fullName,
                      isMine: false,
                      price: profileProviderModels.data.ads[index].price ?? "",
                      description:
                          profileProviderModels.data.ads[index].description ??
                              "",
                      onToggleTapped: () {
                        setState(() {
                          submitFavourite(context,
                              profileProviderModels.data.ads[index].id);
                          if (profileProviderModels.data.ads[index].isFav ==
                              0) {
                            profileProviderModels.data.ads[index].isFav = 1;
                          } else {
                            profileProviderModels.data.ads[index].isFav = 0;
                          }
                        });
                      },
                      isFav: profileProviderModels.data.ads[index].isFav);
                },
              )
            : Center(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(allTranslations.currentLanguage == 'ar'
                      ? "لا توجد اعلانات"
                      : "No Data"),
                ),
              );
  }
}
