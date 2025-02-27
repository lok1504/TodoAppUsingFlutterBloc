import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/services/todo_api.dart';
import 'package:todo/todo/bloc/todo_events.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc({
    required TodoApi todoApi,
  })  : _todoApi = todoApi,
        super(TodoInitialState()) {
    on<FetchTodoEvent>(_onFetchTodo);
    on<CreateTodoEvent>(_onCreateTodo);
    on<UpdateTodoEvent>(_onUpdateTodo);
    on<DeleteTodoEvent>(_onDeleteTodo);
    on<SearchTodoEvent>(_onSearchTodo);
    on<FilterTodoEvent>(_onFilterTodo);
    on<SortTodoEvent>(_onSortTodo);
  }

  final TodoApi _todoApi;

  List<Todo> _todos = [];

  Future<void> _onFetchTodo(
      FetchTodoEvent event, Emitter<TodoState> emit) async {
    try {
      emit(TodoLoadingState());

      final todos = await _todoApi.fetchTodos();
      _todos = todos;

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
        _todos = updatedTodos;

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
        _todos = updatedTodos;

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
        _todos = updatedTodos;

        emit(TodoLoadedState(updatedTodos));
      }
    } catch (e) {
      emit(TodoErrorState('Failed to delete todo'));
    }
  }

  Future<void> _onSearchTodo(
      SearchTodoEvent event, Emitter<TodoState> emit) async {
    if (event.query.length >= 3 && state is TodoLoadedState) {
      final currentState = state as TodoLoadedState;

      List<Todo> filteredTodos = currentState.todos
          .where((todo) =>
              todo.title.toLowerCase().contains(event.query.toLowerCase()))
          .toList();

      emit(TodoLoadedState(filteredTodos));
    } else {
      emit(TodoLoadedState(_todos));
    }
  }

  Future<void> _onFilterTodo(
      FilterTodoEvent event, Emitter<TodoState> emit) async {
    if (event.isCompleted && state is TodoLoadedState) {
      final currentState = state as TodoLoadedState;

      List<Todo> filteredTodos = currentState.todos
          .where((todo) => todo.isCompleted == event.isCompleted)
          .toList();

      emit(TodoLoadedState(filteredTodos));
    } else {
      emit(TodoLoadedState(_todos));
    }
  }

  Future<void> _onSortTodo(SortTodoEvent event, Emitter<TodoState> emit) async {
    if (state is TodoLoadedState) {
      final currentState = state as TodoLoadedState;

      List<Todo> sortedTodoes = currentState.todos;

      sortedTodoes.sort((a, b) => event.isAscending
          ? a.title.compareTo(b.title)
          : b.title.compareTo(a.title));

      emit(TodoLoadedState(sortedTodoes));
    }
  }
}
