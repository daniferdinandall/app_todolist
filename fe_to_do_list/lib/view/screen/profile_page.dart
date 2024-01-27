import 'package:flutter/material.dart';
import 'edit_profile_page.dart';

void main() {
  runApp(MaterialApp(
    home: ProfilePage(),
  ));
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/default_avatar.png'),
              ),
              SizedBox(height: 16),
              Text("Nama: John Doe"),
              SizedBox(height: 8),
              Text("Nomor HP: 1234567890"),
              SizedBox(height: 8),
              Text("Email: john.doe@example.com"),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfilePage()),
                  ).then((value) {
                    // Callback after returning from EditProfilePage
                    if (value == true) {
                      // Implement any logic you want after saving changes
                      print("Changes saved successfully!");
                    }
                  });
                },
                child: Text("Edit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
