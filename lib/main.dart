import 'package:connectivity/connectivity.dart';
import 'package:custom_splash/custom_splash.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vacinas_covid/model/vacinas_dssg.dart';
import 'package:vacinas_covid/providers/vacinas_dssg_req.dart';
import 'package:vacinas_covid/defaults.dart';
import 'ui/make_card.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Background messaging handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  //iOS foreground notification
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.instance.requestPermission();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Message data: ${message.data}');
  });

  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en', 'US'), Locale('pt', 'PT')],
        path: 'assets/translations',
        fallbackLocale: Locale('en', 'US'), //default locale
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: CustomSplash( //splashscreen
              imagePath: 'assets/img/splash.png',
              backGroundColor: AppDefaults.popupColor,
              animationEffect: 'zoom-in',
              logoSize: 400,
              home: MyApp(),
              duration: 2000,
              type: CustomSplashType.StaticDuration,
            ),
            ),
    ),
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vacinas Covid',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.exoTextTheme(
        Theme.of(context).textTheme),
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    checkInternetConnectivity();

    super.initState();

    // FIREBASE
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: 'launch_background',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMessageOpenedApp');
    });

    subscribre();
  }

  //subscribe topic general. This is the topic where daily vaccination updates will be sent
  Future<void> subscribre() async {
    await FirebaseMessaging.instance.subscribeToTopic('general');
  }

  // Display popup if no internet connection
  checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      _showDialog();
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('nointernet'.tr()),
          content: new Text('verifyconnection'.tr()),
          actions: <Widget>[
            new FlatButton(
              child: new Text('close'.tr()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //Fetch data from API
  Future<List<VaccinesDSSG>> fetchData() => Future.delayed(Duration(milliseconds: 300), () {
    return VacinasDSSGreq().getAdministeredVaccines();
  });


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppDefaults.backgroundTopColor,
                  AppDefaults.backgroundBottomColor,
                ],
                stops: [0.0, 1],
              ),
            ),
          ),
          SafeArea(
            child: FutureBuilder(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      MakeCard(id: 1, title: 'administeredvaccines'.tr(), field_type: 'doses', vacinas: snapshot.data, display_number: snapshot.data[snapshot.data.length - 1].doses),
                      MakeCard(id: 2, title: 'newdoses'.tr(), field_type: 'doses_novas', vacinas: snapshot.data, display_number: snapshot.data[snapshot.data.length - 1].doses_novas),
                      MakeCard(id: 3, title: 'firstdose'.tr(), field_type: 'doses1', vacinas: snapshot.data, display_number: snapshot.data[snapshot.data.length - 1].doses1),
                      MakeCard(id: 4, title: 'firstdosenew'.tr(), field_type: 'doses1_novas', vacinas: snapshot.data, display_number: snapshot.data[snapshot.data.length - 1].doses1_novas),
                      MakeCard(id: 5, title: 'seconddose'.tr(), field_type: 'doses2', vacinas: snapshot.data, display_number: snapshot.data[snapshot.data.length - 1].doses2),
                      MakeCard(id: 6, title: 'seconddosenew'.tr(), field_type: 'doses2_novas', vacinas: snapshot.data, display_number: snapshot.data[snapshot.data.length - 1].doses2_novas),
                      SizedBox(height: 5),
                      Center(
                        child: Text('dataof'.tr() + ' ' +
                            snapshot.data[snapshot.data.length - 1].data +
                            ' ' + 'datafrom'.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  );
                } 
              else {
                  //While no data, shows a circular progress indicator
                  return
                    Column(
                        children: [
                          Expanded(
                            flex: 8,
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(),
                                    ],
                                  ),
                              ),
                            ),
                          )
                        ]
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}