import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:flutter/material.dart';
import 'package:plant_it/events/event_card.dart';
import 'package:plant_it/homepage/plant_card.dart';
import 'package:plant_it/tab_bar.dart';

class Homepage extends StatefulWidget {
  final Environment env;

  const Homepage(this.env, {super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Event> _recentEvents = [];
  List<Plant> _plants = [];

  @override
  void initState() {
    super.initState();
    widget.env.eventRepository
        .getLast(5)
        .then((r) => setState(() => _recentEvents = r));
    widget.env.plantRepository
        .getAll()
        .then((r) => setState(() => _plants = r));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            _Header(),
            SizedBox(height: 15),
            FlutterCarousel(
              options: FlutterCarouselOptions(
                height: 400.0,
                showIndicator: false,
              ),
              items: _plants.map((p) {
                return Builder(
                  builder: (BuildContext context) {
                    return PlantCard(widget.env, p);
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
  String _getGreeting(int hour) {
    if (hour < 12) {
      return "Good morning";
    } else if (hour < 18) {
      return "Good afternoon";
    } else {
      return "Good evening";
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentHour = DateTime.now().hour;
    final greeting = _getGreeting(currentHour);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                "User",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          //Icon(LucideIcons.bell),
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
