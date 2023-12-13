import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../mods/todo/todo.screen.dart' show TodoScreen;
import '../mods/todo/todo.store.dart' show todoStore;
import '../mods/todo/todo.detail.dart' show DetailScreen;

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
        builder: (context, state) => DetailScreen(
              goRouterState: state,
            ))
  ],
);
