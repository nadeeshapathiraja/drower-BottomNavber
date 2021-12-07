import 'package:flutter/material.dart';

class UsagePage extends StatefulWidget {
  const UsagePage({Key? key}) : super(key: key);

  @override
  _UsagePageState createState() => _UsagePageState();
}

class _UsagePageState extends State<UsagePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("Usage Page"),
    );
  }
}
