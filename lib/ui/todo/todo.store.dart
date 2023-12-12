import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';

import 'todo.api.dart';

final todoStore = TodoStore();

class TodoStore extends ChangeNotifier {
  Iterable<Todo> _todos = [];
  String? filterState;

  TodoStore() {
    refresh();
  }

  Future<void> refresh() async {
    try {
      debugPrint('refresh.');
      _todos = await fetchAll();
    } on HttpException {
      debugPrint('[Todo.refresh]: HttpException');
    } catch (error) {
      debugPrint(error.toString());
      debugPrint('any error.');
    } finally {
      notifyListeners();
    }
  }

  UnmodifiableListView<Todo> get todos => UnmodifiableListView(_todos);

  UnmodifiableListView<Todo> get filtered => UnmodifiableListView(
      _todos.where((e) => filterState == null ? true : e.state == filterState));
}

class TodoState {
  final String label;
  final String value;
  TodoState(this.value, this.label);
}

final Map<String, TodoState> todoStateMap = {
  'Pending': TodoState('Pending', '待處理'),
  'Progress': TodoState('Progress', '進行中'),
  'Resolved': TodoState('Resolved', '已完成'),
};
