import 'package:flutter/material.dart';
import 'package:milyar/Utils/color.dart';

Widget cardAds(
    BuildContext context,
    String personName,
    String carName,
    Icon trash,
    NetworkImage image,
    String like,
    String view,
    AssetImage image2,
    Widget widget) {
  return Stack(
    children: <Widget>[
      Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        child: Card(
            child: Image(
          image: image,
          fit: BoxFit.cover,
        )),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Image(
            image: image2,
            height: 50,
          ),
        ),
      ),
      Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: Color(getColorHexFromStr('#C1C7CF')),
                    borderRadius: BorderRadius.circular(15)),
                child: trash,
              ),
              // Padding(
              //   padding: const EdgeInsets.only(right: 7, left: 7),
              //   child: Container(
              //     height: 40,
              //     width: 40,
              //     decoration: BoxDecoration(
              //         color: Color(getColorHexFromStr('#C1C7CF')),
              //         borderRadius: BorderRadius.circular(15)),
              //     child: edit,
              //   ),
              // )
              widget
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
              height: 25,
            ),
            Text(
              like,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Image(
              image: AssetImage('assets/view.png'),
              height: 25,
            ),
            Text(
              view,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 155, right: 50, left: 50),
        child: Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 7, left: 7),
            child: Text(
              carName,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      )
    ],
  );
}
