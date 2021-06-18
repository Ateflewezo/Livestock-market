import 'package:flutter/material.dart';
import 'package:milyar/Language/all_translations.dart';

Widget card(
    BuildContext context,
    String personName,
    String carName,
    NetworkImage image,
    NetworkImage userImage,
    String likeCount,

    String viewCount) {
  return Stack(
    children: <Widget>[
      Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        child: Card(
          child: Image(
            image: image,
            fit: BoxFit.cover,
          ),
        ),
      ),
     
     
      Padding(
        padding: const EdgeInsets.only(right: 10, left: 10, top: 8),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Row(
            children: <Widget>[
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    image: DecorationImage(image: userImage)),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 7, left: 7),
                child: Text(
                  personName,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 7, left: 7, top: 155),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Image(
              image: AssetImage('assets/like.png'),
              height: 20,
            ),
            Text(
              likeCount,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Image(
              image: AssetImage('assets/view.png'),
              height: 15,
            ),
            Text(
              viewCount,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      allTranslations.currentLanguage == 'ar'
          ? Padding(
              padding: const EdgeInsets.only(top: 155, right: 50, left: 50),
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 7, left: 7),
                  child: Text(
                    carName,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 155, right: 50, left: 50),
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 230, left: 7),
                  child: Text(
                    carName,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
    ],
  );
}
