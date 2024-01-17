import 'package:contact_dio/view/screen/edit_data_page.dart';
import 'package:flutter/material.dart';
import 'package:contact_dio/services/auth_manager.dart';
import 'package:contact_dio/view/screen/login_page.dart';
import 'package:contact_dio/view/screen/showEdit_page.dart';
import 'package:contact_dio/model/lists_model.dart';
import 'package:contact_dio/services/api_services.dart';
// import 'package:contact_dio/view/widget/contact_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
//   @override
//   bool get wantKeepAlive => true;

  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _numberCtl = TextEditingController();
  final String _result = 'Tidak ada data';
  final ApiServices _dataService = ApiServices();
  final List<ListsModel> _listsMdl = [];
  ListResponse? ctRes;
  late SharedPreferences logindata;

  String email = '';
  String token = '';

  @override
  void initState() {
    super.initState();
    inital().then((_) => {
      if(!_listsMdl.isNotEmpty) {
        refreshToDoList(),
      }
    });
  }

  Future<void> inital() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      email = logindata.getString('email').toString();
      token = logindata.getString('token').toString();
    });
  }

  Future<void> refreshToDoList() async {
    final todolist = await _dataService.getAllTodolist(token);
    setState(() {
      if (_listsMdl.isNotEmpty) _listsMdl.clear();
      if (todolist != null) _listsMdl.addAll(todolist);
    });
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _numberCtl.dispose();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do List All'),
        actions: [
          IconButton(
            onPressed: () async {
              _showLogoutConfirmationDialog(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refreshToDoList,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'You\'r List',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: _listsMdl.isEmpty ? Text(_result) : _buildListContact(context),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await refreshToDoList();
                        setState(() {});
                      },
                      child: const Text('Refresh Data'),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
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

  Widget _buildListContact(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        final ctList = _listsMdl[index];
        return Card(
          child: ListTile(
            title: Text(ctList.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ctList.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Due Date: ${DateTime.fromMillisecondsSinceEpoch(ctList.duedate * 1000).toString()}',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () async {
                    // Navigate to ShowPage when edit button is pressed
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditDataPage(judul: ctList.title, list: '',), // Pass data to ShowPage if needed
                      ),
                    );
                    // Handle any callback or refresh logic after returning from ShowPage
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    // Implement your logic for delete button
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
            onTap: () {
              // Navigate to ShowPage when ListTile is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ShowTodolist(data: "dani-daeae-1-12312312",), // Pass data to ShowPage if needed
                ),
              );
              // Handle any callback or refresh logic after returning from ShowPage
            },
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 10.0),
      itemCount: _listsMdl.length,
    );
  }

  dynamic displaySnackbar(String msg) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Anda yakin ingin logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () async {
                await AuthManager.logout();
// ignore: use_build_context_synchronously
                Navigator.pushAndRemoveUntil(
                  dialogContext,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }
}
