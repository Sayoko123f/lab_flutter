import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';

import 'todo.api.dart';

final todoStore = TodoStore();

class TodoStore extends ChangeNotifier {
  Iterable<Todo> _todos = [];

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

  String? _filterState;
  String? get filterState {
    return _filterState;
  }

  set filterState(String? val) {
    _filterState = val;
    notifyListeners();
  }

  TodoSortValue _todoSortValue = TodoSortValue.createdAt;
  TodoSortValue get todoSortValue {
    return _todoSortValue;
  }

  set todoSortValue(TodoSortValue val) {
    _todoSortValue = val;
    notifyListeners();
  }

  SortBy _sortBy = SortBy.asc;
  SortBy get sortBy {
    return _sortBy;
  }

  set sortBy(SortBy val) {
    _sortBy = val;
    notifyListeners();
  }

  UnmodifiableListView<Todo> get todos => UnmodifiableListView(_todos);

  UnmodifiableListView<Todo> get todoShouldShow {
    var list = _todos
        .where((e) => filterState == null ? true : e.state == filterState)
        .toList();

    list.sort((aa, bb) {
      var a = sortBy == SortBy.asc ? aa : bb;
      var b = sortBy == SortBy.asc ? bb : aa;

      return switch (todoSortValue) {
        TodoSortValue.createdAt => a.createdAt.compareTo(b.createdAt),
        TodoSortValue.updatedAt => a.updatedAt.compareTo(b.updatedAt),
        _ => 0
      };
    });
    return UnmodifiableListView(list);
  }
}

class TodoState {
  final String label;
  final String value;
  final IconData icon;
  TodoState(this.value, this.label, {required this.icon});
}

final Map<String, TodoState> todoStateMap = {
  'Pending': TodoState('Pending', '待處理', icon: Icons.pending),
  'Progress': TodoState('Progress', '進行中', icon: Icons.directions_run),
  'Resolved': TodoState('Resolved', '已完成', icon: Icons.done),
};

enum TodoSortValue { none, createdAt, updatedAt }

final todoSortValueZh = {
  TodoSortValue.createdAt: '依建立時間',
  TodoSortValue.updatedAt: '依修改時間',
  TodoSortValue.none: '不排序',
};

enum SortBy { asc, desc }

List<DropdownMenuEntry<String?>> todoFilterDropdownMenuEntries() {
  var list = todoStateMap.values
      .map((e) => DropdownMenuEntry<String?>(
          value: e.value, label: e.label, leadingIcon: Icon(e.icon)))
      .toList();
  list.insert(0, const DropdownMenuEntry(value: null, label: '全部'));
  return list;
}
