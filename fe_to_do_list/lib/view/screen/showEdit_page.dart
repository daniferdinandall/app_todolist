import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShowTodolist extends StatefulWidget {
  final String data;

  const ShowTodolist({Key? key, required this.data}) : super(key: key);

  @override
  _ShowTodolistState createState() => _ShowTodolistState();
}

class _ShowTodolistState extends State<ShowTodolist> {
  TextEditingController _judulCtl = TextEditingController();
  TextEditingController _descCtl = TextEditingController();
  TextEditingController _priorityCtl = TextEditingController();
  DateTime _dueDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Parsing data yang diterima untuk mendapatkan judul, deskripsi, prioritas, dan due date
    List<String> parts = widget.data.split('-');
    _judulCtl.text = parts[0];
    _descCtl.text = parts[1];
    _priorityCtl.text = parts[2];
    _dueDateTime = DateTime.parse(parts[3]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Show/Edit Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _judulCtl,
              decoration: const InputDecoration(labelText: 'Title'),
              readOnly: true, // Judul tidak dapat diedit
            ),
            const SizedBox(height: 16.0),
            buildDateTimePicker(context),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descCtl,
              decoration: const InputDecoration(
                hintText: 'Description',
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _priorityCtl,
              decoration: const InputDecoration(
                labelText: 'Priority',
              ),
              readOnly: true, // Prioritas tidak dapat diedit
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Implement logic for updating the data here
                  // For example, you can send an API request to update the data
                  // and then navigate back to the previous page
                  Navigator.pop(context);
                },
                child: const Text('Simpan Perubahan'),
              ),
            ),
          ],
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
            Text(
              DateFormat('dd-MM-yyyy HH:mm').format(_dueDateTime),
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ],
    );
  }
}
