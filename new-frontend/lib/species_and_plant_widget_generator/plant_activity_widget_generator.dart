import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_it/common.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/icons.dart';

class PlantActivityWidgetGenerator {
  final Environment env;
  final Plant plant;
  final Map<int, EventType> eventTypes = {};

  PlantActivityWidgetGenerator(this.env, this.plant) {
    env.eventTypeRepository.getAll().then((rl) {
      for (EventType eventType in rl) {
        eventTypes[eventType.id] = eventType;
      }
    });
  }

  Future<List<PlantActivityInfoWidget>> getWidgets() async {
    final List<PlantActivityInfoWidget> result = [];
    env.eventRepository.getLastEventsForPlant(plant.id).then((el) {
      result.addAll(el.map((e) {
        return PlantActivityInfoWidget(eventTypes[e.type]!.name,
            timeDiffStr(e.date), appIcons[eventTypes[e.type]!.icon]!);
      }));
    });

    return result;
  }
}

class PlantActivityInfoWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const PlantActivityInfoWidget(this.title, this.value, this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Icon(
            icon,
            color: Colors.white,
            size: 30,
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.white),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
