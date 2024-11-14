
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Channel',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String _eventChannel = "com.example.event_channel";
  final String _methodChannel = "com.example.method_channel";
  late Stream<dynamic> _dataEvent;
  dynamic _dataMethod = "Not Retrieve";

  @override
  void initState() {
    super.initState();
    _dataEvent = EventChannel(_eventChannel).receiveBroadcastStream();
    getData();
  }

  Future<void> getData() async {
    final data = await MethodChannel(_methodChannel).invokeMethod<String>("getData");
    setState(() {
      _dataMethod = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Event Channel'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("MethodChannel Data : $_dataMethod", style: Theme.of(context).textTheme.headlineMedium,),
            const SizedBox(height: 25),
            StreamBuilder(
              stream: _dataEvent,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    "EventChannel Data : ${snapshot.data}",
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getData();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
