import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import '../models/task.dart';

class HiveDataStore {
  //box name
  static const boxName = 'taskBox';

  //Current Box with all the saved data inside
  final Box<Task> box = Hive.box<Task>(boxName);

  //Add new task to box
  Future<void> addTask({required Task task}) async {
    await box.put(task.id, task);
  }

  //show task
  Future<Task?> getTask({required String id}) async {
    return box.get(id);
  }

  //ubdate task
  Future<void> updateTask({required Task task}) async {
    await task.save();
  }

  //Delete task
  Future<void> deleteTask({required Task task}) async {
    await task.delete();
  }

  //listen to box changes
  ValueListenable<Box<Task>> listenToTask() => box.listenable();
}
