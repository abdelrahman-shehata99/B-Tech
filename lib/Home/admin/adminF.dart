import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminF extends StatefulWidget {
  const AdminF({Key? key}) : super(key: key);

  @override
  _AdminFState createState() => _AdminFState();
}

class _AdminFState extends State<AdminF> {
  void reauthenticateAndDeleteUser(
      String password, String documentId, String email) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Create a credential with the user's email and password
        AuthCredential credential = await EmailAuthProvider.credential(
          email: email,
          password: password,
        );

        // Reauthenticate the user with the credential
        await user.reauthenticateWithCredential(credential);

        // After reauthentication, you can safely delete the user's account
        await user.delete();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(documentId)
            .delete();

        // Show a success message using a Dialog
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text('User Deleted'),
              content: Text('User deleted successfully.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Show an error message using a Dialog
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('No user is currently signed in.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Show an error message using a Dialog
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text('Error Deleting User'),
            content: Text('An error occurred while deleting the user: $e'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          );
        },
      );
      print("Error deleting user: $e");
    }
  }

  void deleteDocument(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(documentId)
          .delete();
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
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
          return ListView(children: [
            Text(
              "Drivers",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontFamily: 'Thasadith',
              ),
            ),
            ListView.builder(
              primary: false,
              padding: EdgeInsets.only(left: 6, right: 6),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot posts = snapshot.data!.docs[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.3),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          posts['name'],
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        Text(
                          posts['id'],
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        Text(
                          posts['carId'],
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        Text(
                          posts['password'],
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        Text(
                          posts['phone'],
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        // IconButton(
                        //   onPressed: () {
                        //     reauthenticateAndDeleteUser(
                        //         posts['password'], posts.id, posts['email']);
                        //   },
                        //   color: Colors.redAccent,
                        //   icon: Icon(Icons.delete_sweep),
                        // )
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      elevation: 1,
                      backgroundColor: Colors.white,
                    ),
                  ),
                );
              },
            )
          ]);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
