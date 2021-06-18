import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:milyar/Language/all_translations.dart';
import 'package:milyar/Models/AuthModels/SendMessageModels.dart';
import 'package:milyar/Models/AuthModels/getMessageReciverId.dart';
import 'package:milyar/ScoppedModels/ScoppedModels/Network_Utils.dart';

import 'package:milyar/Models/AuthModels/getMessageReciverId.dart' as prefix0;

import 'package:milyar/Utils/Push_notifications.dart';
import 'package:milyar/Utils/color.dart';
import 'package:milyar/Widget/MessageCard.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreenDetails extends StatefulWidget {
  final int conversationId;
  final String name;

  const ChatScreenDetails({Key key, this.conversationId, this.name})
      : super(key: key);
  @override
  _ChatScreenDetailsState createState() => _ChatScreenDetailsState();
}

class _ChatScreenDetailsState extends State<ChatScreenDetails> {
  TextEditingController _messageController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  File image;
  bool _fileUploading = false;
  bool isLoading = false;
  NetworkUtil util = NetworkUtil();
  Message _messages;
  List<Message> _messagesList = [];
  GetAllMessageReciverIdChatModel getAllMessageReciverIdChatModel =
      GetAllMessageReciverIdChatModel();

  _getAboutClient() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();

    Map<String, dynamic> _headers = {
      "Authorization": "Bearer " + preferences.getString("jwt"),
    };

