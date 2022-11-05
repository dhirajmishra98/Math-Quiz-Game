import 'package:flutter/material.dart';

Container bMixScreenButton(String buttonName) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 20.0),
    decoration: BoxDecoration(
      color: Color(0xFF246EE9),
      borderRadius: BorderRadius.circular(50.0),
    ),
    width: double.infinity,
    child: Center(
      child: Text(
        buttonName,
        style: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  );
}

Widget bHomeOptionButton(String screen){
  return ClipRRect(
    borderRadius: BorderRadius.circular(15.0),
    child: Container(
        padding: EdgeInsets.all(20.0),
        color: Color(0xFF246EE9),
        height: 80.0,
        child: Image(
          image: AssetImage(screen),
          color: Colors.white,
          fit: BoxFit.fill,
        )
    ),
  );
}

Widget bHeartOptionButton(String screen){
  return ClipOval(
    child: Container(
        // padding: EdgeInsets.all(5.0),
        height: 60.0,
        child: Image(
          image: AssetImage(screen),
          color: Colors.red,
          fit: BoxFit.fill,
        )
    ),
  );
}

final cBoxDecoration = BoxDecoration(
  color: Colors.lightBlueAccent,
  borderRadius: BorderRadius.circular(20.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black26,
      offset: const Offset(
        5.0,
        5.0,
      ),
      blurRadius: 2.0,
      spreadRadius: 2.0,
    ),
  ],
);

