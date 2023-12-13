import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'todo.api.dart';
import 'todo.store.dart' show TodoStore;

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
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Consumer<TodoStore>(
          builder: (context, store, child) => Column(children: [
                Row(children: [
                  Expanded(
                      child: Text(store.selectedTodo!.title,
                          textAlign: TextAlign.right)),
                  const Column(
                    children: [Icon(Icons.abc)],
                  )
                ]),
                Row(
                  children: [
                    Expanded(
                      child: Text(store.selectedTodo!.content,
                          textAlign: TextAlign.right),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text.rich(TextSpan(children: [
                        const TextSpan(text: '建立時間'),
                        TextSpan(
                            text: DateFormat('yyyy-MM-dd HH:mm:ss')
                                .format(store.selectedTodo!.createdAt)),
                      ])),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text.rich(TextSpan(children: [
                        const TextSpan(text: '修改時間'),
                        TextSpan(
                            text: DateFormat('yyyy-MM-dd HH:mm:ss')
                                .format(store.selectedTodo!.updatedAt)),
                      ])),
                    ),
                  ],
                ),
              ])),
    );
  }
}
