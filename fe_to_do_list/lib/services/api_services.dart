import 'dart:convert';

import 'package:contact_dio/model/lists_model.dart';
import 'package:contact_dio/model/register_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:contact_dio/model/login_model.dart';

class ApiServices {
  final Dio dio = Dio();
  final String _baseUrl = 'https://asia-southeast2-keamanansistem.cloudfunctions.net';

  Future<Iterable<ListsModel>?> getAllContact() async {
    try {
      var response = await dio.get('$_baseUrl/contacts');

      if (response.statusCode == 200) {
        final contactList = (response.data['data'] as List)
            .map((contact) => ListsModel.fromJson(contact))
            .toList();

        return contactList;
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        debugPrint('Client error - the request cannot be fulfilled');
        return null;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<ListsModel?> getSingleContact(String id) async {
    try {
      var response = await dio.get('$_baseUrl/contacts/$id');

      if (response.statusCode == 200) {
        final data = response.data;
        return ListsModel.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        debugPrint('Client error - the request cannot be fulfilled');
        return null;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<ListResponse?> postContact(ListInput ct) async {
    try {
      final response = await dio.post(
        '$_baseUrl/insert',
        data: ct.toJson(),
      );
      if (response.statusCode == 200) {
        return ListResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<ListResponse?> putContact(String id, ListInput ct) async {
    try {
      final response = await Dio().put(
        '$_baseUrl/update/$id',
        data: ct.toJson(),
      );
      if (response.statusCode == 200) {
        return ListResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future deleteContact(String id) async {
    try {
      final response = await Dio().delete('$_baseUrl/delete/$id');
      if (response.statusCode == 200) {
        return ListResponse.fromJson(response.data);
      }
      return null;
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
