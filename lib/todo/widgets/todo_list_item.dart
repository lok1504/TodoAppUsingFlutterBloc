import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/todo/bloc/todo_bloc.dart';
import 'package:todo/todo/bloc/todo_events.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({
    super.key,
    required this.todo,
    required this.openTodoForm,
  });

  final Todo todo;
  final Function({Todo? todo}) openTodoForm;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todo.title),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        context.read<TodoBloc>().add(DeleteTodoEvent(todo.id));
      },
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8.0),
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) {
            var updatedTodo = Todo(
              id: todo.id,
              title: todo.title,
              description: todo.description,
              isCompleted: !todo.isCompleted,
            );

            context.read<TodoBloc>().add(UpdateTodoEvent(updatedTodo));
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              todo.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: todo.isCompleted ? Colors.grey : Colors.black,
                decoration:
                    todo.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            SizedBox(height: 2),
            Text(
              todo.description,
              style: TextStyle(
                color: todo.isCompleted ? Colors.grey : Colors.black,
                decoration:
                    todo.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
          ],
        ),
        trailing: !todo.isCompleted
            ? IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  openTodoForm(todo: todo);
                },
              )
            : null,
      ),
    );
  }
}
