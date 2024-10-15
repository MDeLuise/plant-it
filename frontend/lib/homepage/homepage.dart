import 'package:flutter/material.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/homepage/homepage_header.dart';
import 'package:plant_it/homepage/plant_list.dart';
import 'package:plant_it/event/recent_events.dart';

class HomePage extends StatelessWidget {
  final Environment env;
  const HomePage({
    super.key,
    required this.env,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomePageHeader(
            username: env.credentials.username,
          ),
          PlantList(
            env: env,
          ),
          const SizedBox(
            height: 25,
          ),
          RecentEvents(env: env),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}
