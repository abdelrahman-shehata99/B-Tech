import 'package:flutter/material.dart';
import 'package:get/get.dart';


  Fun(BuildContext contex,var fun) {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: Colors.black,
      child: IconButton(
        onPressed: () {
          Get.to(fun);
        },
        icon: Icon(Icons.add),
      ),
    );
  }
