import 'package:flutter/material.dart';

typedef OnDataEditedCallback = void Function(String judul, String list);
typedef OnDataDeletedCallback = void Function();

class EditDataPage extends StatefulWidget {
  final String judul;
  final String list;
  final OnDataEditedCallback? onDataEdited;
  final OnDataDeletedCallback? onDataDeleted;

  const EditDataPage({
    Key? key,
    required this.judul,
    required this.list,
    this.onDataEdited,
    this.onDataDeleted,
  }) : super(key: key);

  @override
  _EditDataPageState createState() => _EditDataPageState();
}

class _EditDataPageState extends State<EditDataPage> {
  late TextEditingController _judulCtl;
  late TextEditingController _listCtl;

  @override
  void initState() {
    super.initState();
    _judulCtl = TextEditingController(text: widget.judul);
    _listCtl = TextEditingController(text: widget.list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Data'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Show a confirmation dialog before deleting the data
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Konfirmasi Delete'),
                    content: Text('Apakah Anda yakin ingin menghapus data ini?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text('Tidak'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Call the onDataDeleted callback
                          widget.onDataDeleted?.call();
                          Navigator.pop(context); // Close the dialog
                          Navigator.pop(context); // Go back to the previous page
                        },
                        child: Text('Ya'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _judulCtl,
              decoration: const InputDecoration(labelText: 'Judul'),
            ),
            TextFormField(
              controller: _listCtl,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(labelText: 'List'),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Call the onDataEdited callback with the updated data
                  widget.onDataEdited?.call(_judulCtl.text, _listCtl.text);
                  Navigator.pop(context); // Go back to the previous page
                },
                child: const Text('Edit Data'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
