import 'package:plant_it/environment.dart';
import 'package:flutter/material.dart';

class EventsPage extends StatefulWidget {
  final Environment env;
  const EventsPage(this.env, {super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Text("Events"),
    );
  }
}
