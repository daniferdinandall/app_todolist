import 'package:flutter/material.dart';

typedef OnDataAddedCallback = void Function(String judul, String list);

class AddDataPage extends StatefulWidget {
  final OnDataAddedCallback? onDataAdded;

  const AddDataPage({Key? key, this.onDataAdded}) : super(key: key);

  @override
  _AddDataPageState createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {
  final _formKey = GlobalKey<FormState>();
  final _judulCtl = TextEditingController();
  final _listCtl = TextEditingController();

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
                decoration: const InputDecoration(labelText: 'Judul'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _listCtl,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(labelText: 'List'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'List tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onDataAdded?.call(_judulCtl.text, _listCtl.text);
                      Navigator.pop(context); // Go back to the previous page
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
}
