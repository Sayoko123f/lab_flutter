import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'todo.store.dart' show TodoStore;

class TodoDetailScreen extends StatefulWidget {
  const TodoDetailScreen({super.key});

  @override
  State<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
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
                  Column(
                    children: [
                      TextButton.icon(
                        label: const Text('編輯'),
                        onPressed: () {
                          context.pushNamed('todo.edit',
                              pathParameters: {'id': store.selectedTodo!.id});
                        },
                        icon: const Icon(Icons.edit),
                      )
                    ],
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
