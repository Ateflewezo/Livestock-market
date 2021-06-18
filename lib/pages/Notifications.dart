// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:milyar/Language/all_translations.dart';
// import 'package:milyar/Models/NotificationsModels.dart';
// import 'package:milyar/Models/general/AboutAppModels.dart';
// import 'package:milyar/ScoppedModels/ScoppedModels/Network_Utils.dart';
// import 'package:milyar/Utils/color.dart';
// import 'package:milyar/pages/HomeScreen/HomeScreenDetails.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:toast/toast.dart';

// class Notifications extends StatefulWidget {
//   @override
//   _NotificationsState createState() => _NotificationsState();
// }

// class _NotificationsState extends State<Notifications> {
//   NotificationsModels notificationsModels = NotificationsModels();
//   NetworkUtil networkUtil = NetworkUtil();

//   bool getNotifications = false;
//   _getNotifications() async {
//     setState(() {
//       getNotifications = true;
//     });
//     SharedPreferences prfs = await SharedPreferences.getInstance();

//     Map<String, dynamic> _headers = {
//       "Authorization": "Bearer " + prfs.getString("jwt"),
//     };
//     await networkUtil.get('notification', headers: _headers).then((onValue) {
//       if (onValue.statusCode == 200) {
//         setState(() {
//           getNotifications = false;
//         });
//         notificationsModels = NotificationsModels.fromJson(onValue.data);
//       }
//     });
//   }

//   AboutAppModels aboutAppModels = AboutAppModels();
//   _deleteItem(int id) async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();

//     Map<String, dynamic> _headers = {
//       "Authorization": "Bearer " + preferences.getString("jwt"),
//     };
//     FormData _bodii = FormData.fromMap({
//       "notification_id": id,
//     });
//     Response response = await networkUtil.post('notification/delete',
//         headers: _headers, body: _bodii);
//     if (response.statusCode == 200) {
//       setState(() {
//         aboutAppModels = AboutAppModels.fromJson(response.data);
//         Toast.show('تم الحذف بنجاج', context);
//         _getNotifications();
//       });
//     }
//   }

//   @override
//   void initState() {
//     _getNotifications();
//     super.initState();
//   }

//   void confirmDeleteDialog(
//       BuildContext context, String title, String body, int tripId) {
//     showCupertinoDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return CupertinoAlertDialog(
//           title: Text(
//             title,
//             style: TextStyle(
//               fontFamily: "Cairo",
//               fontSize: 15,
//               // color: Colors.grey[400],
//             ),
//           ),
//           content: Text(
//             body,
//             style: TextStyle(
//               fontFamily: "Cairo",
//               fontSize: 15,
//               // color: Colors.grey[400],
//             ),
//           ),
//           actions: <Widget>[
//             CupertinoButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text(
//                 "الغاء",
//                 style: TextStyle(
//                   fontFamily: "Cairo",
//                   fontSize: 15,
//                   // color: Colors.grey[400],
//                 ),
//               ),
//             ),
//             CupertinoButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _deleteItem(tripId);
//               },
//               child: Text(
//                 "تاكيد",
//                 style: TextStyle(
//                   fontFamily: "Cairo",
//                   fontSize: 15,
//                   // color: Colors.grey[400],
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(
//             allTranslations.currentLanguage == 'ar'
//                 ? "الاشعارات"
//                 : "Notifications",
//             style: TextStyle(color: Color(getColorHexFromStr('69CB31'))),
//           ),
//           leading: IconButton(
//             iconSize: 30,
//             icon: Icon(Icons.keyboard_arrow_right),
//             color: Color(getColorHexFromStr('69CB31')),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           centerTitle: true,
//         ),
//         body: getNotifications
//             ? Center(
//                 child: CupertinoActivityIndicator(
//                   animating: true,
//                   radius: 17,
//                 ),
//               )
//             : ListView.builder(
//                 itemCount: notificationsModels.data.length,
//                 shrinkWrap: true,
//                 itemBuilder: (context, index) {
//                   return InkWell(
//                     onTap: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => HomeScreenDetails(
//                                     idAds:
//                                         notificationsModels.data[index].userId,
//                                   )));
//                     },
//                     child: _buildNotifications(
//                         notificationsModels.data[index].value,
//                         notificationsModels.data[index].isSeen,
//                         notificationsModels.data[index].id),
//                   );
//                 },
//               ),
//       ),
//     );
//   }

//   Widget _buildNotifications(String bodii, int seen, int id) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         height: 100, 
//         width: MediaQuery.of(context).size.width,
//         color: Colors.grey.withOpacity(.1),
//         child: Row(
//           children: <Widget>[
//             Stack(
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Image(
//                     image: AssetImage('assets/appIcons.png'),
//                     height: 20,
//                   ),
//                 ),
//                 seen == 0
//                     ? Align(
//                         alignment: Alignment.topRight,
//                         child: Container(
//                           height: 20,
//                           width: 20,
//                           decoration: BoxDecoration(
//                               color: Colors.red, shape: BoxShape.circle),
//                         ),
//                       )
//                     : Container(),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 width: MediaQuery.of(context).size.width - 200,
//                 child: Column(
//                   children: <Widget>[
//                     Text(bodii),
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Container(),
//             ),
//             IconButton(
//               icon: Icon(
//                 Icons.delete_forever,
//                 color: Colors.black,
//               ),
//               onPressed: () {
//                 confirmDeleteDialog(
//                     context, "تنبيه", "من فضلك قم بتاكيد الحذف", id);
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
