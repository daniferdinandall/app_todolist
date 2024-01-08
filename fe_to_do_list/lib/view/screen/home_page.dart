import 'package:contact_dio/services/auth_manager.dart';
import 'package:contact_dio/view/screen/login_page.dart';
import 'package:flutter/material.dart';
import 'package:contact_dio/model/lists_model.dart';
import 'package:contact_dio/services/api_services.dart';
import 'package:contact_dio/view/widget/contact_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _numberCtl = TextEditingController();
  String _result = '-';
  // final ApiServices _dataService = ApiServices();
  // List<ContactsModel> _contactMdl = [];
  // ContactResponse? ctRes;
  bool isEdit = false;
  String idContact = '';
  String token = '';

  @override
  void dispose() {
    _nameCtl.dispose();
    _numberCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do List All'),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               const SizedBox(height: 8.0),
              const Text(
                'You\'r List',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(height: 8.0),
              // Expanded(
              //   child:
              //       _contactMdl.isEmpty ? Text(_result) : _buildListContact(),
              // ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {  Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddDataPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  dynamic displaySnackbar(String msg) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  // Future<void> refreshContactList() async {
  //   final users = await _dataService.getAllContact();
  //   setState(() {
  //     if (_contactMdl.isNotEmpty) _contactMdl.clear();
  //     if (users != null) _contactMdl.addAll(users);
  //   });
  // }

  // Widget hasilCard(BuildContext context) {
  //   return Column(children: [
  //     if (ctRes != null)
  //       ContactCard(
  //         ctRes: ctRes!,
  //         onDismissed: () {
  //           setState(() {
  //             ctRes = null;
  //           });
  //         },
  //       )
  //     else
  //       const Text(''),
  //   ]);
  // }

 
}