    print(widget.conversationId.toString() +
        'asdddddddddddddddddddddddddddddddddddddddd');
    Response response =
        await util.get('open/chat/${widget.conversationId}', headers: _headers);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      setState(() {
        getAllMessageReciverIdChatModel =
            GetAllMessageReciverIdChatModel.fromJson(response.data);
        _messagesList = GetAllMessageReciverIdChatModel.fromJson(response.data)
            .data
            .messages;

        isLoading = false;
      });
    } else {}
  }

  SendMessageChat sendMessageChat = SendMessageChat();
  submitMessage(BuildContext context) async {
    if (_messageController.text == '') {
      return null;
    }
    _messages = Message();
    _messages.message = _messageController.text;
    _messages.messageType = "text";
    _messages.senderData =
        prefix0.SenderData(id: meId, profileImage: imageUser, username: name);
    getAllMessageReciverIdChatModel.data.receiver = prefix0.Receiver(
        id: widget.conversationId,
        fullName: getAllMessageReciverIdChatModel.data.receiver.fullName,
        image: getAllMessageReciverIdChatModel.data.receiver.image);
    _messages.createdAt = '';
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 500,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map<String, dynamic> _headers = {
      "Authorization": "Bearer " + preferences.getString("jwt"),
    };
    setState(() {
      _messagesList.add(_messages);
    });
    FormData _formData = FormData.fromMap({
      "message": _messageController.text,
      "type": 'text',
      "receiver_id": widget.conversationId
    });
    util
        .post('send/new/message', body: _formData, headers: _headers)
        .then((result) {
      print("---------> $result");
      if (result.statusCode == 200) {
        _messageController.text = "";

        setState(() {
          sendMessageChat = SendMessageChat.fromJson(result.data);
        });
      }
    });
  }

  uploadImage(StateSetter setXState, File image, BuildContext context) async {
    setXState(() {
      _fileUploading = true;
    });

    Message _message = Message();
    _message.message = image.path;
    _message.messageType = "image";
    _message.senderData =
        prefix0.SenderData(id: meId, profileImage: imageUser, username: name);
    getAllMessageReciverIdChatModel.data.receiver = Receiver(
        id: widget.conversationId,
        fullName: getAllMessageReciverIdChatModel.data.receiver.fullName,
        image: getAllMessageReciverIdChatModel.data.receiver.image);
    _message.createdAt = '';
    SharedPreferences preferences = await SharedPreferences.getInstance();

    Map<String, dynamic> _headers = {
      "Authorization": "Bearer " + preferences.getString("jwt"),
    };
    this.setState(() {
      _messagesList.add(_message);
    });
    setXState(() {
      _fileUploading = false;
    });

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 500,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
    Map<String, dynamic> addData = {
      "type": 'image',
      "receiver_id": widget.conversationId
    };

    if (image != null) {
      addData.putIfAbsent(
        "message",
        () => MultipartFile.fromFileSync(image.path,
            filename: basename(image.path)),
      );
    }
    FormData _formData = FormData.fromMap(addData);

    util
        .post('send/new/message', body: _formData, headers: _headers)
        .then((result) {
      Navigator.pop(context);
      Navigator.pop(context);
      print("---------> $result");
      if (result.statusCode == 200) {
        setState(() {
          sendMessageChat = SendMessageChat.fromJson(result.data);
          _getAboutClient();
        });
      }
    });
  }

  // sendFile(BuildContext context) async {
  //   Message _message = Message();
  //   _message.message = _fileName;
  //   _message.messageType = "file";
  //   _message.senderData =
  //       prefix0.SenderData(id: meId, profileImage: imageUser, username: name);
  //   getAllMessageReciverIdChatModel.data.receiver = Receiver(
  //       id: widget.conversationId,
  //       fullName: getAllMessageReciverIdChatModel.data.receiver.fullName,
  //       image: getAllMessageReciverIdChatModel.data.receiver.image);
  //   _message.createdAt = '';
  //   SharedPreferences preferences = await SharedPreferences.getInstance();

  //   FormData _headers = FormData.from({
  //     "Authorization": "Bearer " + preferences.getString("jwt"),
  //   });
  //   this.setState(() {
  //     _messagesList.add(_message);
  //   });

  //   _scrollController.animateTo(
  //     _scrollController.position.maxScrollExtent + 500,
  //     curve: Curves.easeOut,
  //     duration: const Duration(milliseconds: 300),
  //   );
  //   FormData _formData =
  //       FormData.from({"type": 'file', "receiver_id": widget.conversationId});

  //    if (image != null) {
  //     addData.putIfAbsent(
  //       "message",
  //       () => MultipartFile.fromFileSync(image.path,
  //           filename: basename(image.path)),
  //     );
  //   }

  //   util
  //       .post('send/new/message', body: _formData, headers: _headers)
  //       .then((result) {
  //     Navigator.pop(context);
  //     Navigator.pop(context);
  //     print("---------> $result");
  //     if (result.statusCode == 200) {
  //       setState(() {
  //         sendMessageChat = SendMessageChat.fromJson(result.data);
  //       });
  //     }
  //   });
  // }

  void _openImageDialog(BuildContext context, File image) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setXState) {
              return CupertinoAlertDialog(
                title: Text(
                  allTranslations.currentLanguage == 'ar'
                      ? "تأكيد "
                      : "Image Preview",
                  style: TextStyle(
                    color: CupertinoColors.activeBlue,
                  ),
                ),
                content: Container(
                  padding: EdgeInsets.only(top: 8),
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(image), fit: BoxFit.cover),
                  ),
                ),
                actions: <Widget>[
                  CupertinoButton(
                    child: Text("Cancel"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  _fileUploading
                      ? Center(
                          child: CupertinoActivityIndicator(
                            animating: true,
                            radius: 12,
                          ),
                        )
                      : CupertinoButton(
                          child: Text("Send"),
                          onPressed: () {
                            uploadImage(setXState, image, context);
                          },
                        ),
                ],
              );
            },
          );
        });
  }

  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 400.0).then((File image) {
      if (image != null) {
        setState(() {
          image = image;
        });
      }
      _openImageDialog(context, image);
    });
  }

  void _imagePicker(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            cancelButton: CupertinoButton(
              child: Text(
                allTranslations.currentLanguage == 'ar' ? "الرجوع" : "Cancel",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Color(getColorHexFromStr("#2c6468")),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: <Widget>[
              CupertinoButton(
                child: Row(
                  children: <Widget>[
                    Icon(
                      CupertinoIcons.photo_camera_solid,
                      color: Color(getColorHexFromStr("#2c6468")),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      allTranslations.currentLanguage == 'ar'
                          ? "الكاميرا"
                          : "camera",
                      style: TextStyle(
                        color: Color(getColorHexFromStr("#307e85")),
                        fontSize: 15,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
                onPressed: () => _getImage(context, ImageSource.camera),
              ),
              CupertinoButton(
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.insert_photo,
                      color: Color(getColorHexFromStr("#2c6468")),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      allTranslations.currentLanguage == 'ar'
                          ? "الاستديو"
                          : "gallery",
                      style: TextStyle(
                        color: Color(getColorHexFromStr("#307e85")),
                        fontSize: 15,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
                onPressed: () => _getImage(context, ImageSource.gallery),
              ),
              // CupertinoButton(
              //     child: Row(
              //       children: <Widget>[
              //         Icon(
              //           Icons.file_download,
              //           color: Color(getColorHexFromStr("#2c6468")),
              //         ),
              //         SizedBox(
              //           width: 20,
              //         ),
              //         Text(
              //           allTranslations.currentLanguage == 'ar'
              //               ? "ارسال ملف"
              //               : "Send",
              //           style: TextStyle(
              //             color: Color(getColorHexFromStr("#307e85")),
              //             fontSize: 15,
              //             fontFamily: 'Cairo',
              //           ),
              //         ),
              //       ],
              //     ),
              //     onPressed: () => _openFileExplorer(context)),
            ],
          );
        });
  }

  int meId;
  String imageUser;
  String name;
  _getIdFromCach() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      meId = preferences.getInt('id');
      imageUser = preferences.getString('image');
      name = preferences.getString('full_name');
      print(meId.toString() + 'asddddddddddddddddddddddd');
    });
  }

  // AppPushNotifications _appPushNotifications = AppPushNotifications();

  @override
  void initState() {
    // _appPushNotifications.notificationSubject.stream
    //     .listen((Map<dynamic, dynamic> data) {
    //   print(
    //       "++++++++++++kosom 3ali rabea3+++++++++> ${data['data']['sender_id']}");

    //   // print(data is Map);

    //   setState(() {
    //     _messagesList.add(
    //       Message(
    //         senderData: prefix0.SenderData(
    //           id: int.parse(data['data']['sender_id']),
    //           username: "",
    //           profileImage: data['data']['sender_image'],
    //         ),
    //         messageType: data['data']['type'],
    //         message: data['data']['body'],
    //       ),
    //     );
    //   });
    // });

    _getIdFromCach();
    _getAboutClient();
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
              title: Text(
                widget.name,
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              leading: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.blue,
                    size: 35,
                  )),
              centerTitle: true,
            ),
            body: Column(
              children: <Widget>[
                isLoading
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 200),
                          child: CupertinoActivityIndicator(
                            animating: true,
                            radius: 15,
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                            controller: _scrollController,
                            itemCount: _messagesList.length,
                            itemBuilder: (BuildContext ctx, int index) {
                              return Bubble(
                                type: _messagesList[index].messageType,
                                userImage:
                                    _messagesList[index].senderData.id != meId
                                        ? _messagesList[index]
                                            .senderData
                                            .profileImage
                                        : getAllMessageReciverIdChatModel
                                            .data.receiver.image,
                                time: _messagesList[index].createdAt,
                                message: _messagesList[index].message,
                                isMe: _messagesList[index].senderData.id == meId
                                    ? true
                                    : false,
                              );
                            }),
                      )
              ],
            ),
            bottomNavigationBar: _SystemPadding(
                child: BottomAppBar(
              shape: CircularNotchedRectangle(),
              child: Container(
                height: 65,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    VerticalDivider(
                      width: 3,
                      indent: 5,
                      endIndent: 5,
                      color: Color(getColorHexFromStr("#c1c1c1")),
                    ),
                    Expanded(
                      child: Container(
                        child: ConstrainedBox(
                          constraints: new BoxConstraints(
                            maxHeight: 150,
                          ),
                          child: TextFormField(
                            controller: _messageController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(getColorHexFromStr('#FAFAFA')),
                                    width: 1.0),
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
                              fillColor: Color(getColorHexFromStr('#FAFAFA')),
                              suffixIcon: Container(
                                  height: 5,
                                  width: 5,
                                  child: IconButton(
                                    onPressed: () {
                                      _imagePicker(context);
                                    },
                                    icon: Icon(
                                      Icons.file_upload,
                                    ),
                                    iconSize: 30,
                                    color: Colors.blue,
                                  )),

                              // border: InputBorder.none,
                              contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              hintText: 'اضف تعليقك هنا',
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        submitMessage(context);
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(15)),
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          )),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            ))));
  }
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
