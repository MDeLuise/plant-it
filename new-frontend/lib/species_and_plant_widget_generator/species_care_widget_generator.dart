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
    } else if (speciesCare.light != null && speciesCare.light! > 5) {
      sunLightValue = "High";
    }
    result
        .add(SpeciesCareInfoWidget("Sunlight", sunLightValue, LucideIcons.sun));

    if (speciesCare.humidity != null) {
      result.add(SpeciesCareInfoWidget(
          "Humidity", "${speciesCare.humidity!}%", LucideIcons.spray_can));
    }

    String? tempValue;
    if (speciesCare.tempMax != null && speciesCare.tempMin != null) {
      tempValue = "${speciesCare.tempMin} - ${speciesCare.tempMax} °C";
    } else if (speciesCare.tempMax == null && speciesCare.tempMin != null) {
      tempValue = "min ${speciesCare.tempMin} °C";
    } else if (speciesCare.tempMax != null && speciesCare.tempMin == null) {
      tempValue = "max ${speciesCare.tempMax} °C";
    }
    if (tempValue != null) {
      result.add(SpeciesCareInfoWidget(
          "Temperature", tempValue, LucideIcons.thermometer));
    }

    String? phValue;
    if (speciesCare.phMax != null && speciesCare.tempMin != null) {
      phValue = "${speciesCare.phMin} - ${speciesCare.phMax}";
    } else if (speciesCare.phMax == null && speciesCare.phMin != null) {
      phValue = "min ${speciesCare.tempMin}";
    } else if (speciesCare.phMax != null && speciesCare.phMin == null) {
      phValue = "max ${speciesCare.phMax}";
    }
    if (phValue != null) {
      result.add(SpeciesCareInfoWidget("Ph", phValue, LucideIcons.test_tube));
    }

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
        color: const Color.fromARGB(255, 225, 225, 225),
        borderRadius: BorderRadius.circular(10),
        // boxShadow: [
        //   BoxShadow(
        //     color: Theme.of(context).colorScheme.shadow,
        //     blurRadius: 10,
        //     offset: const Offset(0, 0),
        //   ),
        // ],
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Icon(
            icon,
            size: 30,
          ),
          const SizedBox(width: 20),
          Expanded(
            // just to make the 2 TextOverflow.ellipsis work
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        overflow: TextOverflow.ellipsis,
                        color: Colors.black87,
                      ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
