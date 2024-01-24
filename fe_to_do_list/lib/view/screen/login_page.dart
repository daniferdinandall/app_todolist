// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:contact_dio/model/login_model.dart';
import 'package:contact_dio/navbar.dart';
import 'package:contact_dio/services/api_services.dart';
import 'package:contact_dio/services/auth_manager.dart';
import 'package:contact_dio/view/screen/register_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final ApiServices _dataService = ApiServices();

  @override
  void initState() {
    super.initState();
    debugPrint("Init state is called.");
    checkLogin();
    _passwordController.text = "12345678";
    _emailController.text = "dani@mail.com";
  }

  void checkLogin() async {
    bool isLoggedIn = await AuthManager.isLoggedIn();
    if (isLoggedIn) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const BottomNavBar(),
        ),
        (route) => false,
      );
    }
  }

  String? _validateEmail(String? value) {
    if (value != null && value.length < 4) {
      return 'Masukkan minimal 4 karakter';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value != null && value.length < 3) {
      return 'Masukkan minimal 3 karakter';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login Page'),
          backgroundColor: const Color.fromARGB(255, 134, 31, 126),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 250,
                    child: Image.asset(
                      'images/logo.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Welcome Back to ToDo List App',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: _validateEmail,
                      controller: _emailController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.account_circle_rounded),
                        hintText: 'Write email here...',
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        fillColor: Color.fromARGB(255, 242, 254, 255),
                        filled: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      obscureText: true,
                      controller: _passwordController,
                      validator: _validatePassword,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.password_rounded),
                        hintText: 'Write your password here...',
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        fillColor: Color.fromARGB(255, 242, 254, 255),
                        filled: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      obscureText: true,
                      controller: _confirmPasswordController,
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Konfirmasi password tidak sesuai';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.password_rounded),
                        hintText: 'Repeat your password here...',
                        labelText: 'Confirm Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        fillColor: Color.fromARGB(255, 242, 254, 255),
                        filled: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        final isValidForm = _formKey.currentState!.validate();
                        if (isValidForm) {
                          if (_passwordController.text !=
                              _confirmPasswordController.text) {
                            displaySnackbar(
                                "Password and confirmation password do not match");
                            return;
                          }
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AlertDialog(
                                content: Row(
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(width: 16.0),
                                    Text("Logging in..."),
                                  ],
                                ),
                              );
                            },
                            barrierDismissible: false,
                          );

                          final postModel = LoginInput(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                          try {
                            LoginResponse? res =
                                await _dataService.login(postModel);
                            Navigator.pop(context);

                            if (res!.status == true) {
                              await AuthManager.login(
                                  _emailController.text, res.token.toString());
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const BottomNavBar(),
                                ),
                                (route) => false,
                              );

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Success"),
                                    content: const Text("Login successful!"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("OK"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              displaySnackbar(res.message);
                            }
                          } catch (e) {
                            Navigator.pop(context);
                            displaySnackbar(
                                "An error occurred while logging in.");
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 117, 35, 110),
                      ),
                      child: const Text('Login'),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                        (route) => false,
                      );
                    },
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 117, 35, 110)),
                    ),
                    child: const Text('Don\'t have an account? Register'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  dynamic displaySnackbar(String msg) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}
