import 'dart:convert';
import 'dart:io';

import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'todo.api.dart';
import 'todo.store.dart' show todoStore;

class TodoForm {
  String? title;
  String? content;
  // TodoState state = TodoState.pending;
  TodoForm();
}

class TodoEditScreen extends StatefulWidget {
  const TodoEditScreen({super.key});

  @override
  State<TodoEditScreen> createState() => _TodoEditScreenState();
}

class _TodoEditScreenState extends State<TodoEditScreen> {
  late Todo todo;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TodoForm form = TodoForm();

  _TodoEditScreenState() {
    if (todoStore.selectedTodo == null) {
      throw Exception('不應該發生的狀況');
    }
    todo = todoStore.selectedTodo as Todo;
    form.title = todo.title;
    form.content = todo.content;
  }

  Future<void> _submit() async {
    try {
      final res =
          await update(todo.id, title: form.title, content: form.content);
      todoStore.updateTodo(res.id, res);
      todoStore.selectedTodo = res;
      debugPrint('編輯 Todo 成功');
      if (mounted) {
        if (context.canPop()) {
          context.pop();
          return;
        }
        context.go('/');
      }
    } on HttpException catch (e) {
      debugPrint('${e.uri} ${e.message}');
    } catch (e) {
      debugPrint('編輯 Todo 異常');
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('編輯'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _form,
          child: Column(children: [
            TextFormField(
              initialValue: todo.title,
              maxLength: 60,
              onSaved: (str) => form.title = str,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return '請輸入標題';
                }
                if (val.contains('1')) {
                  return '標題不可包含非法字元 "1"';
                }
                return null;
              },
              decoration: const InputDecoration(
                  hintText: '標題',
                  labelText: '標題',
                  helperText: '',
                  errorText: null),
            ),
            TextFormField(
              initialValue: todo.content,
              minLines: 1,
              maxLines: 3,
              maxLength: 200,
              keyboardType: TextInputType.multiline,
              onSaved: (str) => form.content = str,
              validator: (val) {
                return null;
              },
              decoration: const InputDecoration(
                  hintText: '內容',
                  labelText: '內容',
                  helperText: '',
                  errorText: null),
            ),
            ElevatedButton(
                onPressed: () {
                  debugPrint('確認');
                  _form.currentState!.save();
                  if (_form.currentState!.validate()) {
                    _submit();
                  }
                },
                child: const Text('確認'))
          ]),
        ),
      ),
    );
  }
}
