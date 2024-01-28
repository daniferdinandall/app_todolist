import 'dart:convert';
import 'dart:io';

import 'package:contact_dio/model/lists_model.dart';
import 'package:contact_dio/model/profile_model.dart';
import 'package:contact_dio/model/register_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:contact_dio/model/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiServices {
  final Dio dio = Dio();
  late SharedPreferences logindata;
  String token = 'dadas';

  ApiServices() {
    initializeToken();
  }

  Future<void> initializeToken() async {
    logindata = await SharedPreferences.getInstance();
    token = logindata.getString('token') ?? "";
  }

  final String _baseUrl =
      'https://asia-southeast2-keamanansistem.cloudfunctions.net';

  Future<Iterable<ListsModel>?> getAllTodolist() async {
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $token', // Assuming it's a Bearer token
        // You may need to adjust the header format based on your API requirements
      },
    );

    try {
      debugPrint('Response: $token');
      var response = await dio.get('$_baseUrl/todolist', options: options);
      debugPrint('Response: ${response.data}');
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.data);
        final contactList = (jsonData['data'] as List)
            .map((contact) => ListsModel.fromJson(contact))
            .toList();
        return contactList;
        // return null;
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        debugPrint('Client error - the request cannot be fulfilled');
        return null;
      }
      debugPrint('Error: ${e.message}');
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<TodolistResponse> postTodolist(ListInput data) async {
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $token', // Assuming it's a Bearer token
        // You may need to adjust the header format based on your API requirements
      },
    );
    try {
      final response = await dio.post('$_baseUrl/todolist',
          data: data.toJson(), options: options);
      debugPrint('Response: ${response.data}');
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.data);
        return TodolistResponse.fromJson(jsonData);
      }
      return TodolistResponse.fromJson(json.decode(response.data));
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        debugPrint('Client error - the request cannot be fulfilled');
        return TodolistResponse.fromJson(e.response!.data);
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<TodolistResponse> putTodolist(ListInput data, String idTodolist) async {
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $token', // Assuming it's a Bearer token
        // You may need to adjust the header format based on your API requirements
      },
    );
    try {
      final response = await dio.put('$_baseUrl/todolist?id=$idTodolist',
          data: data.toJson(), options: options);
      debugPrint('Response: ${response.data}');
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.data);
        return TodolistResponse.fromJson(jsonData);
      }
      return TodolistResponse.fromJson(json.decode(response.data));
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        debugPrint('Client error - the request cannot be fulfilled');
        return TodolistResponse.fromJson(e.response!.data);
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future deleteTodolist(String id) async {
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $token', // Assuming it's a Bearer token
        // You may need to adjust the header format based on your API requirements
      },
    );
    try {
      final response =
          await dio.delete('$_baseUrl/todolist?id=$id', options: options);
      debugPrint('Response: ${response.data}');
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.data);
        return TodolistResponse.fromJson(jsonData);
      }
      return TodolistResponse.fromJson(json.decode(response.data));
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        debugPrint('Client error - the request cannot be fulfilled');
        return TodolistResponse.fromJson(e.response!.data);
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<ProfileModel?> getProfil() async {
    logindata = await SharedPreferences.getInstance();
    Options options = Options(
      headers: {
        'Authorization':
            'Bearer ${logindata.getString('token') ?? ""}', // Assuming it's a Bearer token
        // You may need to adjust the header format based on your API requirements
      },
    );

    try {
      var response =
          await dio.get('$_baseUrl/todolist-profile', options: options);
      if (response.statusCode == 200) {
        debugPrint('Successful response: ${response.data}');
        Map<String, dynamic> jsonData = json.decode(response.data);
        final profile = ProfileModel.fromJson(jsonData['data']);

        // Menggunakan atribut name dari ProfileModel
        debugPrint('Profile Name: ${profile.name}');

        return profile;
      }

      return ProfileModel.fromJson(json.decode(response.data));
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        debugPrint('Client error - the request cannot be fulfilled');
        return null;
      }
      rethrow;
    } catch (e) {
      // await AuthManager.logout();
      debugPrint("Error" + e.toString());
      return null;
      // rethrow;
    }
  }

  Future<ProfileResponse> putProfile(ProfileInput data) async {
    logindata = await SharedPreferences.getInstance();
    Options options = Options(
      headers: {
        'Authorization': 'Bearer ${logindata.getString('token') ?? ""}', // Assuming it's a Bearer token
        // You may need to adjust the header format based on your API requirements
      },
    );
    try {
      final response = await dio.put('$_baseUrl/todolist-profile',
          data: data.toJson(), options: options);
      debugPrint('Response: ${response.data}');
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.data);
        return ProfileResponse.fromJson(jsonData);
      }
      return ProfileResponse.fromJson(json.decode(response.data));
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        debugPrint('Client error - the request cannot be fulfilled');
        return ProfileResponse.fromJson(e.response!.data);
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<LoginResponse?> login(LoginInput login) async {
    try {
      final response = await dio.post(
        '$_baseUrl/todolist-signin',
        data: login.toJson(),
      );
      debugPrint('Response: ${response.data}');
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.data);

        return LoginResponse.fromJson(jsonData);
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        debugPrint('Client error - the request cannot be fulfilled');
        return LoginResponse.fromJson(e.response!.data);
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<RegisterResponse?> register(RegisterInput register) async {
    try {
      final response = await dio.post(
        '$_baseUrl/todolist-signup',
        data: register.toJson(),
      );
      debugPrint('Response: ${response.data}');
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.data);

        return RegisterResponse.fromJson(jsonData);
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        debugPrint('Client error - the request cannot be fulfilled');
        return RegisterResponse.fromJson(e.response!.data);
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<ProfileResponse?> putImage ({required dynamic image}) async {
    logindata = await SharedPreferences.getInstance();
    Options options = Options(
      headers: {
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer ${logindata.getString('token') ?? ""}', // Assuming it's a Bearer token
        // You may need to adjust the header format based on your API requirements
      },
    );
    try {
      MultipartFile? imageFile;
      if (image is File) {
        imageFile = await MultipartFile.fromFile(image.path);
      } else if (image is String) {
        imageFile = MultipartFile.fromString(image);
      }
      FormData formData = FormData.fromMap({
        "file": imageFile,
      });
      final response = await dio.put('$_baseUrl/todolist-photo',
          data: formData, options: options);
      debugPrint('>>>>>>>>>>>>Api Service Img<<<<<<<<<<<');
      debugPrint('Response: ${response.data}');
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.data);
        return ProfileResponse.fromJson(jsonData);
      }
      return ProfileResponse.fromJson(json.decode(response.data));
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        debugPrint('Client error - the request cannot be fulfilled');
        return ProfileResponse.fromJson(e.response!.data);
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
  void dispose() {
    // If there's any cleanup logic needed, add it here.
    // For example, if dio instance needs to be closed, you can do:
    dio.close();
  }
}
