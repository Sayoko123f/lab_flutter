import 'package:bloc/bloc.dart';
import '../todo/todo.api.dart';

enum TodosOverviewStatus { initial, loading, success, failure }

final class TodosOverviewState {
  final TodosOverviewStatus status;
  final List<Todo> todos;

  const TodosOverviewState(
      {this.status = TodosOverviewStatus.initial, this.todos = const []});

  Iterable<Todo> get shouldShowTodos {
    return todos;
  }

  TodosOverviewState copyWith(
      {required TodosOverviewStatus status, List<Todo>? todos}) {
    return TodosOverviewState(status: status, todos: todos ?? this.todos);
  }
}
