import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/services/todo_api.dart';
import 'package:todo/todo/bloc/todo_events.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc({
    required TodoApi todoApi,
  })  : _todoApi = todoApi,
        super(TodoInitialState()) {
    on<FetchTodosEvent>(_onFetchTodos);
    on<CreateTodoEvent>(_onCreateTodo);
    on<UpdateTodoEvent>(_onUpdateTodo);
    on<DeleteTodoEvent>(_onDeleteTodo);
  }

  final TodoApi _todoApi;

  Future<void> _onFetchTodos(
      FetchTodosEvent event, Emitter<TodoState> emit) async {
    try {
      emit(TodoLoadingState());

      final todos = await _todoApi.fetchTodos();
      emit(TodoLoadedState(todos));
    } catch (e) {
      emit(TodoErrorState('Failed to load todos'));
    }
  }

  Future<void> _onCreateTodo(
      CreateTodoEvent event, Emitter<TodoState> emit) async {
    try {
      await _todoApi.createTodo(event.todo);

      if (state is TodoLoadedState) {
        final currentState = state as TodoLoadedState;
        final updatedTodos = List.of(currentState.todos)..add(event.todo);
        emit(TodoLoadedState(updatedTodos));
      }
    } catch (e) {
      emit(TodoErrorState('Failed to create todo'));
    }
  }

  Future<void> _onUpdateTodo(
      UpdateTodoEvent event, Emitter<TodoState> emit) async {
    try {
      await _todoApi.updateTodo(event.todo);

      if (state is TodoLoadedState) {
        final currentState = state as TodoLoadedState;

        final updatedTodos = currentState.todos.map((todo) {
          return todo.id == event.todo.id ? event.todo : todo;
        }).toList();

        emit(TodoLoadedState(updatedTodos));
      }
    } catch (e) {
      emit(TodoErrorState('Failed to update todo'));
    }
  }

  Future<void> _onDeleteTodo(
      DeleteTodoEvent event, Emitter<TodoState> emit) async {
    try {
      await _todoApi.deleteTodo(event.id);

      if (state is TodoLoadedState) {
        final currentState = state as TodoLoadedState;

        final updatedTodos =
            currentState.todos.where((todo) => todo.id != event.id).toList();

        emit(TodoLoadedState(updatedTodos));
      }
    } catch (e) {
      emit(TodoErrorState('Failed to delete todo'));
    }
  }
}
