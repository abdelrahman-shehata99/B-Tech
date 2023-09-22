import 'package:btech/Home/widgets/appbar.dart';
import 'package:btech/Home/widgets/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Third extends StatefulWidget {
  const Third({Key? key}) : super(key: key);

  @override
  _ThirdState createState() => _ThirdState();
}

final TextEditingController dateController = TextEditingController();
final TextEditingController omsController = TextEditingController();
final TextEditingController floorController = TextEditingController();
final TextEditingController productController = TextEditingController();
final TextEditingController representController = TextEditingController();
final TextEditingController carIdController = TextEditingController();
final TextEditingController uidController = TextEditingController();
final TextEditingController driverController = TextEditingController();

class _ThirdState extends State<Third> {
  void addDataToFirestore() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: userId)
          .get();
      setState(() {
        var data = snapshot.docs.first.data() as Map<String, dynamic>;
        var datw = data['carId'];
        var uid = data['uid'];
        var driver = data['name'];

        carIdController.text = datw;
        uidController.text = uid;
        driverController.text = driver;
      });
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('roles');

      Map<String, dynamic> data = {
        'date': dateController.text,
        'oms': omsController.text,
        'floor': floorController.text,
        'product': productController.text,
        'represent': representController.text,
        'carId': carIdController.text,
        'driverName': driverController.text,
        'uid': uidController.text,
        'status': 'Not Approved'
      };

      // Add the data to Firestore
      await collectionReference.add(data);
      notify(context, 'Congratulations!', 'Item Published');
    } catch (e) {
      print('Error adding data: $e');
    }
  }

  List<String> floor = ['الدور', '4', '5', '6', '7', '8', '9', '10', '11'];
  String selectedFloor = 'الدور';

  List<String> product = [
    'ثلاجة',
    'بوتجاز',
    'غسالة',
    'ديب فريزر',
    'تكييف 3 حصان',
    'شاشة',
    'مبرد'
  ];
  List<String> selectedProduct = [];

  void _openMultiChoiceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AppBar(
                    title: Text('أختار'),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.done),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  Flexible(
                    child: ListView.builder(
                      itemCount: product.length,
                      itemBuilder: (BuildContext context, int index) {
                        final choice = product[index];
                        return CheckboxListTile(
                          title: Text(choice),
                          value: selectedProduct.contains(choice),
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                selectedProduct.add(choice);
                                productController.text =
                                    selectedProduct.join(", ");
                              } else {
                                selectedProduct.remove(choice);
                                productController.text =
                                    selectedProduct.join(", ");
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  txtFieldCheck(var icon) {
    return Column(
      children: [
        TextField(
          readOnly: true,
          onTap: () {
            _openMultiChoiceDialog(context);
          },
          controller: productController,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(20)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(20)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(20)),
              prefixIcon: Icon(
                icon,
                color: Colors.black,
              ),
              hintText: productController.text,
              labelText: productController.text),
          cursorColor: Colors.black,
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("Data", context),
      body: ListView(padding: EdgeInsets.all(20), children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: []),
        SizedBox(
          height: 20,
        ),
        txtFieldDate('التاريخ', Icons.date_range, dateController,
            TextInputType.datetime, context),
        SizedBox(
          height: 20,
        ),
        txtField(
            'OMS', Icons.password_rounded, omsController, TextInputType.number),
        SizedBox(
          height: 20,
        ),
        txtFieldCheck(Icons.shopping_cart),
        SizedBox(
          height: 20,
        ),
        DropdownButton(
            dropdownColor: Colors.white,
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down_circle_outlined),
            onChanged: (value) {
              setState(() {
                selectedFloor = '$value';
                floorController.text = selectedFloor;
              });
            },
            value: selectedFloor,
            items: floor.map((e) {
              return DropdownMenuItem(
                child: Text(
                  e,
                  style: TextStyle(color: Colors.black),
                ),
                value: e,
              );
            }).toList()),
        SizedBox(
          height: 30,
        ),
        txtField('اسم المندوب', Icons.person, representController,
            TextInputType.text),
        SizedBox(height: 40),
        ElevatedButton(
          onPressed: () {
            addDataToFirestore();
          },
          child: Text(
            'Submit',
            style: TextStyle(color: Colors.amberAccent),
          ),
          style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              backgroundColor: Colors.black),
        ),
      ]),
    );
  }

  txtFieldDate(String txt, var icon, TextEditingController control,
      TextInputType typ, context) {
    DateTime selectedTime = DateTime.now();

    return Column(
      children: [
        TextField(
          keyboardType: typ,
          controller: control,
          readOnly: true,
          onTap: () async {
            final DateTime? dateTime = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2025));
            if (dateTime != null) {
              setState(() {
                selectedTime = dateTime;
                control.text = selectedTime.toString();
              });
            }
          },
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(20)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(20)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(20)),
              prefixIcon: Icon(
                icon,
                color: Colors.black,
              ),
              hintText: txt,
              labelText: txt),
          cursorColor: Colors.black,
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}

txtField(
    String txt, var icon, TextEditingController control, TextInputType typ) {
  return Column(
    children: [
      TextField(
        keyboardType: typ,
        controller: control,
        onSubmitted: (value) {
          control.text = value;
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(20)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(20)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(20)),
            prefixIcon: Icon(
              icon,
              color: Colors.black,
            ),
            hintText: txt,
            labelText: txt),
        cursorColor: Colors.black,
      ),
      SizedBox(
        height: 10,
      )
    ],
  );
}
