import 'package:flutter/material.dart';
import 'package:register_work/models/task.dart';
import 'package:register_work/services/task_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Task> tasks = [];
  final _taskService = TaskService();

  Future fetchFromDb() async {
    tasks.clear();
    tasks.addAll(await _taskService.getAllTasks());
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('آرشیو ثبت کارها'),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        return tasks.isEmpty
                            ? const Center(
                                child: Text('فعلا خبری نیست!'),
                              )
                            : _box(
                                title: tasks[index].type,
                                subtitle: tasks[index].details,
                                leading: tasks[index].category,
                                date: tasks[index].regDate,
                                context: context);
                      }),
                ),
              ],
            )));
  }

  Widget _box({required title, required subtitle, required leading, date, context}) {
    var icon;
    switch (leading) {
      case 'استاد':
        icon = Icons.man;
        break;
      case 'دانشجو':
        icon = Icons.school;
        break;
      case 'کارمند':
        icon = Icons.engineering;
        break;
      default:
        icon = Icons.notes;
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
      // height: 80,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Theme.of(context).colorScheme.surfaceContainerHigh),
      child: ListTile(
        leading: Icon(icon, size: 30),
        title: Text(title),
        subtitle: Text(date + "\n" + subtitle),
      ),
    );
  }
}
