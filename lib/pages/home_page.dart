import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  showToast('hello');
                },
                child: const Text('Press')),
            ElevatedButton(
                onPressed: () {
                  Fluttertoast.showToast(
                    msg: 'سلام دوست من!',
                    backgroundColor: Colors.red.shade300,
                  );
                },
                child: const Text('Press-2')),
            Padding(
              padding: const EdgeInsets.all(30),
              child: TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'DATE',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () {
                  _selectDate();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (_picked != null) {
      setState(() {
        _dateController.text = _picked.toString().split(" ")[0];
      });
    }
  }
}

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.TOP, // position of toast
    backgroundColor: Colors.blue,
    textColor: Colors.red,
    fontSize: 16,
  );
}
