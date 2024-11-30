import 'package:flutter/material.dart';
import 'package:register_work/models/task.dart';
import 'package:register_work/services/task_service.dart';
import 'package:shamsi_date/shamsi_date.dart';

class AddWorkPage extends StatefulWidget {
  const AddWorkPage({super.key});

  @override
  State<AddWorkPage> createState() => _AddWorkPageState();
}

class _AddWorkPageState extends State<AddWorkPage> {
  TextEditingController workDateController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  DateTime today = DateTime.now();
  String categorySelect = 'دانشجو';
  String typeSelect = 'حضوری';
  String toDayFa = '';
  bool follow = false;
  final _taskService = TaskService();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked =
        await showDatePicker(context: context, initialDate: today, firstDate: DateTime(2024), lastDate: DateTime(2101));
    if (picked != null && picked != today) {
      setState(() {
        today = picked;
        workDateController.text = miladiToShamsi(today.toLocal().toString().split(" ")[0]);
      });
    }
  }

  String miladiToShamsi(date) {
    DateTime parseDt = DateTime.parse(date);
    Jalali j1 = parseDt.toJalali();
    final f = j1.formatter;
    return '${f.wN} ${f.d} ${f.mN} ${f.yyyy}';
  }

  @override
  void initState() {
    workDateController.text = miladiToShamsi(DateTime.now().toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('افزودن کار'),
      ),
      body: Container(
        //width: size.width * 0.9,
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormField(
                controller: workDateController,
                readOnly: true,
                // enabled: false,
                decoration: InputDecoration(
                  // labelText: 'سن (سال)',
                  // labelStyle: ,
                  isDense: true,
                  prefixIcon: GestureDetector(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: Icon(Icons.calendar_month)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () => setState(() => categorySelect = 'دانشجو'),
                      child: _type(title: 'دانشجو', icon: Icons.school, categorySelect: categorySelect, context: context)),
                  GestureDetector(
                      onTap: () => setState(() => categorySelect = 'کارمند'),
                      child: _type(title: 'کارمند', icon: Icons.engineering, categorySelect: categorySelect, context: context)),
                  GestureDetector(
                      onTap: () => setState(() => categorySelect = 'استاد'),
                      child: _type(title: 'استاد', icon: Icons.man, categorySelect: categorySelect, context: context)),
                  GestureDetector(
                      onTap: () => setState(() => categorySelect = 'سایر'),
                      child: _type(title: 'سایر', icon: Icons.notes, categorySelect: categorySelect, context: context)),
                ],
              ),
              const SizedBox(height: 17),
              Row(
                children: [
                  OutlinedButton.icon(
                    icon: Icon(
                      Icons.call,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          typeSelect == 'تلفنی' ? WidgetStatePropertyAll(Theme.of(context).colorScheme.surfaceContainerHighest) : null,
                    ),
                    onPressed: () {
                      setState(() {
                        typeSelect = 'تلفنی';
                      });
                    },
                    label: Text(
                      'تلفنی',
                      style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  const SizedBox(width: 20),
                  OutlinedButton.icon(
                    icon: Icon(
                      Icons.directions_walk,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          typeSelect == 'حضوری' ? WidgetStatePropertyAll(Theme.of(context).colorScheme.surfaceContainerHighest) : null,
                    ),
                    onPressed: () {
                      setState(() {
                        typeSelect = 'حضوری';
                      });
                    },
                    label: Text(
                      'حضوری',
                      style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 17),
              TextFormField(
                controller: detailsController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'توضیحات',
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 17),
              Row(
                children: [
                  const Text('نیاز به پیگیری دارد؟ '),
                  Switch(
                    // This bool value toggles the switch.
                    value: follow,
                    //activeColor: Colors.red,
                    onChanged: (bool value) {
                      // This is called when the user toggles the switch.
                      setState(() {
                        follow = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 17),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            // DateTime parseDt = DateTime.parse(today.toString());
                            Jalali j1 = today.toJalali();
                            final f = j1.formatter;

                            Task task = Task(
                              category: categorySelect,
                              type: typeSelect,
                              regDate: today.toString().split(" ")[0],
                              follow: follow,
                              details: detailsController.text,
                              year: j1.year.toString(),
                              month: f.mN,
                              day: f.d,
                            );
                            await _taskService.saveTask(task);
                            setState(() {
                              detailsController.text = "";
                            });
                            // if (!context.mounted) return;
                            // Navigator.of(context).pop();
                          },
                          child: Text(
                            "ثبت",
                            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                          )),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _type({required title, required icon, required categorySelect, context}) {
    return Container(
      height: 75,
      width: 75,
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        // color: categorySelect == title ? Theme.of(context).colorScheme.surfaceContainerHigh : null,
        color: categorySelect == title ? Theme.of(context).colorScheme.surfaceContainerHigh : null,
        border: Border.all(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          Text(
            title,
            style: TextStyle(fontWeight: categorySelect == title ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
