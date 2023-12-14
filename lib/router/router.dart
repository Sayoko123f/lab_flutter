import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../mods/todo/todo.screen.dart' show TodoScreen;
import '../mods/todo/todo.store.dart' show todoStore;
import '../mods/todo/todo.detail.dart' show TodoDetailScreen;
import '../mods/todo/todo.detail.edit.dart' show TodoEditScreen;

// GoRouter configuration
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const TodoScreen(),
    ),
    GoRoute(
        path: '/todo/:id',
        redirect: (context, state) {
          var todos = todoStore.todos
              .where((element) => element.id == state.pathParameters['id']);
          try {
            todoStore.selectedTodo = todos.single;
          } on StateError {
            return '/';
          }
          return null;
        },
        builder: (context, state) => const TodoDetailScreen()),
    GoRoute(
        path: '/todo/:id/edit',
        name: 'todo.edit',
        redirect: (context, state) =>
            todoStore.selectedTodo == null ? '/' : null,
        builder: (context, state) => const TodoEditScreen())
  ],
);
