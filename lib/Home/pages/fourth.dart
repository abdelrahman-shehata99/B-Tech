import 'package:btech/Home/widgets/appbar.dart';
import 'package:btech/Home/widgets/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Fourth extends StatefulWidget {
  const Fourth({Key? key}) : super(key: key);

  @override
  _FourthState createState() => _FourthState();
}

final TextEditingController dateController = TextEditingController();
final TextEditingController destinationController = TextEditingController();
final TextEditingController startNumController = TextEditingController();
final TextEditingController endNumController = TextEditingController();
final TextEditingController totalController = TextEditingController();
final TextEditingController representController = TextEditingController();
final TextEditingController carIdController = TextEditingController();
final TextEditingController driverController = TextEditingController();
final TextEditingController lateController = TextEditingController();
final TextEditingController notesController = TextEditingController();
final TextEditingController paperController = TextEditingController();
final TextEditingController productController = TextEditingController();
final TextEditingController branchController = TextEditingController();
final TextEditingController roundController = TextEditingController();
final TextEditingController productNumController = TextEditingController();
final TextEditingController permissionController = TextEditingController();
final TextEditingController uidController = TextEditingController();

class _FourthState extends State<Fourth> {
  @override
  void initState() {
    super.initState();

    // Add listeners to both startNumController and endNumController
    startNumController.addListener(updateTotal);
    endNumController.addListener(updateTotal);
  }

  bool isTextFieldVisible = false;

  void toggleTextFieldVisibility() {
    setState(() {
      isTextFieldVisible = !isTextFieldVisible;
    });
  }

  bool isTextFieldVisiblex = false;

  void toggleTextFieldVisibilityx() {
    setState(() {
      isTextFieldVisiblex = !isTextFieldVisiblex;
    });
  }

  void updateTotal() {
    // Get the values from the startNumController and endNumController
    int startNum = int.tryParse(startNumController.text) ?? 0;
    int endNum = int.tryParse(endNumController.text) ?? 0;

    // Calculate the total
    int total = endNum - startNum;

    // Update the totalController with the calculated value
    totalController.text = total.toString();
    setState(() {
      totalController.text = total.toString();
    });
  }

  void addDataToFirestore() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: userId)
          .get();
      setState(() {
        var data = snapshot.docs.first.data() as Map<String, dynamic>;
        var name = data['name'];
        var car = data['carId'];
        var uid = data['uid'];
        carIdController.text = car;
        uidController.text = uid;
        driverController.text = name;
      });
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('missions');

      Map<String, dynamic> data = {
        'date': dateController.text,
        'destination': destinationController.text,
        'driverLicense': carIdController.text,
        'driverName': driverController.text,
        'represent': representController.text,
        'start': startNumController.text,
        'end': endNumController.text,
        'notes': notesController.text,
        'late': lateController.text,
        'paper': paperController.text,
        'total': totalController.text,
        'branch': branchController.text,
        'permission': permissionController.text,
        'round': roundController.text,
        'product number': productNumController.text,
        'status': 'Not Approved',
        'uid': uidController.text
      };

      // Add the data to Firestore
      await collectionReference.add(data);
      notify(context, 'Congratulations!', 'Item Published');
    } catch (e) {
      print('Error adding data: $e');
    }
  }

  List<String> floor = [
    'الايصالات',
    'بدل عمل 3 نقلات داخلي',
    'بدل عمل 2 نقله خارجي',
    'بدل مبيت',
    'تاجير تروسيكل 30 جنيها',
    'بدل مواصلات محافظات للمندوب'
  ];
  String selectedFloor = 'الايصالات';



  List<String> branch = [
    'اسم الفرع',
    'ميجا اسيوط',
    'اسيوط 2',
    'اسيوط X',
    'ميجا المنيا',
    'ملوي',
    'المنيا X',
    'مخزن طناش',
    'مخزن العاشر',
    'مخزن قنا',
    'اسكندرية',
  ];
  List<String> selectedbranch = [];

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
                      itemCount: branch.length,
                      itemBuilder: (BuildContext context, int index) {
                        final choice = branch[index];
                        return CheckboxListTile(
                          title: Text(choice),
                          value: selectedbranch.contains(choice),
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                selectedbranch.add(choice);
                                branchController.text =
                                    selectedbranch.join(", ");
                              } else {
                                selectedbranch.remove(choice);
                                branchController.text =
                                    selectedbranch.join(", ");
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
          controller: branchController,
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
              hintText: branchController.text,
              labelText: 'TO',
              alignLabelWithHint: true),
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
        SizedBox(
          height: 20,
        ),
        txtFieldDate('التاريخ', Icons.date_range, dateController,
            TextInputType.datetime, context),
        SizedBox(
          height: 20,
        ),txtField('اسم المندوب', Icons.onetwothree, representController,
            TextInputType.text),
        SizedBox(
          height: 10,
        ),
        Text(
          'نوع التشغيل',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold),
        ),
        toggle(),
        txtField('عداد البداية', Icons.onetwothree, startNumController,
            TextInputType.number),
        SizedBox(
          height: 20,
        ),
        txtField(
          'عداد النهاية',
          Icons.onetwothree_outlined,
          endNumController,
          TextInputType.number,
        ),
        SizedBox(
          height: 20,
        ),
        txtField(
          'المجموع',
          Icons.onetwothree_outlined,
          totalController,
          TextInputType.number,
        ),
        SizedBox(
          height: 20,
        ),
        txtField('نهاية الرحلة', Icons.map, destinationController,
            TextInputType.text),
        SizedBox(
          height: 20,
        ),
        txtFieldDay('التاخير', Icons.timelapse, lateController,
            TextInputType.datetime, context),
        SizedBox(
          height: 20,
        ),
        txtField('ملاحظات', Icons.note, notesController, TextInputType.text),
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
                paperController.text = selectedFloor;
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

  toggle() {
    return Row(
      children: <Widget>[
        SizedBox(
          height: 60,
        ),
        Expanded(
          child: Column(
            children: [
              ElevatedButton(
                child: Text(
                  'الفرع',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    backgroundColor: Colors.black),
                onPressed: toggleTextFieldVisibility,
              ),
              Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Visibility(
                      visible: isTextFieldVisible,
                      child: txtFieldCheck(Icons.shop)),
                  Visibility(
                    visible: isTextFieldVisible,
                    child: txtField(
                      'رقم الاذن',
                      Icons.accessibility,
                      permissionController,
                      TextInputType.number,
                    ),
                  ),
                  Visibility(
                    visible: isTextFieldVisible,
                    child: txtField(
                      'عدد البضاعة',
                      Icons.onetwothree_outlined,
                      productNumController,
                      TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              ElevatedButton(
                child: Text(
                  'اونلاين',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    backgroundColor: Colors.black),
                onPressed: toggleTextFieldVisibilityx,
              ),
              SizedBox(
                height: 10,
              ),
              Visibility(
                visible: isTextFieldVisiblex,
                child: txtField(
                  'رقم الجولة',
                  Icons.onetwothree_outlined,
                  roundController,
                  TextInputType.number,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 100,
        )
      ],
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

  txtFieldDay(String txt, var icon, TextEditingController control,
      TextInputType typ, context) {
    TimeOfDay selectedDay = TimeOfDay(hour: 0, minute: 0);

    return Column(
      children: [
        TextField(
          keyboardType: typ,
          controller: control,
          readOnly: true,
          onTap: () async {
            final TimeOfDay? dayTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (dayTime != null) {
              setState(() {
                selectedDay = dayTime;
                control.text = selectedDay.format(context).toString();
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
