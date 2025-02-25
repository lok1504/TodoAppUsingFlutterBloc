import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/services/todo_api.dart';
import 'package:todo/theme/app_theme.dart';
import 'package:todo/todo/bloc/todo_bloc.dart';
import 'package:todo/todo/bloc/todo_events.dart';
import 'package:todo/todo/views/todo_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final TodoApi todoApi = TodoApi();

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.klkTheme,
      home: BlocProvider(
        create: (_) => TodoBloc(todoApi: todoApi)..add(FetchTodosEvent()),
        child: const TodoPage(),
      ),
    );
  }
}
