import 'package:flutter/material.dart';
import '../todo/todo.api.dart';

enum TodosOverviewStatus { initial, loading, success, failure }

final List<DropdownMenuEntry<String>> filterMenu = TodoState.values
    .map((e) => DropdownMenuEntry(
        value: e.value, label: e.label, leadingIcon: Icon(e.icon)))
    .toList()
  ..insert(
      0,
      const DropdownMenuEntry(
          value: 'all', label: '全部', leadingIcon: Icon(Icons.density_small)));

final class TodosOverviewState {
  final TodosOverviewStatus status;
  final List<Todo> todos;
  final Todo? selectedTodo;
  final String filterOption;

  const TodosOverviewState(
      {this.status = TodosOverviewStatus.initial,
      this.todos = const [],
      this.selectedTodo,
      this.filterOption = 'all'});

  List<Todo> get shouldShowTodos {
    TodoState? filterState;
    for (var s in TodoState.values) {
      if (filterOption == s.value) {
        filterState = s;
      }
    }
    List<Todo> list = todos;
    if (filterState != null) {
      list = todos.where((e) => e.state == filterState).toList();
    }
    return list;
  }

  TodosOverviewState copyWith(
      {TodosOverviewStatus? status,
      List<Todo>? todos,
      Todo? selectedTodo,
      String? filterOption}) {
    return TodosOverviewState(
        status: status ?? this.status,
        todos: todos ?? this.todos,
        selectedTodo: selectedTodo,
        filterOption: filterOption ?? this.filterOption);
  }

  @override
  int get hashCode => Object.hash(status, todos, selectedTodo, filterOption);

  @override
  bool operator ==(Object other) {
    return other is TodosOverviewState &&
        other.runtimeType == runtimeType &&
        other.hashCode == hashCode &&
        other.status == status &&
        other.todos == todos &&
        other.selectedTodo == selectedTodo &&
        other.filterOption == filterOption;
  }
}
