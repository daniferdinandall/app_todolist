import 'package:contact_dio/view/screen/login_page.dart';
import 'package:flutter/material.dart';
import 'package:contact_dio/view/screen/add_page.dart';
import 'package:contact_dio/view/screen/edit_data_page.dart';
import 'package:contact_dio/model/lists_model.dart';

class ListCard extends StatefulWidget {
  @override
  _ListCardState createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {
  List<DataItem> dataList = [];

  void onDataAdded(String judul, String list) {
    setState(() {
      dataList.add(DataItem(judul: judul, list: list));
    });
  }

  void onDataEdited(int index, String judul, String list) {
    setState(() {
      dataList[index] = DataItem(judul: judul, list: list);
    });
  }

  void onDismissed(int index) {
    setState(() {
      dataList.removeAt(index);
    });
  }

void onLogout() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Konfirmasi Logout'),
        content: Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Tutup dialog
            },
            child: Text('Tidak'),
          ),
          TextButton(
            onPressed: () {
              // Implement logout logic here
              // For example, you can navigate to the login page
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (BuildContext context) => LoginPage()), // Gantilah dengan halaman login Anda
                (Route<dynamic> route) => false,
              );
            },
            child: Text('Ya'),
          ),
        ],
      );
    },
  );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Card'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              onLogout();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditDataPage(
                    judul: dataList[index].judul,
                    list: dataList[index].list,
                    onDataEdited: (judul, list) {
                      onDataEdited(index, judul, list);
                    },
                  ),
                ),
              );
            },
            child: Card(
              elevation: 2.0,
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDataRow('Judul', dataList[index].judul),
                    _buildDataRow('List', dataList[index].list),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddDataPage(onDataAdded: onDataAdded),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
