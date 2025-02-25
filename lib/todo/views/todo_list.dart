import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/todo/bloc/todo_bloc.dart';
import 'package:todo/todo/bloc/todo_state.dart';
import 'package:todo/todo/widgets/todo_list_item.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key, required this.openTodoForm});

  final Function({Todo? todo}) openTodoForm;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state is TodoLoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is TodoErrorState) {
          return Center(
              child: Text(
            state.message,
            style: TextStyle(
              color: Colors.red,
            ),
          ));
        } else if (state is TodoLoadedState) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.todos.length,
            itemBuilder: (_, index) {
              final todo = state.todos[index];
              return TodoListItem(
                todo: todo,
                openTodoForm: openTodoForm,
              );
            },
          );
        } else {
          return Placeholder();
        }
      },
    );
  }
}
