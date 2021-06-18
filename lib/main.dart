import 'package:location/location.dart';
import 'package:milyar/Language/all_translations.dart';
import 'package:flutter/material.dart';
import 'package:milyar/Language/translations.dart';
import 'package:milyar/Utils/color.dart';
import 'package:milyar/Widget/Delegate.dart';
import 'package:milyar/pages/SplashScreen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_map_location_picker/generated/i18n.dart'
    as location_picker;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await allTranslations.init();
  // runApp(  DevicePreview(
  //   builder: (context) => MyApp(),
  // ),
  // );
  
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  _MyAppState createState() => _MyAppState();

  // static restartApp(BuildContext context) {
  //   // final _MyAppState state =
  //   //     context.ancestorStateOfType(const TypeMatcher<_MyAppState>());
  //   state.restartApp();
  // }
}

class _MyAppState extends State<MyApp> {
  Key key = new UniqueKey();

  void restartApp() {
    this.setState(() {
      key = new UniqueKey();
    });
  }

  Location _location = Location();

  GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
  // AppPushNotifications appPushNotifications = AppPushNotifications();
   
  @override
 void initState()  {
   
    // SharedPreferences.getInstance();
    // // appPushNotifications.notificationSetup(navKey);
    // SharedPreferences.getInstance().then((prefs) {
    //   print("gggggggggggggg ${prefs.getString('jwt')}");
    // });
    super.initState();
    _location.getLocation().then((value)async {
        SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
    preferences.setDouble('longitude', value.longitude);  
     preferences.setDouble('latitude', value.latitude);  
       print("ateffffLocation******************");
         print(value.longitude.toString());
       print(value.latitude.toString());
       print("////////////${preferences.getDouble("longitude").toString()}");
      });
    });
    allTranslations.onLocaleChangedCallback = _onLocaleChanged;
  }

  _onLocaleChanged() async {
    print('Language has been changed to: ${allTranslations.currentLanguage}');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: key,
      navigatorKey: navKey,
      theme: ThemeData(
          fontFamily: 'cairo',
          primaryColor: Color(getColorHexFromStr('#FAFAFA'))),
      debugShowCheckedModeBanner: false,
      locale: Locale(allTranslations.currentLanguage),
      localizationsDelegates: [
        location_picker.S.delegate,
        const FallbackCupertinoLocalisationsDelegate(),
        TranslationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      // Tells the system which are the supported languages
      supportedLocales: allTranslations.supportedLocales(),
      home: SplashScreen(),
    );
  }
}
