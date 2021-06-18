

import 'package:flutter/material.dart';
import 'package:milyar/Language/all_translations.dart';

class BanckAcountScreen extends StatefulWidget {
  @override
  _BanckAcountScreenState createState() => _BanckAcountScreenState();
}

class _BanckAcountScreenState extends State<BanckAcountScreen> {
  @override
  void initState() {
    super.initState();
  }
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
                  ? " الحساب البنكي"
                  : "BanckAccount",
              style: TextStyle(color: Colors.blue),
            ),
            leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.keyboard_arrow_right,
                    size: 30, color: Colors.blue)),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.only(right: 10,top: 10),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                      Align(
                      alignment: Alignment.topCenter,
                      child: Image(
                        width: 200,
                        height: 100,
                        image: AssetImage("assets/Banck_logo.png"),
                      ),
                    ),
                 SizedBox(height: 20,),       
              Align(
             alignment: Alignment.topCenter,    
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width/2,
                  decoration: BoxDecoration(
                 color:  Colors.blue[900],
                 borderRadius: BorderRadius.circular(5),
                  ),  
                  child: Center(
                    child: Card(
                      elevation: 0,
                     color:  Colors.blue[900],
                      child: Text("حساب جاري رقم ",style: TextStyle(color: Colors.white),),),
                  ),
                ),
              ),
          SizedBox(height: 15,),  
               Align(
                   alignment: Alignment.topCenter,    
                 child: SingleChildScrollView (
              scrollDirection: Axis.horizontal,     
                    child: Text(
                    "4119 1411 6080 209",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
               ), 
      SizedBox(height: 15,),
             Align(
              alignment: Alignment.topCenter,    
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width/2,
                  decoration: BoxDecoration(
                 color:  Colors.blue[900],
                 borderRadius: BorderRadius.circular(5),
                  ),  
                  child: Center(
                    child: Card(
                      elevation: 0,
                     color:  Colors.blue[900],
                      child: Text("ايبان رقم ",style: TextStyle(color: Colors.white),),),
                  ),
                ),
              ),
      SizedBox(height: 15,),  
      
               Align(
                   alignment: Alignment.topCenter,    
                 child: SingleChildScrollView (
              scrollDirection: Axis.horizontal,     
                    child: Text(
                    "SA128000 0209 6080 1411 4119",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
               ), 
           
              ],
            ),
          ),
        ));
  }
}
