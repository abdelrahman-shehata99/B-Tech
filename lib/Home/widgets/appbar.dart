import 'package:flutter/material.dart';

appBar(String txt, BuildContext context) {
  return AppBar(
    title: Column(
      children: [
        Text(
          'B.TECH',
          style:
              TextStyle(fontSize: 20, color: Color.fromARGB(255, 0, 155, 117)),
        ),
        Text(
          txt,
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
  );
}

appBarS(String txt) {
  return AppBar(
    title: Column(children: [
      Text(
        'B.TECH',
        style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 0, 155, 117)),
      ),
      Text(
        txt,
        style:
            TextStyle(fontSize: 10, color: Colors.white, fontFamily: 'Indie'),
      )
    ]),
    centerTitle: true,
    backgroundColor: Colors.black,
  );
}
