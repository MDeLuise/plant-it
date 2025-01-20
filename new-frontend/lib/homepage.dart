import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:flutter/material.dart';
import 'package:plant_it/events/event_card.dart';
import 'package:plant_it/tab_bar.dart';

class Homepage extends StatefulWidget {
  final Environment env;

  const Homepage(this.env, {super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Event> _recentEvents = [];

  @override
  void initState() {
    super.initState();
    widget.env.eventRepository
        .getLast(5)
        .then((r) => setState(() => _recentEvents = r));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _Header(),
            FlutterCarousel(
              options: FlutterCarouselOptions(
                height: 400.0,
                showIndicator: false,
              ),
              items: [1, 2, 3, 4, 5].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'text $i',
                          style: TextStyle(fontSize: 16.0),
                        ));
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            _Recent(widget.env, _recentEvents),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hello"),
              Text("User"),
            ],
          ),
          Icon(LucideIcons.bell),
        ],
      ),
    );
  }
}

class _Recent extends StatelessWidget {
  final Environment env;
  final List<Event> recentEvents;

  const _Recent(this.env, this.recentEvents);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: AppTabBar(env, [
          "Reminders",
          "Events"
        ], [
          Center(
            child: Text(
              "Reminders will be displayed here",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Column(
            children: recentEvents.map((e) => EventCard(env, e)).toList(),
          )
        ]));
  }
}
