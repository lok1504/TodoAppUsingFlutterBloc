import 'package:equatable/equatable.dart';
import 'package:todo/models/todo.dart';

abstract class TodoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchTodosEvent extends TodoEvent {}

class CreateTodoEvent extends TodoEvent {
  final Todo todo;

  CreateTodoEvent(this.todo);

  @override
  List<Object> get props => [todo];
}

class UpdateTodoEvent extends TodoEvent {
  final Todo todo;

  UpdateTodoEvent(this.todo);

  @override
  List<Object> get props => [todo];
}

class DeleteTodoEvent extends TodoEvent {
  final String id;

  DeleteTodoEvent(this.id);

  @override
  List<Object> get props => [id];
}
