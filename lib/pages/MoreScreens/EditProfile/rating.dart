import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milyar/Language/all_translations.dart';
import 'package:milyar/Models/ProfileProviderModels.dart';
import 'package:milyar/ScoppedModels/ScoppedModels/Network_Utils.dart';
import 'package:milyar/Utils/color.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:smooth_star_rating/smooth_star_rating.dart';

class RatingScreen extends StatefulWidget {
  final int id;

  const RatingScreen({Key key, this.id}) : super(key: key);
  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  ProfileProviderModels profileProviderModels = ProfileProviderModels();
  ProgressDialog pr;

  NetworkUtil util = NetworkUtil();
  bool isLoading = true;

  submit(BuildContext context) async {
  

    setState(() {
      isLoading = true;
    });
    SharedPreferences prfs = await SharedPreferences.getInstance();

     Map<String, dynamic> _headers ={
      "Authorization": "Bearer " + prfs.getString("jwt"),
    };
  

    
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

  @override
  void initState() {
    submit(context);
    super.initState();
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
        : profileProviderModels.data.rates.isNotEmpty &&
                profileProviderModels.data.rates != null
            ? ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: profileProviderModels.data.rates.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Container(
                          height: 55,
                          width: 55,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: NetworkImage(profileProviderModels
                                    .data.rates[index].userRateData.image),
                              )),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 80,
                        decoration: BoxDecoration(
                            color: Color(getColorHexFromStr('#F8F8F8')),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    profileProviderModels.data.rates[index]
                                        .userRateData.fullName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(
                                          getColorHexFromStr('#3E3E3E'),
                                        )),
                                  ),
                                ),
                                SmoothStarRating(
                                    allowHalfRating: false,
                                  
                                    starCount: 5,
                                    rating: double.parse(profileProviderModels
                                        .data.rates[index].rate
                                        .toString()),
                                    size: 30.0,
                                    color: Color(getColorHexFromStr('#FFD500')),
                                    borderColor: Colors.grey,
                                    spacing: 0.0),
                              ],
                            ),
                            Text(
                                profileProviderModels.data.rates[index].comment)
                          ],
                        ),
                      )
                    ]),
                  );
                },
              )
            : Center(
                child: Text(allTranslations.currentLanguage == 'ar'
                    ? 'لا توجد تعليقات'
                    : "No Data"),
              );
  }
}
