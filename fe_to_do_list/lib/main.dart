import 'package:contact_dio/view/screen/add_page.dart';
import 'package:contact_dio/view/screen/login_page.dart';
import 'package:contact_dio/view/screen/register_page.dart';
import 'package:contact_dio/view/widget/list_card.dart';
import 'package:flutter/material.dart';
import 'view/screen/home_page.dart';
import 'package:contact_dio/view/screen/register_page.dart';
import 'package:contact_dio/view/widget/list_card.dart';

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
      home: AddDataPage(), // Ubah halaman awal menjadi LoginPage()
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),
        '/add': (context) => AddDataPage(),
      },
    );
  }
}
