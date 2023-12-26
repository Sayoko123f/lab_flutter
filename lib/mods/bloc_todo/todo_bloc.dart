import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';

import './todo_event.dart';
import './todo_repository.dart';
import './todo_state.dart';

// import '../todo/todo.api.dart' show Todo;

class TodoOverviewBloc extends Bloc<TodoEvent, TodosOverviewState> {
  final TodosRepository _todosRepository;

  TodoOverviewBloc({required TodosRepository todosRepository})
      : _todosRepository = todosRepository,
        super(const TodosOverviewState()) {
    on<TodoRefresh>(_onRefresh);
  }

  Future<void> _onRefresh(TodoRefresh event, Emitter emit) async {
    emit(state.copyWith(status: TodosOverviewStatus.loading));

    try {
      var todos = await _todosRepository.refresh();
      emit(state.copyWith(status: TodosOverviewStatus.success, todos: todos));
    } on HttpException {
      debugPrint('TodosOverviewStatus.failure');
      emit(state.copyWith(status: TodosOverviewStatus.failure));
    }
  }
}
