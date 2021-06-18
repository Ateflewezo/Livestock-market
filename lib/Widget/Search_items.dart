import 'package:flutter/material.dart';
import 'package:milyar/Utils/color.dart';

Widget searchItems(BuildContext context, ImageProvider<dynamic> image,
    String name, String message, Widget icons, String date) {
  return Padding(
    padding: const EdgeInsets.only(top: 20),
    child: Card(
      child: Container(
        height: 90,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: <Widget>[
            Image(
              image: image,
              height: 70,
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 10, top: 15),
                  child: Column(
                    children: <Widget>[
                      Text(
                        name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(
                              getColorHexFromStr('#2D2D2D'),
                            )),
                      ),
                      Text(message,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Color(
                                getColorHexFromStr('#C8C8C8'),
                              )))
                    ],
                  ),
                )
              ],
            ),
            Expanded(
              child: Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 29, left: 20),
                  child: Text(date),
                ),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Color(getColorHexFromStr('#F8F8F8')),
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: icons,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ),
  );
}
