import 'package:milyar/Language/all_translations.dart';
import 'package:milyar/Models/commision.dart';
import 'package:milyar/ScoppedModels/ScoppedModels/Network_Utils.dart';
import 'package:milyar/Utils/color.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CommissionsScreens extends StatefulWidget {
  @override
  _CommissionsScreensState createState() => _CommissionsScreensState();
}

class _CommissionsScreensState extends State<CommissionsScreens> {
  bool isLoading = false;

  CommissionModels commissionModels = CommissionModels();
  NetworkUtil _util = NetworkUtil();

  _getAboutClient() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> _headers = {"lang": allTranslations.currentLanguage};
    //
    Response response = await _util.get('bank/all', headers: _headers);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      setState(() {
        commissionModels = CommissionModels.fromJson(response.data);
        isLoading = false;
      });
    } else {}
  }

  @override
  void initState() {
    _getAboutClient();
    super.initState();
  }

  int commission = 0;
  TextEditingController value = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: allTranslations.currentLanguage == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            allTranslations.currentLanguage == 'ar'
                ? "حساب العمولة"
                : "Commission",
            style: TextStyle(color: Color(getColorHexFromStr('#66CC7E'))),
          ),
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.keyboard_arrow_right,
                size: 30,
                color: Color(
                  getColorHexFromStr('#66CC7E'),
                ),
              )),
          centerTitle: true,
        ),
        body: isLoading
            ? Center(
                child: CupertinoActivityIndicator(
                  animating: true,
                  radius: 15,
                ),
              )
            : ListView(
                children: <Widget>[
//-----------------------------------Text-------------------------------------------------------
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'العمولة أمانة في ذمة المعلن سواء تمت المبايعة عن طريق الموقع أو بسببه، وموضحة قيمتها بما يلي:',
                          style: TextStyle(
                              color: Color(getColorHexFromStr("8F8F8F"))),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 10,
                        child: Form(
                          // key: formKey,
                          child: commissionTextFormFiled(
                            context,
                            (val) {
                              if (val.isEmpty) {
                                return allTranslations.text('vaild_search');
                              } else {
                                return null;
                              }
                            },
                            TextInputType.phone,
                            allTranslations.currentLanguage == "ar"
                                ? "قيمة المبيعات"
                                : "Sales value",
                            value,
                            false,
                            Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(end: 0.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    commission =
                                        commissionModels.data.commission *
                                            int.parse(value.text.toString());
                                  });
                                },
                                child: Container(
                                  height: 55,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color:
                                          Color(getColorHexFromStr('66CC7E')),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Image(
                                    image: AssetImage('assets/commision.png'),
                                    // height: 10,
                                    // width: 10,

                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'قيمة العمولة المستحقة للتطبيق هي = ${commission == 0 ? "" : commission.toString()}',
                        style: TextStyle(fontSize: 13),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'الحسابات البنكية',
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Color(getColorHexFromStr('1D2F42'))),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height - 200,
                        child: ListView.builder(
                            itemCount:
                                commissionModels.data.banksAccounts.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color:
                                          Color(getColorHexFromStr('F8F8F8'))),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        height: 70,
                                        width: 80,
                                        child: Image(
                                            image: NetworkImage(commissionModels
                                                .data
                                                .banksAccounts[index]
                                                .image)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "اسم صاحب الحساب :${commissionModels.data.banksAccounts[index].accountName}",
                                              style: TextStyle(
                                                  color: Color(
                                                      getColorHexFromStr(
                                                          '9F9F9F'))),
                                            ),
                                            Text(
                                              "رقم الحساب :${commissionModels.data.banksAccounts[index].accountNumber.toString()}",
                                              style: TextStyle(
                                                  color: Color(
                                                      getColorHexFromStr(
                                                          '9F9F9F'))),
                                            ),
                                            Text(
                                              "رقم الايبان :${commissionModels.data.banksAccounts[index].ibanNumber.toString()}",
                                              style: TextStyle(
                                                  color: Color(
                                                      getColorHexFromStr(
                                                          '9F9F9F'))),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                  //---------------------------PriceCommission---------------------------------------------------
                ],
              ),
      ),
    );
  }

  Widget commissionTextFormFiled(
      BuildContext context,
      Function(String) validator,
      TextInputType textInputType,
      String name,
      TextEditingController controller,
      bool scure,
      Widget widget) {
    return Padding(
      padding: EdgeInsets.only(right: 20, left: 20, top: 20),
      child: TextFormField(
        // autovalidate: _autoValidate,
        validator: validator,
        keyboardType: textInputType,
        controller: controller,
        obscureText: scure,
        style: TextStyle(
            color: Color(getColorHexFromStr('#3D546C')), fontSize: 15),
        decoration: InputDecoration(
            errorStyle: TextStyle(
              color: Color(getColorHexFromStr('#E8883E')),
              fontSize: 13,
            ),
            contentPadding:
                new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Color(getColorHexFromStr('#E7E7E7')), width: 1.0),
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
              borderSide: BorderSide.none,
            ),
            filled: true,
            suffixIcon: widget,
            fillColor: Color(getColorHexFromStr('#F8F8F8')),
            hintText: name,
            hintStyle: TextStyle(
                color: Color(getColorHexFromStr('#A3A3A3')),
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
