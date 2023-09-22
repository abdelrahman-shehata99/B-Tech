import 'dart:convert';

import 'package:btech/Home/pages/first.dart';
import 'package:btech/Home/pages/secound.dart';
import 'package:btech/Home/widgets/button.dart';
import 'package:btech/Log/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = [
    First(),
    Secound(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final fcmToken = FirebaseMessaging.instance.getToken();

  Future<void> updateFCMToken(String userId, String? token) async {
    final userCollection = FirebaseFirestore.instance.collection('users');
    try {
      final userQuery =
          await userCollection.where('uid', isEqualTo: userId).get();
      if (userQuery.docs.isNotEmpty) {
        final userDoc = userQuery.docs.first;
        await userDoc.reference.update({'fcmToken': token});
        print('FCM Token Updated Successfully');
      } else {
        print('User document not found for UID: $userId');
      }
    } catch (e) {
      print('Error updating FCM Token: $e');
    }
  }

  sendNotificationNow({required String token}) async {
    var responseNotification;
    Map<String, String> headerNotification = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAzNhXhuY:APA91bHdpjWaAmiRRrf5dqicQqvJ-C0yvPjYL1LBPNLrGcdgU44lhsCD5xJjepg9EPvA-fRAu7heW9ZQW2aIZQ-xNQDR229u347Vn26mcea0P2NMK23VjeQHUfTjII_2VQElEfU8cfMy'
    };

    Map bodyNotification = {
      "body": " طلب جديد علي متجرك  ",
      "title": "Welcome to B-Tech "
    };
    Map dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      //   "rideRequestId": docId
    };

    Map officialNotificationFormat = {
      "notification": bodyNotification,
      "data": dataMap,
      "priority": "high",
      "to": token,
    };

    try {
      print('try send notification');
      responseNotification = http
          .post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: headerNotification,
        body: jsonEncode(officialNotificationFormat),
      )
          .then((value) {
        print('NOTIFICATION SENT ==$value');
      });
    } catch (e) {
      print("NOTIFICATION ERROR===$e");
    }
    return responseNotification;
  }

  void signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      notify(context, "User signed out", 'Successfully');
      Get.to(Login());
    } catch (e) {
      notifyE("Error signing out: $e");
    }
  }

  @override
  void initState() {
    fcmToken.then((value) {
      final userId = FirebaseAuth.instance.currentUser;
      if (userId != null) {
        updateFCMToken(userId.uid, value);
        sendNotificationNow(token: value.toString());
      }
    });

    print('-------------');
    super.initState();
  }

  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 247, 247, 247),
          appBar: AppBar(
            leading: IconButton(
                onPressed: signOut,
                icon: Icon(
                  Icons.logout,
                  color: Colors.red,
                )),
            actions: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('uid', isEqualTo: userId)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    case ConnectionState.none:
                      break;
                    case ConnectionState.active:
                      break;
                    case ConnectionState.done:
                      break;
                  }
                  if (snapshot.data!.docs.length > 0) {
                    return ListView.builder(
                      primary: false,
                      padding: EdgeInsets.only(left: 6, right: 6),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot posts = snapshot.data!.docs[index];
                        return Row(
                          children: [
                            Text('${posts['id']}'),
                            SizedBox(
                              width: 10,
                            ),
                            Text('${posts['name']}')
                          ],
                        );
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
            title: Column(
              children: [
                Text(
                  'B.TECH',
                  style: TextStyle(
                      fontSize: 20, color: Color.fromARGB(255, 0, 155, 117)),
                ),
                Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontFamily: 'Indie',
                  ),
                ),
              ],
            ),
            centerTitle: true,
            backgroundColor: Colors.black,
          ),
          body: TabBarView(
            children: [_widgetOptions.elementAt(_selectedIndex)],
          ),
          bottomNavigationBar: btmNav(),
        ));
  }

  btmNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amberAccent,
      unselectedItemColor: Colors.black,
      backgroundColor: Colors.white,
      onTap: _onItemTapped,
      selectedFontSize: 15,
      selectedLabelStyle: TextStyle(fontFamily: 'Indie'),
      selectedIconTheme: IconThemeData(size: 30, grade: 20),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'الادوار',
          backgroundColor: Colors.white,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.car_crash),
          label: 'المأموريات',
          backgroundColor: Colors.white,
        ),
      ],
    );
  }
}
