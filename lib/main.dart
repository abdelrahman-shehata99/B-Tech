import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:btech/Home/admin.dart';
import 'package:btech/Home/home.dart';
import 'package:btech/Log/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'Log/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  configureFirebaseMessaging();
  runApp(ChangeNotifierProvider(
    create: (context) => AuthProvider(),
    child: MyApp(),
  ));

  AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: 'basic-channel',
        channelName: 'Basic notifications',
        channelDescription: 'notification chanel for testing')
  ]);
}

FirebaseMessaging messaging = FirebaseMessaging.instance;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> configureFirebaseMessaging() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('your_channel_id', 'your_channel_name',
          importance: Importance.max, priority: Priority.high);

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  print("NOTIF");
  FirebaseMessaging.instance
      .getInitialMessage()
      .then((RemoteMessage? message) async {
    // Handle the initial message when the app is opened from a notification
    if (message != null) {
      print("Initial message: ${message.notification?.title}");
      triggerNotification(message.notification!.title!);
    }
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    triggerNotification(message.notification!.title!);
    print("Foreground message: ${message.notification?.title}");
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    print("Opened app message: ${message.notification?.title}");
    triggerNotification(message.notification!.title!);
  });

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    triggerNotification(message.notification!.title!);
    print("OPEN APP: ${message.notification?.title}");
    triggerNotification(message.notification!.title!);
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

triggerNotification(String msg) {
  AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 1, channelKey: 'basic-channel', title: 'B-TECH', body: msg));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: authProvider.user != null ? Home() : Login(),
      routes: {
        'login': (context) => Login(),
        'home': (context) => Home(),
        'register': (context) => Register(),
        'admin': (context) => Admin()
      },
    );
  }
}

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  AuthProvider() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print("Error signing in: $e");
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
