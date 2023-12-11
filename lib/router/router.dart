import 'package:go_router/go_router.dart';
import '../ui/todo/todo.screen.dart';

// GoRouter configuration
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const TodoScreen(),
    ),
  ],
);
