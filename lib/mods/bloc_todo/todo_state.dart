import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../todo/todo.api.dart';

enum TodosOverviewStatus { initial, loading, success, failure }

final class TodosOverviewState {
  final TodosOverviewStatus status;
  final List<Todo> todos;
  final Todo? selectedTodo;
  final bool shouldRebuildList;

  const TodosOverviewState(
      {this.status = TodosOverviewStatus.initial,
      this.todos = const [],
      this.selectedTodo,
      this.shouldRebuildList = true});

  Iterable<Todo> get shouldShowTodos {
    return todos;
  }

  TodosOverviewState copyWith(
      {TodosOverviewStatus? status,
      List<Todo>? todos,
      Todo? selectedTodo,
      bool? shouldRebuildList}) {
    return TodosOverviewState(
        status: status ?? this.status,
        todos: todos ?? this.todos,
        selectedTodo: selectedTodo,
        shouldRebuildList: shouldRebuildList ?? true);
  }

  @override
  int get hashCode => Object.hash(status, todos);

  @override
  bool operator ==(Object other) {
    return other is TodosOverviewState &&
        other.runtimeType == runtimeType &&
        other.hashCode == hashCode &&
        other.status == status &&
        other.selectedTodo == selectedTodo &&
        other.todos == todos;
  }
}
