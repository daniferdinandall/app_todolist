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
  final _formKey = GlobalKey<FormState>();
  final ApiServices _dataService = ApiServices();
  List<ListsModel> _listsMdl = [];
  final List<ListsModel> _baseListsMdl = [];
  late SharedPreferences logindata;

  String dueDateUpIcon = "netral"; //netral, up, down
  String createdAtIcon = "down"; //netral, up, down
  TodolistResponse? ctRes;

  String email = '';
  String token = '';

  bool isLoading = false;

  String selectedValue = 'All';
  List<String> options = ['All', 'No 1', 'No 2', 'No 3'];

  @override
  void initState() {
    super.initState();

    inital().then((_) => {
          if (!_listsMdl.isNotEmpty) {refreshToDoList()}
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
    isLoading = true;
    final todolist = await _dataService.getAllTodolist();
    setState(() {
      if (_listsMdl.isNotEmpty) {
        _listsMdl.clear();
        _baseListsMdl.clear();
      }

      if (todolist != null) {
        _listsMdl.addAll(todolist);
        _baseListsMdl.addAll(todolist);
      }
    });
    isLoading = false;
  }

  Future<void> sortByDueDate() async {
    isLoading = true;
    if (_listsMdl.isNotEmpty) {
      if (dueDateUpIcon == "up") {
        _listsMdl.sort((a, b) => b.duedate.compareTo(a.duedate));
      } else if (dueDateUpIcon == "down") {
        _listsMdl.sort((a, b) => a.duedate.compareTo(b.duedate));
      }
    }
    isLoading = false;
  }

  Future<void> sortByCreatedAt() async {
    isLoading = true;
    if (_listsMdl.isNotEmpty) {
      if (createdAtIcon == "up") {
        _listsMdl.sort((a, b) => b.createdat.compareTo(a.createdat));
      } else if (createdAtIcon == "down") {
        _listsMdl.sort((a, b) => a.createdat.compareTo(b.createdat));
      }
    }
    isLoading = false;
  }

  Future<void> filterByPriority() async {
    isLoading = true;
    if (_listsMdl.isNotEmpty) {
      if (selectedValue == "No 1") {
        _listsMdl =
            _baseListsMdl.where((element) => element.priority == 1).toList();
      } else if (selectedValue == "No 2") {
        _listsMdl =
            _baseListsMdl.where((element) => element.priority == 2).toList();
      } else if (selectedValue == "No 3") {
        _listsMdl =
            _baseListsMdl.where((element) => element.priority == 3).toList();
      } else {
        _listsMdl = _baseListsMdl;
      }
    }
    isLoading = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
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
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Text(
                              'Priority:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: DropdownButton<String>(
                              value: selectedValue,
                              onChanged: (String? newValue) {
                                // Handle dropdown value change
                                setState(() {
                                  selectedValue = newValue!;
                                  filterByPriority();
                                });
                              },
                              items: options.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Text(
                              'Due Date:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // Handle button tap, misalnya, perubahan ikon atau aksi lainnya
                              setState(() {
                                dueDateUpIcon == "netral"
                                    ? dueDateUpIcon = "up"
                                    : dueDateUpIcon == "up"
                                        ? dueDateUpIcon = "down"
                                        : dueDateUpIcon = "up";
                                // dueDateUpIcon = !dueDateUpIcon;
                                sortByDueDate();
                                createdAtIcon = "netral";
                              });
                              print('Button tapped!');
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                dueDateUpIcon == "netral"
                                    ? Icons.sort
                                    : dueDateUpIcon == "up"
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Text(
                              'Created At:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // Handle button tap, misalnya, perubahan ikon atau aksi lainnya
                              setState(() {
                                createdAtIcon == "netral"
                                    ? createdAtIcon = "up"
                                    : createdAtIcon == "up"
                                        ? createdAtIcon = "down"
                                        : createdAtIcon = "up";
                                // createdAtIcon = !createdAtIcon;
                                sortByCreatedAt();
                                dueDateUpIcon = "netral";
                              });
                              print('Button tapped!');
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                createdAtIcon == "netral"
                                    ? Icons.sort
                                    : createdAtIcon == "up"
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: _listsMdl.isEmpty
                      ? (isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : const Text("Tidak Ada Data"))
                      : _buildListTodolist(context),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: FloatingActionButton(
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      
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
                Text(
                  'Created At: ${DateTime.fromMillisecondsSinceEpoch(ctList.createdat * 1000).toString()}',
                  style: const TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 20.0,
                  height: 20.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ctList.priority == 1
                        ? Colors.red
                        : ctList.priority == 2
                            ? Colors.yellow
                            : Colors.blue,
                  ),
                  child: Center(
                    child: Icon(
                      (ctList.priority == 1)
                          ? Icons.priority_high_rounded
                          : (ctList.priority == 2)
                              ? Icons.warning_rounded
                              : Icons.info_rounded,
                      color: Colors.white,
                      size: 14.0,
                    ),
                  ),
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
                  builder: (context) => ShowTodolist(
                    idTodolist: ctList.id,
                    data:
                        "${ctList.title}-${ctList.description}-${ctList.priority}-${ctList.duedate}",
                  ), // Pass data to ShowPage if needed
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
                TodolistResponse? res = await _dataService.deleteTodolist(id);
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
