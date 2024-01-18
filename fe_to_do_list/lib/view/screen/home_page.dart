// ignore_for_file: use_build_context_synchronously

// import 'package:contact_dio/navbar.dart';
import 'package:flutter/material.dart';
import 'package:contact_dio/services/auth_manager.dart';
import 'package:contact_dio/view/screen/login_page.dart';
import 'package:contact_dio/view/screen/show_edit_page.dart';
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
  final ApiServices _dataService = ApiServices();
  final List<ListsModel> _listsMdl = [];
  late SharedPreferences logindata;

  

  TodolistResponse? ctRes;
  
  String email = '';
  String token = '';

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    checkLogin().then((_)=>{
      inital().then((_) => {
        if(!_listsMdl.isNotEmpty) {
          refreshToDoList(),
        }
      })
    });
  }

  checkLogin() async {
    bool isLoggedIn = await AuthManager.isLoggedIn();
    if (!isLoggedIn) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
        (route) => false,
      );
    }
  }

  Future<void> inital() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      email = logindata.getString('email').toString();
      token = logindata.getString('token').toString();
    });
  }

  Future<void> refreshToDoList() async {
    isLoading = true;
    final todolist = await _dataService.getAllTodolist(token);
    setState(() {
      if (_listsMdl.isNotEmpty) _listsMdl.clear();
      if (todolist != null) _listsMdl.addAll(todolist);
    });
    isLoading = false;
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
                Text("token=$token"),
                const Text(
                  'You\'r List',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: _listsMdl.isEmpty ? (isLoading? const Center(child: CircularProgressIndicator()):const Text("Tidak Ada Data")) : _buildListTodolist(context),
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
  Widget _buildListTodolist(BuildContext context) {
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
                    // Handle any callback or refresh logic after returning from ShowPage
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    // Implement your logic for delete button
                    _showDeleteConfirmationDialog(ctList.id, ctList.title);
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
                  builder: (context) => ShowTodolist(idTodolist: ctList.id,data: "${ctList.title}-${ctList.description}-${ctList.priority}-${ctList.duedate}",), // Pass data to ShowPage if needed
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

  void _showDeleteConfirmationDialog(String id, String nama) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus data $nama ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () async {
                TodolistResponse? res = await _dataService.deleteTodolist(id, token);
                setState(() {
                  ctRes = res;
                });
                Navigator.of(context).pop();
                await refreshToDoList();
              },
              child: const Text('DELETE'),
            ),
          ],
        );
      },
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
