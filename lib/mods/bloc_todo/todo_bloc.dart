import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';

import './todo_event.dart';
import './todo_repository.dart';
import './todo_state.dart';

import 'todo.api.dart' as api;

class TodoOverviewBloc extends Bloc<TodoEvent, TodosOverviewState> {
  final TodosRepository _todosRepository;

  TodoOverviewBloc({required TodosRepository todosRepository})
      : _todosRepository = todosRepository,
        super(const TodosOverviewState()) {
    on<TodoRefresh>(_onRefresh);
    on<TodoSelected>(_onSelect);
    on<TodoDeleted>(_onDelete);
    on<TodoFilterChange>(_onFilterChange);
    on<TodoSortAscChange>(_onSortAscChange);
  }

  Future<void> _onRefresh(TodoRefresh event, Emitter emit) async {
    emit(state.copyWith(
        status: TodosOverviewStatus.loading, selectedTodo: null));

    try {
      var todos = await _todosRepository.refresh();
      emit(state.copyWith(status: TodosOverviewStatus.success, todos: todos));
    } on HttpException {
      debugPrint('TodosOverviewStatus.failure');
      emit(state.copyWith(status: TodosOverviewStatus.failure));
    }
  }

  void _onSelect(TodoSelected event, Emitter emit) {
    if (event.todo == state.selectedTodo) {
      emit(state.copyWith(selectedTodo: null));
      return;
    }
    emit(state.copyWith(selectedTodo: event.todo));
  }

  Future<void> _onDelete(TodoDeleted event, Emitter emit) async {
    try {
      await api.delete(event.id);
    } on HttpException {
      debugPrint('TodosOverviewStatus.failure');
      emit(state.copyWith(status: TodosOverviewStatus.failure));
    }
    await _onRefresh(TodoRefresh(), emit);
  }

  void _onFilterChange(TodoFilterChange event, Emitter emit) {
    debugPrint(event.value);
    emit(state.copyWith(filterOption: event.value));
  }

  void _onSortAscChange(TodoSortAscChange event, Emitter emit) {
    emit(state.copyWith(asc: event.asc));
  }
}
