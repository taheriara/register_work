import 'package:flutter/material.dart';
import 'package:register_work/models/report.dart';
import 'package:register_work/services/task_service.dart';

class ExportDataPage extends StatefulWidget {
  const ExportDataPage({super.key});

  @override
  State<ExportDataPage> createState() => _ExportDataPageState();
}

class _ExportDataPageState extends State<ExportDataPage> {
  List<Report> report = [];
  final _taskService = TaskService();

  Future fetchFromDb() async {
    report.clear();
    report.addAll(await _taskService.getReport());
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
        title: const Text('گزارش کارها'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: report.length,
                  itemBuilder: (context, index) {
                    return report.isEmpty
                        ? const Center(
                            child: Text('فعلا خبری نیست!'),
                          )
                        : _box(title: report[index].category, subtitle: report[index].type, qty: report[index].qty, context: context);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _box({required title, required subtitle, required qty, context}) {
    var icon;
    switch (title) {
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
        title: Text("${"مراجعه " + subtitle + " " + title}: $qty"),
        //subtitle: Text(subtitle + ": " + qty.toString()),
      ),
    );
  }
}
