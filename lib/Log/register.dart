import 'package:btech/Home/widgets/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController NameController = TextEditingController();
final TextEditingController addressController = TextEditingController();
final TextEditingController idController = TextEditingController();
final TextEditingController idCarController = TextEditingController();

class _RegisterState extends State<Register> {
  void createUserWithEmailAndPassword(BuildContext context) async {
    await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final box = GetStorage();

    // Get the image URL
    // save user email
    box.write('email', emailController.text);
    box.write('password', passwordController.text);

    try {
      await _auth.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } catch (e) {
      print(e.toString());
      print("ERRORR");
    }
    try {
      await _firestore.collection('users').add({
        'name': NameController.text,
        'password': passwordController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'address': addressController.text,
        'id': idController.text,
        'carId': idCarController.text,
        'uid': FirebaseAuth.instance.currentUser!.uid
      }).then((value) async {
        notify(context, "Completed", "Successfully Registered in");
      });
    } catch (e) {
      print(e.toString());
      notify(context, "Error", e.toString());
      print("ERRORR");
    }
  }

  late String email, password, name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: null,
        body: Center(
            child: Form(
          child: ListView(
            padding: EdgeInsets.all(10),
            children: [
              SizedBox(
                height: 10,
              ),
              txtField(
                  'Name Cant Be Larger Than 100 Letter',
                  'Name Cant Be Smaller Than 4 Letter',
                  'Name',
                  Icons.account_box_sharp,
                  TextInputType.name,
                  NameController),
              txtField(
                  'Email Cant Be Larger Than 100 Letter',
                  'Email Cant Be Smaller Than 4 Letter',
                  'Email',
                  Icons.attach_email_outlined,
                  TextInputType.name,
                  emailController),
              txtField(
                  'ID Cant Be Larger Than 20 Number',
                  'ID Cant Be Smaller Than 11 Number',
                  'ID',
                  Icons.card_membership,
                  TextInputType.number,
                  idController),
              txtField(
                  'Car Id Cant Be Larger Than 20 Number',
                  'Car Id Cant Be Smaller Than 11 Number',
                  'Car ID',
                  Icons.emoji_transportation,
                  TextInputType.text,
                  idCarController),
              txtField(
                  'PassWord Cant Be Larger Than 100 Letter',
                  'Password Cant Be Smaller Than 4 Letter',
                  'Password',
                  Icons.password_outlined,
                  TextInputType.name,
                  passwordController),
              txtField(
                  'Address Cant Be Larger Than 100 Letter',
                  'Address Cant Be Smaller Than 4 Letter',
                  'Address',
                  Icons.location_city,
                  TextInputType.name,
                  addressController),
              txtField(
                  'Number Cant Be Larger Than 20 Number',
                  'Number Cant Be Smaller Than 11 Number',
                  'Number',
                  Icons.numbers_outlined,
                  TextInputType.number,
                  phoneController),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  createUserWithEmailAndPassword(context);
                },
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    backgroundColor: Colors.black),
              ),
            ],
          ),
        )));
  }
}

txtField(String txtF, txtS, txtT, IconData icon, TextInputType type,
    TextEditingController control) {
  return Column(
    children: [
      TextFormField(
          controller: control,
          onSaved: (value) {
            control.text = value!;
          },
          validator: (value) {
            if (value!.length > 100) {
              return txtF;
            }
            if (value.length < 4) {
              return txtS;
            }
            return null;
          },
          cursorRadius: Radius.circular(20),
          keyboardType: type,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            hintText: txtT,
            labelText: txtT,
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(30)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(30)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(30)),
          )),
      SizedBox(
        height: 20,
      ),
    ],
  );
}
