// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:milyar/Language/all_translations.dart';
// import 'package:milyar/Models/general/AboutAppModels.dart';
// import 'package:milyar/ScoppedModels/ScoppedModels/Network_Utils.dart';

// import 'package:milyar/Utils/color.dart';

// class PolicyScreen extends StatefulWidget {
//   @override
//   _PolicyScreenState createState() => _PolicyScreenState();
// }

// class _PolicyScreenState extends State<PolicyScreen> {
//   bool isLoading = false;

//   AboutAppModels aboutAppModels = AboutAppModels();
//   NetworkUtil _util = NetworkUtil();

//   _getAboutClient() async {
//     setState(() {
//       isLoading = true;
//     });
//      Map<String, dynamic> _headers =
//        {"lang": allTranslations.currentLanguage};
//     Response response = await _util.get('settings/policy', headers: _headers);
//     if (response.statusCode >= 200 && response.statusCode < 300) {
//       setState(() {
//         aboutAppModels = AboutAppModels.fromJson(response.data);
//         isLoading = false;
//       });
//     } else {}
//   }

//   @override
//   void initState() {
//     _getAboutClient();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: allTranslations.currentLanguage == 'ar'
//           ? TextDirection.rtl
//           : TextDirection.ltr,
//       child: Scaffold(
//         appBar: AppBar(
//           elevation: 0,
//           title: Text(
//             allTranslations.currentLanguage == 'ar'
//                 ? "سياسة الاستخدام"
//                 : "Policy",
//             style: TextStyle(
//                 color: Color(getColorHexFromStr('#66CC7E')),
//                 fontWeight: FontWeight.bold),
//           ),
//           leading: InkWell(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: Icon(
//                 Icons.keyboard_arrow_right,
//                 size: 30,
//                 color: Color(
//                   getColorHexFromStr('#66CC7E'),
//                 ),
//               )),
//           centerTitle: true,
//         ),
//         body: Padding(
//           padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
//           child: SingleChildScrollView(
//             child: isLoading
//                 ? Center(
//                     child: CupertinoActivityIndicator(
//                       animating: true,
//                       radius: 15,
//                     ),
//                   )
//                 : Text(
//                     aboutAppModels.data,
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                   ),
//           ),
//         ),
//       ),
//     );
//   }
// }
