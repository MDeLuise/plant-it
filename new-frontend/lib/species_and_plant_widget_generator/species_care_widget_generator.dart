import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_it/database/database.dart';

class SpeciesCareWidgetGenerator {
  final SpeciesCareData speciesCare;

  SpeciesCareWidgetGenerator(this.speciesCare);

  List<SpeciesCareInfoWidget> getWidgets() {
    final List<SpeciesCareInfoWidget> result = [];

    String sunLightValue = "Low";
    if (speciesCare.light != null &&
        speciesCare.light! > 3 &&
        speciesCare.light! < 5) {
      sunLightValue = "Medium";
    } else if (speciesCare.light != null &&
        speciesCare.light! > 3 &&
        speciesCare.light! < 5) {
      sunLightValue = "High";
    }
    result
        .add(SpeciesCareInfoWidget("Sunlight", sunLightValue, LucideIcons.sun));

    if (speciesCare.humidity != null) {
      result.add(SpeciesCareInfoWidget(
          "Humidity", "${speciesCare.humidity! * 10}%", LucideIcons.spray_can));
    }

    String tempValue = "";
    if (speciesCare.tempMax != null && speciesCare.tempMin != null) {
      tempValue = "${speciesCare.tempMin} - ${speciesCare.tempMax} °C";
    } else if (speciesCare.tempMax == null && speciesCare.tempMin != null) {
      tempValue = "min ${speciesCare.tempMin} °C";
    } else if (speciesCare.tempMax != null && speciesCare.tempMin == null) {
      tempValue = "max ${speciesCare.tempMax} °C";
    }
    result.add(SpeciesCareInfoWidget(
        "Temperature", tempValue, LucideIcons.thermometer));

    String phValue = "";
    if (speciesCare.phMax != null && speciesCare.tempMin != null) {
      phValue = "${speciesCare.phMin} - ${speciesCare.phMax}";
    } else if (speciesCare.phMax == null && speciesCare.phMin != null) {
      phValue = "min ${speciesCare.tempMin}";
    } else if (speciesCare.phMax != null && speciesCare.phMin == null) {
      phValue = "max ${speciesCare.phMax}";
    }
    result.add(SpeciesCareInfoWidget("Ph", phValue, LucideIcons.test_tube));

    return result;
  }
}

class SpeciesCareInfoWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const SpeciesCareInfoWidget(this.title, this.value, this.icon, {super.key});

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
