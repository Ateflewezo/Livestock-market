import 'package:flutter/material.dart';
import 'package:milyar/Utils/color.dart';

Widget text(BuildContext context, String text, EdgeInsets padding, Color color,
    double fontSize) {
  return Padding(
    padding: padding,
    child: Center(
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
      ),
    ),
  );
}

Widget text2(BuildContext context, String login, String account) {
  return Padding(
    padding: const EdgeInsets.only(top: 20),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              account,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, ),
            ),
          ),
          Text(
            login,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Color(getColorHexFromStr('#5FBB55'))),
          )
        ],
      ),
    ),
  );
}


Widget textFormFiledPhone(
    BuildContext context,
    TextInputType textInputType,
    Function(String) onSaved,
    String name,
    bool scure,
    TextEditingController controller,
    Function(String) vailder) {
  return Padding(
    padding: EdgeInsets.only(right: 20, left: 20, top: 20),
    child: TextFormField(
      
      onSaved: onSaved,
      controller: controller,
      // autovalidate: _autoValidate,
      validator: vailder,
      textAlign: TextAlign.center,
      keyboardType: textInputType,
      obscureText: scure,
      style:
          TextStyle(color: Color(getColorHexFromStr('#5FBB55')), fontSize: 15),
      decoration: InputDecoration(
        suffix:    Text("‎+966",style: TextStyle(fontSize:15,fontWeight: FontWeight.bold,)),
          errorStyle: TextStyle(
            color: Color(getColorHexFromStr('#FC7D3C')),
            fontSize: 13,
          ),
          contentPadding:
              new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Color(getColorHexFromStr('#FAFAFA')), width: 1.0),
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
          filled: true,
          fillColor: Color(getColorHexFromStr('#FAFAFA')),
          hintText: name,
          hintStyle: TextStyle(
              color: Color(getColorHexFromStr('#A3A3A3')),
              fontWeight: FontWeight.bold)),
    ),
  );
}






Widget textFormFiled(
    BuildContext context,
    TextInputType textInputType,
    Function(String) onSaved,
    String name,
    bool scure,
    TextEditingController controller,
    Function(String) vailder) {
  return Padding(
    padding: EdgeInsets.only(right: 20, left: 20, top: 20),
    child: TextFormField(
      
      onSaved: onSaved,
      controller: controller,
      // autovalidate: _autoValidate,
      validator: vailder,
      textAlign: TextAlign.center,
      keyboardType: textInputType,
      obscureText: scure,
      style:
          TextStyle(color: Color(getColorHexFromStr('#5FBB55')), fontSize: 15),
      decoration: InputDecoration(
       
          errorStyle: TextStyle(
            color: Color(getColorHexFromStr('#FC7D3C')),
            fontSize: 13,
          ),
          contentPadding:
              new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Color(getColorHexFromStr('#FAFAFA')), width: 1.0),
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
          filled: true,
          fillColor: Color(getColorHexFromStr('#FAFAFA')),
          hintText: name,
          hintStyle: TextStyle(
              color: Color(getColorHexFromStr('#A3A3A3')),
              fontWeight: FontWeight.bold)),
    ),
  );
}

Widget textFormFiledSearch(
    BuildContext context,
    Function(String) validator,
    TextInputType textInputType,
    Function(String) onSaved,
    String name,
    bool scure,
     TextEditingController initialValue,
    Widget widget) {
  return Padding(
    padding: EdgeInsets.only(right: 20, left: 20, top: 20),
    child: TextFormField(
      onSaved: onSaved,
      // autovalidate: _autoValidate,
      validator: validator,
      keyboardType: textInputType,
      obscureText: scure,
       controller: initialValue,
      style:
          TextStyle(color: Color(getColorHexFromStr('#5FBB55')), fontSize: 15),
      decoration: InputDecoration(
          errorStyle: TextStyle(
            color: Color(getColorHexFromStr('#E8883E')),
            fontSize: 13,
          ),
          contentPadding:
              new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Color(getColorHexFromStr('#E7E7E7')), width: 1.0),
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
          filled: true,
          suffixIcon: widget,
          fillColor: Color(getColorHexFromStr('#E9E9E9')),
          hintText: name,
          hintStyle: TextStyle(
              color: Color(getColorHexFromStr('#A3A3A3')),
              fontWeight: FontWeight.bold)),
    ),
  );
}

Widget textFormFiledUpdate(
    BuildContext context,
    Function(String) vailder,
    TextInputType textInputType,
    Function(String) onSaved,
    String name,
    bool scure,

    TextEditingController initialValue,bool enabled) {
  return Padding(
    padding: EdgeInsets.only(
      right: 20,
      left: 20,
    ),
    child: TextFormField(
      enabled:enabled ,
      onSaved: onSaved,
      // autovalidate: _autoValidate,
      validator: vailder,
      keyboardType: textInputType,
      obscureText: scure,
      controller: initialValue,
      style:
          TextStyle(color:  Colors.blue, fontSize: 15),
      decoration: InputDecoration(
          errorStyle: TextStyle(
            color: Color(getColorHexFromStr('#E8883E')),
            fontSize: 13,
          ),
          contentPadding:
              new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          filled: true,
          hintText: name,
          fillColor: Colors.white.withOpacity(.1),
          focusColor: Color(getColorHexFromStr('#B7B7B7')),
          hintStyle: TextStyle(
              color:  Color(getColorHexFromStr('#A4A4A4')),
              fontWeight: FontWeight.bold)),
    ),
  );
}
