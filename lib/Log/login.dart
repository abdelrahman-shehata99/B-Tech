import 'package:btech/Home/admin.dart';
import 'package:btech/Home/home.dart';
import 'package:btech/Home/widgets/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

TextEditingController email = TextEditingController();
TextEditingController pass = TextEditingController();
TextEditingController token = TextEditingController();

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 228, 228, 228),
      appBar: null,
      body: Form(
        child: Center(
          child: ListView(
            children: [
              SizedBox(
                height: 100,
              ),
              Column(children: [
                Text('B.Tech',
                    style: TextStyle(
                        fontSize: 70,
                        color: Color.fromARGB(255, 0, 155, 117),
                        fontFamily: 'AmaticSC')),
              ]),
              SizedBox(
                height: 50,
              ),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: Column(
                  children: [
                    TextFormField(
                      controller: email,
                      onSaved: (value) {
                        email.text = value!;
                      },
                      validator: (value) {
                        if (value!.length > 100) {
                          return 'Email Cant Be Larger Than 100 Letter';
                        }
                        if (value.length < 4) {
                          return 'Email Cant Be Smaller Than 4 Letter';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(20)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(20)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(20)),
                          prefixIcon: Icon(
                            Icons.account_circle_outlined,
                            color: Colors.black,
                          ),
                          hintText: 'Email',
                          labelText: 'Email'),
                      cursorColor: Colors.black,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: pass,
                      onSaved: (value) {
                        pass.text = value!;
                      },
                      validator: (value) {
                        if (value!.length > 100) {
                          return 'PassWord Cant Be Larger Than 100 Letter';
                        }
                        if (value.length < 4) {
                          return 'Password Cant Be Smaller Than 4 Letter';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(20)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(20)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(20)),
                          prefixIcon: Icon(
                            Icons.admin_panel_settings_sharp,
                            color: Colors.black,
                          ),
                          hintText: 'Password',
                          labelText: 'Password',
                          focusColor: Colors.white),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          fixedSize: Size(300, 60),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.black),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        signInWithEmailAndPassword(context);
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 220,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signInWithEmailAndPassword(BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    final box = GetStorage();
    box.write('email', email.text);
    try {
      if (email.text == "A.abdelaal" && pass.text == "QAZxsw123") {
        Get.to(Admin());
        notify(context, "Welcome", "ADMIN");
        // Show notification for admin login
      } else {
        await _auth
            .signInWithEmailAndPassword(email: email.text, password: pass.text)
            .then((value) async {
          print("LOGIN DONE ");
          notify(context, 'Welcome!', 'Successfully Signed in');

          Get.to(Home());
          // Show notification for successful login
        });
      }
    } catch (e) {
      print(e.toString());
      print("ERRORR");
    }
  }
}
