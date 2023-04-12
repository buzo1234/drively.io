import 'package:drively/models/user_shared_ref.dart';
import 'package:drively/screens/home_page.dart';
import 'package:drively/screens/login_phone.dart';
import 'package:drively/services/shared_refs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //most important thing is to initialise firebase in project
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) {
      runApp(const MyApp());
    },
  );
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  description: 'This is the notification description', 'channel_id', // id
  'dbclass', // title
// description

  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPref sharedPref = SharedPref();
  UserLocalSave userLoad = UserLocalSave();

  loadSharedPrefs() async {
    try {
      UserLocalSave user =
          UserLocalSave.fromJson(await sharedPref.read("user"));
      print('User is $user');
      setState(() {
        userLoad = user;
      });
    } catch (e) {
      print("Nothing found $e");
    }
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void _onSelectNotification(NotificationResponse respo) {
    String? payload = respo.payload;
    print("Notification Tapped");
    if (payload != null) {
      print(payload);
    }
  }

  Future<void> openMap(double latitude, double longitude) async {
    Uri googleUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSharedPrefs();
    requestPermission();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('ic_launcher');
    var initialzationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: _onSelectNotification,
        onDidReceiveBackgroundNotificationResponse: _onSelectNotification);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        var bigTextStyleInformation =
            BigTextStyleInformation(notification.body as String);
        List<String>? geo = notification.body?.split('&&');
        await flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                styleInformation: bigTextStyleInformation,
                channelDescription: channel.description,
                color: Colors.blue,
                priority: Priority.high,
                importance: Importance.high,
                fullScreenIntent: true,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: "@mipmap/ic_launcher",
              ),
            ),
            payload: notification.body);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title ?? ''),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification.body ?? ''),
                      ElevatedButton(
                          onPressed: () {
                            openMap(-3.823216, -38.481700);
                          },
                          child: const Text("Show Location"))
                    ],
                  ),
                ),
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('loaded user is ${userLoad.toJson().toString()}');
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MaterialApp(
        theme: ThemeData(
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.white, //<-- SEE HERE
                //displayColor: Colors.pinkAccent, //<-- SEE HERE
              ),
        ),
        debugShowCheckedModeBanner: false,
        home: userLoad.phone != null
            ? userLoad.role == 'driver'
                ? HomeScreen(user: userLoad)
                : HomeScreen(user: userLoad)
            : const LoginWithPhone(),
      ),
    );
  }
}
