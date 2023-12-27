import '../todo/todo.api.dart' show Todo;

sealed class TodoEvent {
  const TodoEvent();
}

final class TodoDeleted extends TodoEvent {
  final String id;
  const TodoDeleted(this.id);
}

final class TodoRefresh extends TodoEvent {}

final class TodoSelected extends TodoEvent {
  final Todo todo;
  const TodoSelected(this.todo);
}

final class TodoFilterChange extends TodoEvent {
  final String value;
  const TodoFilterChange(this.value);
}
