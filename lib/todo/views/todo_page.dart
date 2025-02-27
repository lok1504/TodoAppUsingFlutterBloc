import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/todo/bloc/todo_bloc.dart';
import 'package:todo/todo/bloc/todo_events.dart';
import 'package:todo/todo/views/todo_form.dart';
import 'package:todo/todo/views/todo_list.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  bool _isAscending = true;
  bool _showCompleted = false;

  @override
  Widget build(BuildContext context) {
    void openTodoForm({Todo? todo}) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) {
          return BlocProvider<TodoBloc>.value(
            value: BlocProvider.of<TodoBloc>(context),
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: TodoForm(todo: todo),
            ),
          );
        },
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Todo'),
        actions: [
          _buildSortByTitlePopupMenuButton(context),
          _buildFilterByIsCompletedPopupMenuButton(context),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TodoList(openTodoForm: openTodoForm),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 50,
          child: TextButton.icon(
            icon: Icon(Icons.add_circle),
            label: Text('Add Task'),
            onPressed: () {
              openTodoForm();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSortByTitlePopupMenuButton(BuildContext context) {
    return PopupMenuButton<bool>(
      icon: Icon(Icons.sort),
      tooltip: "Sort by Title",
      initialValue: _isAscending,
      onSelected: (bool item) {
        setState(() {
          _isAscending = item;
        });

        context.read<TodoBloc>().add(SortTodoEvent(_isAscending));
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<bool>>[
        const PopupMenuItem<bool>(
          value: true,
          child: Text('A-Z'),
        ),
        const PopupMenuItem<bool>(
          value: false,
          child: Text('Z-A'),
        ),
      ],
    );
  }

  Widget _buildFilterByIsCompletedPopupMenuButton(BuildContext context) {
    return PopupMenuButton<bool>(
      icon: Icon(Icons.filter_alt),
      tooltip: "Filter by Completed",
      initialValue: _showCompleted,
      onSelected: (bool item) {
        setState(() {
          _showCompleted = item;
        });

        context.read<TodoBloc>().add(FilterTodoEvent(_showCompleted));
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<bool>>[
        const PopupMenuItem<bool>(
          value: false,
          child: Text('All'),
        ),
        const PopupMenuItem<bool>(
          value: true,
          child: Text('Completed'),
        ),
      ],
    );
  }
}
