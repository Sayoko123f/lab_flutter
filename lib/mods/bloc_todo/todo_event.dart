import 'package:bloc/bloc.dart';

sealed class TodoEvent {
  const TodoEvent();
}

final class TodoDeleted extends TodoEvent {}

final class TodoCreated extends TodoEvent {}

final class TodoRefresh extends TodoEvent {}
