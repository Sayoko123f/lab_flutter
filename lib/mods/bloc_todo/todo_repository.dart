import 'dart:io';
import 'package:flutter/material.dart';

import '../todo/todo.api.dart';

class TodosRepository {
  List<Todo> _todos = [];

  Future<List<Todo>> refresh() async {
    try {
      _todos = (await fetchAll()).toList();
      return _todos;
    } on HttpException catch (e) {
      debugPrint(
          '[TodosRepository.refresh]: HttpException ${e.uri} ${e.message}');
      rethrow;
    }
  }
}
