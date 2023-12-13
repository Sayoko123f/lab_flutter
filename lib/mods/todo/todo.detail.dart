import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'todo.api.dart';
import 'todo.store.dart';

class DetailScreen extends StatelessWidget {
  final GoRouterState? goRouterState;
  const DetailScreen({super.key, this.goRouterState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextButton.icon(
          label: const Text('返回'),
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            if (context.canPop()) {
              return context.pop();
            }
            return context.go('/');
          },
        ),
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      body: Container(
        color: Colors.pinkAccent,
        child: Column(children: [
          Consumer<TodoStore>(
              builder: (context, store, child) =>
                  Text(todoStore.selectedTodo!.id))
        ]),
      ),
    );
  }
}
