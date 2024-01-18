import 'dart:convert';

import 'package:contact_dio/model/lists_model.dart';
import 'package:contact_dio/model/register_model.dart';
import 'package:contact_dio/services/auth_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:contact_dio/model/login_model.dart';

class ApiServices {
  final Dio dio = Dio();
  final String _baseUrl = 'https://asia-southeast2-keamanansistem.cloudfunctions.net';

  Future<Iterable<ListsModel>?> getAllTodolist(String token) async {

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
        Map<String, dynamic> jsonData  = json.decode(response.data);
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
      rethrow;
    } catch (e) {
      await AuthManager.logout();
      return null;
    }
  }

  Future<TodolistResponse> postTodolist(ListInput data, String token) async {
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $token', // Assuming it's a Bearer token
        // You may need to adjust the header format based on your API requirements
      },
    );
    try {
      final response = await dio.post(
        '$_baseUrl/todolist',
        data: data.toJson(),
        options: options
      );
      debugPrint('Response: ${response.data}');
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData  = json.decode(response.data);
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

  Future<TodolistResponse> putTodolist(ListInput data, String idTodolist, String token) async {
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $token', // Assuming it's a Bearer token
        // You may need to adjust the header format based on your API requirements
      },
    );
    try {
      final response = await dio.put(
        '$_baseUrl/todolist?id=$idTodolist',
        data: data.toJson(),
        options: options
      );
      debugPrint('Response: ${response.data}');
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData  = json.decode(response.data);
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

  Future deleteTodolist(String id, String token) async {
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $token', // Assuming it's a Bearer token
        // You may need to adjust the header format based on your API requirements
      },
    );
    try {
      final response = await dio.delete(
        '$_baseUrl/todolist?id=$id',
        options: options
      );
      debugPrint('Response: ${response.data}');
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData  = json.decode(response.data);
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


  Future<LoginResponse?> login(LoginInput login) async {
    try {
      final response = await dio.post(
        '$_baseUrl/todolist-signin',
        data: login.toJson(),
      );
      debugPrint('Response: ${response.data}');
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData  = json.decode(response.data);

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
        Map<String, dynamic> jsonData  = json.decode(response.data);

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
}
