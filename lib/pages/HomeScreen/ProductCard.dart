
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:milyar/Utils/color.dart';
Widget productCard(
    {BuildContext context,
    String name,
    String address,
    String img,
    String brandName,
    String description,
    String price,
    int isFav,
    
    Function onTap,
    bool isMine,
    Function onToggleTapped}) {
  return Padding(
    padding: const EdgeInsets.only(right: 15,left: 15,top: 10,bottom: 10),
    child: Container(
      // height: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.2),
            blurRadius: 10.0, // soften the shadow
            spreadRadius: 0.0, //extend the shadow
            offset: Offset(
              2.0, // Move to right 10  horizontally
              2.0, // Move to bottom 10 Vertically
            ),
          )
        ],
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
           
            Padding(
              padding: const EdgeInsets.all(8),

              
              child: Container(
                height: 100,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  image: DecorationImage(
                    // image: AssetImage("assets/icons/iphone.png"),
                    image: NetworkImage(img),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            // SizedBox(width: 2,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width - 200,
                        child: Text(
                          name ?? "",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Color(getColorHexFromStr('082334')),
                              // fontFamily: AppTheme.boldFont,
                              fontSize: 18,
                              fontWeight: FontWeight.w800),
                          maxLines: 1,
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(right: 8, left: 8),
                          child: IconButton(
                            onPressed: onToggleTapped,
                            icon: Icon(
                              isFav == 1 ? Icons.favorite : Icons.favorite_border,
                              color: Colors.blue,
                              // color: AppTheme.primaryColor,
                            ),
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        size: 15,
                         color: Colors.blue,
                        // color: AppTheme.primaryColor,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 170,
                        child: AutoSizeText(
                          address ?? "",
                          maxLines: 1,
                          minFontSize: 9,
                          maxFontSize: 13,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                            // fontFamily: AppTheme.fontName,
                            // fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  isMine
                      ? Container()
                      : Container(
                          width: MediaQuery.of(context).size.width - 170,
                          margin: EdgeInsets.all(3),
                          child: AutoSizeText(
                            brandName,
                            maxLines: 1,
                            minFontSize: 9,
                            maxFontSize: 12,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.blue,
                              // color: AppTheme.primaryColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              // fontFamily: AppTheme.fontName,
                            ),
                          ),
                        ),
                  Container(
                    width: MediaQuery.of(context).size.width - 130,
                    child: AutoSizeText(
                      description,
                      maxLines: 2,
                      minFontSize: 9,
                      maxFontSize: 12,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(getColorHexFromStr("#808080")),
                        fontSize: 13,
                        
                        // fontFamily: AppTheme.fontName,
                        // fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
               
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
