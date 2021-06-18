import 'package:flutter/material.dart';

import 'package:milyar/Language/all_translations.dart';
import 'package:milyar/Utils/color.dart';
import 'package:milyar/Widget/CircleImage.dart';

class Bubble extends StatelessWidget {
  Bubble(
      {this.message,
      this.userImage,
      this.time,
      this.type,
      this.delivered,
      this.isMe});

  final String message, time, type, userImage;
  final delivered, isMe;

  @override
  Widget build(BuildContext context) {
    bool isArabic = allTranslations.currentLanguage == 'en' ? false : true;
    dynamic msgWidget = Text(".....");
    if (type == "text") {
      msgWidget = ConstrainedBox(
        constraints: new BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 100,
        ),
        child: Text(
          message?.trim() ?? "",
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Cairo',
            color: isMe
                ? Color(
                    getColorHexFromStr("#8B8B8B"),
                  )
                : Color(
                    getColorHexFromStr("#307e85"),
                  ),
          ),
        ),
      );
    } else if (type == "image") {
      msgWidget = Image.network(
        message,
        fit: BoxFit.cover,
      );
      // msgWidget = PinchZoomImage(
      //   image: Image.network(message),
      //   zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
      //   hideStatusBarWhileZooming: true,
      //   onZoomStart: () {
      //     print('Zoom started');
      //   },
      //   onZoomEnd: () {
      //     print('Zoom finished');
      //   },
      // );
    }

    final bg = isMe
        ? Color(
            getColorHexFromStr("#F8F8F8"),
          )
        : Colors.white;
    final align = isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    // final icon = delivered ? Icons.done_all : Icons.done;
    // final radius = isMe
    //     ? isArabic
    //         ? BorderRadius.only(
    //             topLeft: Radius.circular(5.0),
    //             bottomRight: Radius.circular(10.0),
    //             bottomLeft: Radius.circular(5.0),
    //           )
    //         : BorderRadius.only(
    //             topRight: Radius.circular(5.0),
    //             bottomLeft: Radius.circular(10.0),
    //             bottomRight: Radius.circular(5.0),
    //           )
    //     : isArabic
    //         ? BorderRadius.only(
    //             topRight: Radius.circular(5.0),
    //             bottomRight: Radius.circular(5.0),
    //             bottomLeft: Radius.circular(10.0),
    //           )
    //         : BorderRadius.only(
    //             topLeft: Radius.circular(5.0),
    //             bottomLeft: Radius.circular(5.0),
    //             bottomRight: Radius.circular(10.0),
    //           );

    final radius = isMe
        ? isArabic
            ? BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              )
        : isArabic
            ? BorderRadius.only(
                topRight: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
              )
            : BorderRadius.only(
                topLeft: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              );
    print("sender image => $userImage");

    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: <Widget>[
            CircleImage(userImage, 25),
          ],
        ),
        type == 'image'
            ? InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: Container(
                            child: msgWidget,
                          ),
                        );
                      });
                },
                child: Row(
                  mainAxisAlignment:
                      isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                      width: isMe ? 30 : 0,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.all(3.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              blurRadius: .5,
                              spreadRadius: 1.0,
                              color: Colors.black.withOpacity(.12))
                        ],
                        color: bg,
                        borderRadius: radius,
                        image: DecorationImage(
                          image: NetworkImage(message),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: isMe ? 0 : 30,
                    ),
                  ],
                ),
              )
            : Row(
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                    width: isMe ? 30 : 0,
                  ),
                  Container(
                    margin: const EdgeInsets.all(3.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: .5,
                            spreadRadius: 1.0,
                            color: Colors.black.withOpacity(.12))
                      ],
                      color: bg,
                      borderRadius: radius,
                    ),
                    child: msgWidget,
                  ),
                  SizedBox(
                    width: isMe ? 0 : 30,
                  ),
                ],
              ),
        SizedBox(
          height: 3,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Row(
            mainAxisAlignment:
                !isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: <Widget>[
              Text(time,
                  style: TextStyle(
                    color: Colors.black38,
                    fontSize: 10.0,
                  )),
              SizedBox(width: 3.0),
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
