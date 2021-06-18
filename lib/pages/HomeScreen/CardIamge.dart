import 'package:flutter/material.dart' as prefix0;
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:milyar/Models/AdsDetailsModel.dart';
import 'package:flutter/material.dart';

class CardImage extends StatefulWidget {
  final List<Map<dynamic, String>> images;

  const CardImage({Key key, this.images}) : super(key: key);
  @override
  _CardImageState createState() => _CardImageState();
}

class _CardImageState extends State<CardImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          new Swiper(
            itemBuilder: (BuildContext context, int index) {
              return prefix0.Image.network(
                "https://souq-mawashi.com" +
                    widget.images[index]['image'],
                fit: BoxFit.cover,
              );
            },
            itemCount: widget.images.length,
            pagination: SwiperPagination(),
            control: new SwiperControl(),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.close,
                  size: 50,
                  color: Colors.red,
                )),
          ),
        ],
      ),
    );
  }
}
