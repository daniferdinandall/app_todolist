// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:contact_dio/model/lists_model.dart';
import 'package:contact_dio/navbar.dart';
import 'package:contact_dio/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowTodolist extends StatefulWidget {
  final String idTodolist;
  final String data;

  const ShowTodolist({Key? key, required this.data, required this.idTodolist}) : super(key: key);

  @override
  _ShowTodolistState createState() => _ShowTodolistState();
}

class _ShowTodolistState extends State<ShowTodolist> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtl = TextEditingController();
  final _descCtl = TextEditingController();
  final _priorityCtl = TextEditingController();

  String selectedValue = 'Priority 1';
  List<String> options = ['Priority 1', 'Priority 2', 'Priority 3'];

  DateTime _dueDateTime = DateTime.now();
  final currentDate = DateTime.now();
  DateTime selectedDate = DateTime.now();

  final ApiServices _dataService = ApiServices();
  
  late SharedPreferences logindata;
  String token = '';
  @override
  void initState() {
    super.initState();
    // Parsing data yang diterima untuk mendapatkan judul, deskripsi, prioritas, dan due date
    List<String> parts = widget.data.split('-');
    inital();
    _titleCtl.text = parts[0];
    _descCtl.text = parts[1];
    _priorityCtl.text = parts[2];
    selectedValue = "Priority ${parts[2]}";
    _dueDateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(parts[3]) * 1000);
    selectedDate = DateTime.parse(parts[3]);
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
        title: const Text('Detail Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                                Text("edit..."),
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
                        TodolistResponse? res = await _dataService.putTodolist(postModel,widget.idTodolist);
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
                  child: const Text('Save Data'),
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
                  initialDate: _dueDateTime,
                  firstDate: currentDate,
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
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
