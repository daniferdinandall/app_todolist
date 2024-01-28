// ignore_for_file: use_build_context_synchronously, prefer_final_fields

import 'package:contact_dio/model/profile_model.dart';
import 'package:contact_dio/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late SharedPreferences logindata;

  // final _formKey = GlobalKey<FormState>();
  final ApiServices _dataService = ApiServices();

  ProfileModel _profileMdl = ProfileModel(
    id: 'loading',
    name: 'loading',
    phoneNumber: 'loading',
    email: 'loading',
    base64url: '',
  );

  String email = '';
  String token = '';
  bool isLoading = true;

  @override
  initState() {
    super.initState();

    inital().then((_) => {
          if (_profileMdl.id.isNotEmpty)
            {
              refreshProfile(),
            }
        });
  }

  Future<void> refreshProfile() async {
    isLoading = true;
    final profil = await _dataService.getProfil();
    setState(() {
      if (profil != null) {
        _profileMdl = profil;
      }
    });
    isLoading = false;
  }

  Future<void> inital() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      email = logindata.getString('email').toString();
      token = logindata.getString('token').toString();
    });
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
  return Scaffold(
    appBar: AppBar(
      title: const Text("Profile"),
    ),
    body: Center(
      child: isLoading
          ? const CircularProgressIndicator()
          : SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                padding: const EdgeInsets.all(40.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                    ),
                  ],
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    
                    CircleAvatar(
                      radius: 90,
                      backgroundImage: NetworkImage(
                              _profileMdl.base64url,
                            ),
                    ),
                    const SizedBox(height: 64),
                    Text("Nama: ${_profileMdl.name != '' ? _profileMdl.name : "s"}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text("Nomor HP: ${_profileMdl.phoneNumber != '' ? _profileMdl.phoneNumber : "s"}", style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text("Email: ${_profileMdl.email != '' ? _profileMdl.email : "s"}", style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditProfilePage(
                            data: "${_profileMdl.name}-${_profileMdl.phoneNumber}-${_profileMdl.email}-${_profileMdl.base64url}",
                          )),
                        ).then((value) {
                          // Callback after returning from EditProfilePage
                          if (value == true) {
                            // Implement any logic you want after saving changes
                            // ignore: avoid_print
                            print("Changes saved successfully!");
                            // You might want to refresh the profile here if needed
                            refreshProfile();
                          }
                        });
                      },
                      child: const Text("Edit"),
                    ),
                  ],
                ),
              ),
            ),
    ),
  );
}

}
