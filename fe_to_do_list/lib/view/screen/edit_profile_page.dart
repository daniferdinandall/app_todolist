import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _image;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? Icon(Icons.person, size: 50, color: Colors.white)
                      : null,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Nama"),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _phoneNumberController,
                decoration: InputDecoration(labelText: "Nomor HP"),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _saveChanges();
                      Navigator.of(context).pop(true); // Returning true after saving changes
                    },
                    child: Text("Simpan"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(false); // Returning false if changes are not saved
                    },
                    child: Text("Batal"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _saveChanges() {
    // Implement saving data to storage or server
    // You can use _nameController.text, _phoneNumberController.text, etc.
    // Also, save the image path if an image is selected.
    // For simplicity, I'm just printing the values for now.
    print("Name: ${_nameController.text}");
    print("Phone Number: ${_phoneNumberController.text}");
    print("Email: ${_emailController.text}");
    if (_image != null) print("Image Path: ${_image!.path}");

    // Add logic to save data to storage or server here
  }
}
