import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:np_app/services/todo_service.dart';

final serviceProvider = StateProvider<ToDoService>((ref) {
  return ToDoService();
});
