import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drively/components/line_bar.dart';
import 'package:drively/components/status_bar.dart';
import 'package:drively/utility/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:swipebuttonflutter/swipebuttonflutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class CarCondition extends StatefulWidget {
  List<Map<String, dynamic>?> grpData;

  CarCondition({required this.grpData, super.key});

  @override
  State<CarCondition> createState() => _CarConditionState();
}

class _CarConditionState extends State<CarCondition> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final ScrollController _controller = ScrollController();

  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  late StreamSubscription<Position> positionStream;
  String command = "";
  var ultraData = 100.0;

  Timer? _timer;
  Timer? timer2;
  bool accident = false;

  void _sendMessage() async {
    print("here");

    setState(() {
      command = String.fromCharCode(20);
    });

    final udpSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);

    udpSocket.broadcastEnabled = true;
    udpSocket.send(
        utf8.encode(command), InternetAddress('192.168.15.230'), 8888);

    udpSocket.listen((e) {
      final dg = udpSocket.receive();
      if (dg == null) {
        print("Nothing received");
        return;
      }

      var distance = dg.data.buffer.asFloat32List()[0];
      print(distance);
      setState(() {
        if (distance <= 0 || distance > 300) {
          ultraData = 0;
        } else if (distance >= 100) {
          ultraData = 100;
        } else {
          ultraData = distance;
        }
      });
      print("Received $ultraData");
    });

    if (ultraData <= 0) {
      _showFullScreenNotification();
      for (var user in widget.grpData) {
        for (var number in user!['users']) {
          sendPushMessage(number['token'], "$lat&&$long", "Accident Alert");
        }
      }
      //_showFullScreenNotification();

      setState(() {
        accident = true;
      });
    }

    /*  await Future.delayed(const Duration(milliseconds: 1000));
    udpSocket.close(); */
  }

  @override
  void initState() {
    checkGps();
    // TODO: implement initState
    super.initState();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    timer2 =
        Timer.periodic(const Duration(seconds: 1), (Timer t) => _sendMessage());
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("'Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        setState(() {
          //refresh the UI
        });

        getLocation();
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
    }

    setState(() {
      //refresh the UI
    });
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457

    long = position.longitude.toString();
    lat = position.latitude.toString();

    setState(() {
      //refresh UI
    });

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      print(position.longitude); //Output: 80.24599079
      print(position.latitude); //Output: 29.6593457

      long = position.longitude.toString();
      lat = position.latitude.toString();

      setState(() {
        //refresh UI on update
      });
    });
  }

  Future<bool> sendPushMessage(String? token, String body, String title) async {
    try {
      print('Token is  $token');
      //e1IpbddKQp2MsCDVUWTeAI:APA91bFOclxYUfpljy_FNNVIxoP81un3adUJb5rDqTYv4_EQFc1Q0ERwJ48uDWR1R2DkJ8--UUyiK8N0gCIZ69uhaVSomUKCYrXDe21Elg5Y2o1jhSuLiQaLZgcu6AyZ6LdJESllF1m-
      if (token == '') return false;
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAAOIGeRh8:APA91bH6zOiRpjoNAqoB9Fs_hTyXwf2OYGl8TlMrgcBY42XaTZlz9MEcLIZNzZiA8U2RHTtuGktE9bvQT6594FVqbfFbzffa0tgjKNC4WQxfKGSeiuMXBL8zEPUftFVdcOvV68AZ6R6W',
          },
          body: jsonEncode(<String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title,
            },
            'android': {
              'priority': 'high',
              'importance': 'max',
              'playSound': true,
              'fullScreenIntent': true
            },
            'notification': <String, dynamic>{
              "title": title,
              "body": body,
              "android_channel_id": "channel_id",
            },
            "to": token
          }));

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> _showNotification() async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your_channel_id', 'your_channel_name',
        channelDescription: 'your_channel_description',
        importance: Importance.max,
        priority: Priority.high,
        channelShowBadge: true,
        playSound: true,
        icon: '@mipmap/ic_launcher');

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        'False Alarm',
        'The Driver is safe and has cancelled the alarm',
        platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> _showFullScreenNotification() async {
    var action1 = const AndroidNotificationAction(
      'action_id_pickup',
      'See Location',
    );
    var action2 =
        const AndroidNotificationAction('action_id_decline', 'Decline');
    var actions = [action1, action2];

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your_channel_id', 'your_channel_name',
        channelDescription: 'your_channel_description',
        importance: Importance.max,
        priority: Priority.high,
        fullScreenIntent: true,
        channelShowBadge: true,
        playSound: true,
        actions: actions,
        icon: '@mipmap/ic_launcher');

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'Accident Alert!', "Click to see location", platformChannelSpecifics,
        payload: 'item x');
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _showFullScreenNotification();
      for (var user in widget.grpData) {
        for (var number in user!['users']) {
          sendPushMessage(number['token'], "$lat&&$long", "Accident Alert");
        }
      }
      //_showFullScreenNotification();

      setState(() {
        accident = true;
      });
    });
  }

  void stopTimer() {
    for (var user in widget.grpData) {
      for (var number in user!['users']) {
        sendPushMessage(
            number['token'],
            "The driver is safe and has turned off the alarm",
            "Driver is Safe!");
      }
    }
    //_showNotification();
    _timer?.cancel();
  }

  void scrollBottom() {
    _controller.jumpTo(_controller.position.maxScrollExtent);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer?.cancel();
    timer2?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.MainBackGroundColor),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20.0,
          ),
          CompStatus(data: 'Distance from Obstacle', status: ultraData),
          const SizedBox(
              height: 250,
              child: LineStatus(data: 'Sudden Jerks', status: 0.4)),
          const SizedBox(
            height: 20.0,
          ),
          Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Groups that will be notified...',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 13.0),
                  width: double.infinity,
                  child: Wrap(
                    direction: Axis.horizontal,
                    children: [
                      for (var grp in widget.grpData)
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 2.0),
                          decoration: BoxDecoration(
                              color: AppColors.ButtonBackGroundColor,
                              borderRadius: BorderRadius.circular(12.0)),
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            grp!['name'],
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20.0),
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: startTimer,
                child: const Text('Start Timer'),
              ),
              const SizedBox(height: 20),
            ],
          ),
          const Spacer(),
          Visibility(
            visible: accident,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SwipingButton(
                swipeButtonColor: Colors.red,
                backgroundColor: AppColors.ButtonBackGroundColor,
                text: "Cancel",
                iconColor: Colors.black,
                buttonTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                onSwipeCallback: () {
                  setState(() {
                    accident = false;
                  });
                  stopTimer();

                  print("Called back");
                },
                height: 90.0,
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }
}

//chassis pressure
//
