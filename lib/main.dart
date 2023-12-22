import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:bloc/bloc.dart';

import 'router/router.dart';
import 'mods/bloc_todo/todo_bloc.dart';
import 'mods/bloc_todo/todo_event.dart';
import 'mods/bloc_todo/todo_repository.dart';
import 'mods/bloc_todo/todo_state.dart';

void main() {
  Intl.defaultLocale = 'zh-TW';
  initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [RepositoryProvider(create: (context) => TodosRepository())],
        child: Builder(builder: (context) {
          return BlocProvider(
            create: (context) => TodoOverviewBloc(
                todosRepository: context.read<TodosRepository>()),
            child: MaterialApp.router(
              title: 'Flutter Demo',
              theme: ThemeData(
                colorScheme: const ColorScheme.dark(),
                useMaterial3: true,
              ),
              routerConfig: router,
            ),
          );
        }));
  }
}
