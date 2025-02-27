import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/theme/app_colors.dart';
import 'package:todo/todo/bloc/todo_bloc.dart';
import 'package:todo/todo/bloc/todo_events.dart';

class TodoSearchBar extends StatefulWidget {
  const TodoSearchBar({super.key, required this.todos});

  final List<Todo> todos;

  @override
  State<TodoSearchBar> createState() => _TodoSearchBarState();
}

class _TodoSearchBarState extends State<TodoSearchBar> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: SearchBar(
        controller: _controller,
        onChanged: (_) {
          final query = _controller.text;

          if (query.length >= 3) {
            context.read<TodoBloc>().add(SearchTodoEvent(query));
          } else {
            context.read<TodoBloc>().add(SearchTodoEvent(""));
          }
        },
        leading: const Icon(Icons.search),
        backgroundColor: WidgetStatePropertyAll(Colors.white),
        side: WidgetStatePropertyAll(
          BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        elevation: WidgetStatePropertyAll(0),
      ),
    );
  }
}
