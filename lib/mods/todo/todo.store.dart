import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';

import 'todo.api.dart';

final todoStore = TodoStore();

class TodoStore extends ChangeNotifier {
  List<Todo> _todos = [];
  Todo? selectedTodo;

  TodoStore() {
    refresh();
  }

  Future<void> refresh() async {
    try {
      debugPrint('refresh.');
      _todos = (await fetchAll()).toList();
    } on HttpException catch (e) {
      debugPrint('[Todo.refresh]: HttpException ${e.uri} ${e.message}');
    } catch (error) {
      debugPrint(error.toString());
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

  void updateTodo(String id, Todo newTodo) {
    _todos[_todos.indexWhere((e) => e.id == id)] = newTodo;
    debugPrint(_todos[_todos.indexWhere((e) => e.id == id)].title);
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

enum TodoState { pending, progress, resolved }

typedef TodoStateMeta = ({String value, String label, IconData icon});

extension on TodoState {
  TodoStateMeta get meta {
    switch (this) {
      case TodoState.pending:
        return (value: 'Pending', label: '待處理', icon: Icons.pending);
      case TodoState.progress:
        return (value: 'Progress', label: '進行中', icon: Icons.directions_run);
      case TodoState.resolved:
        return (value: 'Resolved', label: '已完成', icon: Icons.done);
    }
  }
}

enum TodoSortValue { none, createdAt, updatedAt }

final todoSortValueZh = {
  TodoSortValue.createdAt: '依建立時間',
  TodoSortValue.updatedAt: '依修改時間',
  TodoSortValue.none: '不排序',
};

enum SortBy { asc, desc }

List<DropdownMenuEntry<String?>> todoFilterDropdownMenuEntries() {
  var list = TodoState.values
      .map((e) => DropdownMenuEntry<String?>(
          value: e.meta.value,
          label: e.meta.label,
          leadingIcon: Icon(e.meta.icon)))
      .toList();
  list.insert(0, const DropdownMenuEntry(value: null, label: '全部'));
  return list;
}
