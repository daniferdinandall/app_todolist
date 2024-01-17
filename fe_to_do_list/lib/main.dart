import 'package:contact_dio/view/screen/add_page.dart';
import 'package:contact_dio/view/screen/login_page.dart';
import 'package:contact_dio/navbar.dart';
import 'package:contact_dio/view/screen/register_page.dart';
import 'package:flutter/material.dart';
import 'view/screen/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const LoginPage(), // Ubah halaman awal menjadi LoginPage()
    );
  }
}
