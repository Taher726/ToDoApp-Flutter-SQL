import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todoapp_sql/pages/add_task.dart';
import 'package:todoapp_sql/pages/home_page.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
    routes: {
      "addtask": (context) => AddTask(),
    },
  ));
}