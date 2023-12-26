import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../mods/bloc_todo/ui/homepage.dart' show TodoHomePage;

// GoRouter configuration
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const TodoHomePage(),
    ),
    // GoRoute(
    //     path: '/todo/:id',
    //     redirect: (context, state) {
    //       var todos = todoStore.todos
    //           .where((element) => element.id == state.pathParameters['id']);
    //       try {
    //         todoStore.selectedTodo = todos.single;
    //       } on StateError {
    //         return '/';
    //       }
    //       return null;
    //     },
    //     builder: (context, state) => const TodoDetailScreen()),
    // GoRoute(
    //     path: '/todo/:id/edit',
    //     name: 'todo.edit',
    //     redirect: (context, state) =>
    //         todoStore.selectedTodo == null ? '/' : null,
    //     builder: (context, state) => const TodoEditScreen())
  ],
);
