import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../mods/bloc_todo/ui/homepage.dart' show TodoHomePage;
import '../mods/bloc_todo/ui/create_page.dart' show CreatePage;
import '../mods/bloc_todo/ui/edit_page.dart' show EditPage;
import '../mods/todo/todo.api.dart' show Todo;

// GoRouter configuration
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const TodoHomePage(),
    ),
    GoRoute(
      path: '/newtodo',
      name: 'todo_new',
      builder: (context, state) => const CreatePage(),
    ),
    GoRoute(
      path: '/edittodo',
      name: 'todo_edit',
      builder: (context, state) {
        Todo todo = state.extra as Todo;
        return EditPage(todo);
      },
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
