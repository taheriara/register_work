import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:register_work/ThemeProvider/theme_provider.dart';
import 'package:register_work/models/task.dart';
import 'package:register_work/pages/add_work_page.dart';
import 'package:register_work/pages/history_page.dart';
import 'package:register_work/services/task_service.dart';
import 'package:shamsi_date/shamsi_date.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //var gifts = Map<String, String>();
  var weekDays = Map<int, String>();
  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);
  String TodayFA = "چهارشنبه 7 آذر";

  List<DayInfo> dayLine = [];

  setWeekDays() {
    final toDay = DateTime.now(); //final toDay = DateTime.parse('2024-11-18');
    int weekDay = toDay.weekday;
    DateTime firstOfWeek = toDay.subtract(Duration(days: weekDay == 6 || weekDay == 7 ? weekDay - 6 : weekDay + 1));

    for (var i = 0; i < 7; i++) {
      Jalali j1 = firstOfWeek.toJalali();
      final f = j1.formatter;
      final d = DayInfo(dayNo: f.d, dayName: f.wN, dayDate: firstOfWeek, isToday: firstOfWeek == toDay);
      dayLine.add(d);
      firstOfWeek = firstOfWeek.add(const Duration(days: 1));
    }

    print("dayLine: ${dayLine.length}");
  }

  List<Task> tasks = [];
  final _taskService = TaskService();

  Future fetchFromDb() async {
    tasks.clear();
    tasks.addAll(await _taskService.getTasksWithDate(DateTime.now().toString().split(" ")[0]));
    print(tasks.length);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setWeekDays();
    fetchFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HistoryPage()),
          );
        },
        child: Icon(Icons.history, color: Theme.of(context).colorScheme.onPrimary),
      ),
      body: SafeArea(
        child: Consumer<ThemeProvider>(builder: (context, notifier, child) {
          return Column(
            children: [
              ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage("assets/images/user.jpg"), // No matter how big it is, it won't overflow
                  ),
                  title: const Text('حسین طاهری آرا'),
                  subtitle: const Text('دانشکده اقتصاد و علوم سیاسی'),
                  trailing: IconButton(
                      onPressed: () {
                        context.read<ThemeProvider>().themeOnChanged();
                      },
                      icon: Icon(notifier.isDark ? Icons.dark_mode : Icons.light_mode))),
              const SizedBox(
                height: 10,
              ),
              Container(
                // color: Colors.red,
                height: 86,
                width: MediaQuery.sizeOf(context).width * .95,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8), color: Theme.of(context).colorScheme.surfaceContainerHigh),
                child: SizedBox(
                  //height: 60,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      // itemExtent: 50,
                      //shrinkWrap: true,
                      itemCount: dayLine.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.only(right: 6, top: 12, bottom: 12, left: 6),
                          child: dayTile(item: dayLine[index]),
                        );
                      }),
                ),
              ),
              SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                //height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'امروز ${tasks.length.toString()} کار انجام شده است',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(TodayFA),
                      ],
                    ),
                    SizedBox(
                      //width: MediaQuery.sizeOf(context).width * .95,
                      height: 50,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary),
                              shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AddWorkPage()),
                            );
                            print('************past');
                            await fetchFromDb();
                          },
                          child: Text(
                            "+ افزودن کار",
                            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                          )),
                    )
                  ],
                ),
              ),

              ////////////////////////////////////////////////////
              Expanded(
                child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return tasks.isEmpty
                          ? const Center(
                              child: Text('فعلا خبری نیست!'),
                            )
                          : _box(
                              title: tasks[index].type, subtitle: tasks[index].details, leading: tasks[index].category, context: context);
                    }),
              )
            ],
          );
        }),
      ),
    );
  }

  Widget dayTile({
    required DayInfo item,
  }) =>
      Container(
        width: 42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: item.dayDate.day == DateTime.now().day
              ? Theme.of(context).colorScheme.onPrimaryContainer
              : Theme.of(context).colorScheme.surfaceContainerHigh,
        ),
        // height: 50,
        // color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item.dayName,
              style: TextStyle(
                fontFamily: 'Sahel FD',
                fontSize: 8,
                //fontWeight: FontWeight.bold,
                color: item.dayDate.day == DateTime.now().day ? Theme.of(context).colorScheme.onPrimary : null,
              ),
            ),
            Text(
              item.dayNo,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Sahel FD',
                fontSize: 24,
                //fontWeight: FontWeight.bold,
                color: item.dayDate.day == DateTime.now().day ? Theme.of(context).colorScheme.onPrimary : null,
              ),
            ),
          ],
        ),
      );

  Widget _box({required title, required subtitle, required leading, context}) {
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
        subtitle: Text(subtitle),
      ),
    );
  }
}

class DayInfo {
  final String dayNo;
  final String dayName;
  final DateTime dayDate;
  final bool isToday;

  //DayInfo({required String dayNo, required String dayName, required DateTime dayDate, bool bool});

  DayInfo({required this.dayNo, required this.dayName, required this.dayDate, required this.isToday});
}
