// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:io';
import 'package:contact_dio/model/profile_model.dart';
import 'package:contact_dio/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  final String data;

  const EditProfilePage({Key? key, required this.data}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _image;
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _imgController = TextEditingController();

  final String _nameOld = '';
  final String _phoneNumberOld = '';

  final _formKey = GlobalKey<FormState>();

  final ApiServices _dataService = ApiServices();

  @override
  void initState() {
    super.initState();
    List<String> parts = widget.data.split('-');
    _nameController.text = parts[0];
    _phoneNumberController.text = parts[1];
    _emailController.text = parts[2];
    _imgController.text = parts[3];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 46),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: const Icon(Icons.photo),
                              title: const Text('Ambil dari Galeri'),
                              onTap: () {
                                Navigator.pop(context);
                                _pickImage();
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.camera),
                              title: const Text('Ambil dari Kamera'),
                              onTap: () {
                                Navigator.pop(context);
                                _pickImageFromCamera();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 90,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : NetworkImage(_imgController.text)
                            as ImageProvider<Object>?,
                  ),
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: "Nama"),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneNumberController,
                        decoration:
                            const InputDecoration(labelText: "Nomor HP"),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: "Email"),
                        enabled: false,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              final isValidForm =
                                  _formKey.currentState!.validate();

                              if (isValidForm) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const AlertDialog(
                                      content: Row(
                                        children: [
                                          CircularProgressIndicator(),
                                          SizedBox(width: 16.0),
                                          Text("editing..."),
                                        ],
                                      ),
                                    );
                                  },
                                  barrierDismissible: false,
                                );
                                final postModel = ProfileInput(
                                  name: _nameController.text,
                                  phoneNumber: _phoneNumberController.text,
                                  // base64url: _imgController.text,
                                );
                                Map<String, dynamic> postData = {
                                  'image': _image != null
                                      ? _image!
                                      : _imgController.text,
                                };
                                try {
                                  bool status = false;
                                  String message = '';
                                  if (_nameController.text != _nameOld ||
                                      _phoneNumberController.text !=
                                          _phoneNumberOld) {
                                    ProfileResponse? res = await _dataService
                                        .putProfile(postModel);

                                    if (res.status == true) {
                                      status = true;
                                      message = res.message;
                                    }
                                  }
                                  // kirim photo
                                  if (_image != null) {
                                    ProfileResponse? resImg = await _dataService
                                        .putImage(image: postData['image']);

                                    if (resImg!.status == true) {
                                      status = true;
                                      message = '$message\n${resImg.message}';
                                    }
                                  }

                                  Navigator.pop(context);

                                  if (status) {
                                    Navigator.of(context).pop(true);
                                  } else {
                                    displaySnackbar(message);
                                  }
                                } catch (e) {
                                  Navigator.pop(context);
                                  displaySnackbar(
                                      "An error occurred while logging in.");
                                }
                              }
                              // Returning true after saving changes
                            },
                            child: const Text("Simpan"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(
                                  false); // Returning false if changes are not saved
                            },
                            child: const Text("Batal"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  void _pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  dynamic displaySnackbar(String msg) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}
