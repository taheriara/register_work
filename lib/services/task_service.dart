import 'package:register_work/db_helper/repository.dart';
import 'package:register_work/models/task.dart';

class TaskService {
  late Repository _repository;
  TaskService() {
    _repository = Repository();
  }

  //Save User
  saveTask(Task task) async {
    return await _repository.insertData('tasks', task.toMap());
  }

  updateDaily(Task task) async {
    return await _repository.updateDaily('tasks', task.toMap());
  }

  //Read All Users
  readAllTask() async {
    return await _repository.readDataAll('tasks');
  }

  Future<List<Task>> getAllTasksYearMonth(String month, String year) async {
    var groceries = await _repository.readData("tasks", "month=\'$month\' and year=\'$year\'", "id DESC");
    List<Task> groceryList = groceries.isNotEmpty ? List<Task>.from(groceries.map((c) => Task.fromJson(c)).toList()) : [];
    return groceryList;
  }

  Future<List<Task>> getAllTasks() async {
    var groceries = await _repository.readDataAll("tasks");
    List<Task> groceryList = groceries.isNotEmpty ? List<Task>.from(groceries.map((c) => Task.fromJson(c)).toList()) : [];
    return groceryList;
  }

  Future<List<Task>> getTasksWithDate(String date) async {
    var groceries = await _repository.readData("tasks", "regDate=\'$date\' ", "id DESC");
    List<Task> groceryList = groceries.isNotEmpty ? List<Task>.from(groceries.map((c) => Task.fromJson(c)).toList()) : [];
    return groceryList;
  }

  Future<Task> getTask(String date) async {
    var groceries = await _repository.readData("tasks", "regDate=\'$date\' ", "id");
    List<Task> groceryList = groceries.isNotEmpty ? List<Task>.from(groceries.map((c) => Task.fromJson(c)).toList()) : [];
    return groceryList[0];
  }

  getYears() async {
    var result = await _repository.readDataGroup("tasks", ['year'], "year");
    List<String> years = [];
    for (var element in result) {
      years.add(element['year']);
    }

    // var groceries = await _repository.readDataGroup("dailyEntery", ['year'], "year");
    //List<String> groceryList = groceries.isNotEmpty ? List<String>.from(groceries.map((c) => fromMap(c)).toList()) : [];
    return years;
  }

  deleteTask() async {
    return await _repository.deleteAllRecords('tasks', '');
  }

  // deleteUser(personId) async {
  //   return await _repository.deleteDataById('userInfo', personId);
  // }

  // resetNobatToId(loanNumber) async {
  //   return await _repository.resetNobatToId('userInfo', loanNumber);
  // }

  // addCol() async {
  //   return await _repository.alterTable('persons', 'amount');
  // }
}
