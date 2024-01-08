import 'package:flutter/material.dart';
// import 'package:List_dio/services/api_services.dart';
// import 'package:List_dio/model/lists_model.dart';
import 'home_page.dart';

class AddDataPage extends StatefulWidget {
  const AddDataPage({Key? key}) : super(key: key);

  @override
  _AddDataPageState createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {
  final _formKey = GlobalKey<FormState>();
  final _judulCtl = TextEditingController();
  final _listCtl = TextEditingController();
  // final ApiServices _dataService = ApiServices();

  @override
  void dispose() {
    _judulCtl.dispose();
    _listCtl.dispose();
    super.dispose();
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
                  onPressed: () async {
                    // if (_formKey.currentState!.validate()) {
                    //   final postModel = ListInput(
                    //     judul: _judulCtl.text,
                    //     list: _listCtl.text,
                    //   );
                    //   await _dataService.postList(postModel);
                    //   Navigator.pop(context); // Kembali ke halaman sebelumnya
                    // }
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
