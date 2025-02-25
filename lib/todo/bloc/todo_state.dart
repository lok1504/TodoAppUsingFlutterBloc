import 'package:equatable/equatable.dart';
import 'package:todo/models/todo.dart';

abstract class TodoState extends Equatable {
  @override
  List<Object> get props => [];
}

class TodoInitialState extends TodoState {}

class TodoLoadingState extends TodoState {}

class TodoLoadedState extends TodoState {
  final List<Todo> todos;

  TodoLoadedState(this.todos);

  @override
  List<Object> get props => [todos];
}

class TodoErrorState extends TodoState {
  final String message;

  TodoErrorState(this.message);

  @override
  List<Object> get props => [message];
}
