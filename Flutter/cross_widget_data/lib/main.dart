import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ParentWidget(),
    );
  }
}

class ParentWidget extends StatefulWidget {
  const ParentWidget({super.key});

  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  String _dataFromChild = 'nil';

  void _updateData(String data, int count) {
    setState(() {
      _dataFromChild = '$data $count';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Parent Widget'),
        ),
        body: Column(
          children: [
            ChildWidget(updateData: _updateData),
            Text(_dataFromChild),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => AlertDialog(
                  title: Text(_dataFromChild),
                  content: const Text('This is an alert message'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ));
            });
          },
          child: const Icon(Icons.refresh),
        ));
  }
}

class ChildWidget extends StatefulWidget {
  final Function(String, int) updateData;

  const ChildWidget({Key? key, required this.updateData}) : super(key: key);

  @override
  _ChildWidgetState createState() => _ChildWidgetState();
}

class _ChildWidgetState extends State<ChildWidget> {
  String _data = 'Hello';
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$_data $count'),
        ElevatedButton(
          onPressed: () {
            count++;
            widget.updateData(_data, count);
          },
          child: const Text('Update Data'),
        ),
      ],
    );
  }
}
