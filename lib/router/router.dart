import 'package:go_router/go_router.dart';

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
          var len = todoStore.todos
              .where((element) => element.id == state.pathParameters['id'])
              .length;
          var ok = len > 0;
          return ok ? null : '/';
        },
        builder: (context, state) => DetailScreen(
              goRouterState: state,
            ))
  ],
);
