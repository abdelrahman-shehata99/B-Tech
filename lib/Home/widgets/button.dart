import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';

btnTo(BuildContext context, Function function, String text, double radi,
    Color color) {
  return  ElevatedButton(
      onPressed: () {
        function();
      },
      child: Text(
        text,
        style: TextStyle(color: color),
      ),
      style: ElevatedButton.styleFrom(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(radi)),
          backgroundColor: Colors.black),
    
  );
}

btn(BuildContext context, String text, double radi, Color color) {
  return  ElevatedButton(
      child: Text(
        text,
        style: TextStyle(color: color),
      ),
      style: ElevatedButton.styleFrom(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(radi)),
          backgroundColor: Colors.black),
      onPressed: () {},
    
  );
}

animBtn(Function function, String txt, Color clr) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      GestureDetector(
        onTap: () {
          function();
        },
        child: Container(
          height: 70,
          width: 300,
          child: Center(
            child: Text(
              txt,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          decoration: BoxDecoration(
            color: clr,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
        ),
      )
    ],
  );
}

notify(dynamic context, String txt, String txt2) {
  return ElegantNotification.success(
    width: 360,
    notificationPosition: NotificationPosition.topLeft,
    animation: AnimationType.fromTop,
    title: Text(txt),
    description: Text(txt2),
    onDismiss: () {},
  ).show(context);
}

notifyE(context) {
  return ElegantNotification.error(
          width: 360,
          title: Text("Deleted"),
          description: Text("Driver Deleted Successfully"))
      .show(context);
}
