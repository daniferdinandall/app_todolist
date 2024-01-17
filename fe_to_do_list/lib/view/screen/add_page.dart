// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

typedef OnDataAddedCallback = void Function(String judul, String list);

class AddDataPage extends StatefulWidget {
  final OnDataAddedCallback? onDataAdded;

  const AddDataPage({Key? key, this.onDataAdded}) : super(key: key);

  @override
  _AddDataPageState createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {
  List<String> addedData = [];

  final _formKey = GlobalKey<FormState>();
  final _judulCtl = TextEditingController();
  final _descCtl = TextEditingController();
  final _priorityCtl = TextEditingController();

  String selectedValue = 'Priority  1';
  List<String> options = ['Priority  1', 'Priority  2', 'Priority  3'];

  DateTime _dueDateTime = DateTime.now();
  final currentDate = DateTime.now();
  
  @override
  void initState() {
    super.initState();
    List parts = selectedValue.split(' ');
    _priorityCtl.text = selectedValue;
    debugPrint("Init state is called.");
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
              TextFormField(
                controller: _judulCtl,
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // widget.onDataAdded?.call(_judulCtl.text, _descCtl.text);
                      // Navigator.pop(context); // Go back to the previous page
                      widget.onDataAdded?.call(_judulCtl.text, _descCtl.text);
                      addedData.add("${_judulCtl.text} - ${_descCtl.text} - ${_priorityCtl.text} - ${_dueDateTime.toString()}");
                      _clearForm();
                    }
                  },
                  child: const Text('Tambah Data'),
                ),
              ),
              const SizedBox(height: 20.0),
              // Tampilkan data yang ditambahkan di bawah tombol
              Text(
                'Data yang Ditambahkan:',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: addedData.map((data) => Text(data)).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _clearForm() {
    _judulCtl.clear();
    _descCtl.clear();
    _priorityCtl.clear();
    setState(() {
      selectedValue = 'Priority  1';
      _dueDateTime = DateTime.now();
    });
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
                  lastDate: DateTime(currentDate.year + 5),
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
}
