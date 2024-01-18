// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:contact_dio/model/lists_model.dart';
import 'package:contact_dio/navbar.dart';
import 'package:contact_dio/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:intl/intl.dart';

class AddDataPage extends StatefulWidget {
  const AddDataPage({Key? key }) : super(key: key);

  @override
  _AddDataPageState createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {
  List<String> addedData = [];

  final _formKey = GlobalKey<FormState>();
  final _titleCtl = TextEditingController();
  final _descCtl = TextEditingController();
  final _priorityCtl = TextEditingController();
  
  final ApiServices _dataService = ApiServices();

  String selectedValue = 'Priority 1';
  List<String> options = ['Priority 1', 'Priority 2', 'Priority 3'];

  DateTime _dueDateTime = DateTime.now();
  final currentDate = DateTime.now();

  late SharedPreferences logindata;
  String token = '';
  @override
  void initState() {
    super.initState();
    inital();
    List parts = selectedValue.split(' ');
    _priorityCtl.text = parts[1];
    debugPrint("Init state is called.");
  }
  Future<void> inital() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      token = logindata.getString('token').toString();
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("token=$token"),
              TextFormField(
                controller: _titleCtl,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  return null;
                },
              ),
              buildDateTimePicker(context),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Choose Priority:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Spacer(),
                  const SizedBox(width: 10.0),
                  DropdownButton<String>(
                    value: selectedValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValue = newValue!;
                        List<String> parts = selectedValue.split(' ');
                        _priorityCtl.text = parts[1];
                      });
                    },
                    items:
                        options.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      );
                    }).toList(),
                    icon: const Icon(Icons.arrow_drop_down,
                        size: 30.0, color: Colors.blue),
                    underline: Container(
                      height: 2,
                      color: Colors.blue,
                    ),
                    elevation: 16,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _descCtl,
                decoration: const InputDecoration(
                  hintText: 'Description',
                ),
                maxLines: null, // Set to null for multiline input
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: ()async {
                    final isValidForm = _formKey.currentState!.validate();
                    if (isValidForm) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const AlertDialog(
                            content: Row(
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(width: 16.0),
                                Text("adding..."),
                              ],
                            ),
                          );
                        },
                        barrierDismissible: false,
                      );

                      final postModel = ListInput(
                        title: _titleCtl.text,
                        description: _descCtl.text,
                        priority: int.parse(_priorityCtl.text),
                        duedate: _dueDateTime.millisecondsSinceEpoch ~/ 1000,
                      );
                      try {
                        TodolistResponse? res = await _dataService.postTodolist(postModel,token);
                        Navigator.pop(context);
                        if (res.status == true) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const BottomNavBar(),
                                ),
                                (route) => false,
                              );
                            } else {
                              displaySnackbar(res.message);
                            }
                      } catch (e) {
                        Navigator.pop(context);
                        displaySnackbar("An error occurred while logging in.");
                      }
                    }
                  },
                  child: const Text('Tambah Data'),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDateTimePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Due Date'),
            TextButton(
              child: const Text('Select'),
              onPressed: () async {
                final selectDate = await showDatePicker(
                  context: context,
                  initialDate: currentDate,
                  firstDate: DateTime(1990),
                  lastDate: DateTime(currentDate.year + 10),
                );

                if (selectDate != null) {
                  final selectTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_dueDateTime),
                  );

                  if (selectTime != null) {
                    setState(() {
                      _dueDateTime = DateTime(
                        selectDate.year,
                        selectDate.month,
                        selectDate.day,
                        selectTime.hour,
                        selectTime.minute,
                      );
                    });
                  }
                }
              },
            ),
          ],
        ),
        Text(DateFormat('dd-MM-yyyy HH:mm').format(_dueDateTime)),
      ],
    );
  }
  dynamic displaySnackbar(String msg) {
  return ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(msg)));
  }
}
