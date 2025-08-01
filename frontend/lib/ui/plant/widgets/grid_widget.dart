import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/domain/models/reminder_occurrence.dart';
import 'package:plant_it/ui/plant/view_models/plant_view_model.dart';
import 'package:plant_it/ui/plant/widgets/info_widget.dart';
import 'package:plant_it/utils/common.dart';
import 'package:plant_it/utils/icons.dart';

abstract class InfoGridWidget extends StatefulWidget {
  final PlantViewModel viewModel;
  final int maxNum;

  const InfoGridWidget(
      {super.key, required this.viewModel, required this.maxNum});

  List<InfoWidget> getInfoChildren();

  @override
  State<InfoGridWidget> createState() => _InfoGridWidgetState();
}

class _InfoGridWidgetState extends State<InfoGridWidget> {
  int _pages = 0;

  @override
  void initState() {
    super.initState();
    _pages = (widget.getInfoChildren().length / widget.maxNum).ceil();
  }

  Widget _buildSinglePage(List<Widget>? tiles) {
    return GridView.builder(
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5, // 3
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: tiles?.length ?? 0,
      itemBuilder: (context, index) {
        return tiles!.elementAt(index);
      },
    );
  }

  Widget _buildMultiplePages() {
    final List<List<Widget>> pagesList = _chunkWidgets(widget.maxNum);

    final List<Widget> pageWidgets =
        pagesList.map((chunk) => _buildSinglePage(chunk)).toList();

    return FlutterCarousel(
      options: FlutterCarouselOptions(
        showIndicator: true,
        enableInfiniteScroll: false,
        viewportFraction: 1,
        indicatorMargin: 0,
        height: 230,
        slideIndicator: CircularSlideIndicator(
            slideIndicatorOptions: SlideIndicatorOptions(
          currentIndicatorColor: Theme.of(context).primaryColor,
          indicatorBackgroundColor: Colors.grey.withOpacity(.5),
        )),
      ),
      items: pageWidgets,
    );
  }

  List<List<Widget>> _chunkWidgets(int chunkSize) {
    List<Widget> widgets = widget.getInfoChildren();
    List<List<Widget>> chunks = [];
    for (var i = 0; i < widgets.length; i += chunkSize) {
      final chunk = widgets.sublist(
          i, i + chunkSize > widgets.length ? widgets.length : i + chunkSize);
      chunks.add(chunk);
    }
    return chunks;
  }

  @override
  Widget build(BuildContext context) {
    if (_pages == 1) {
      return _buildSinglePage(widget.getInfoChildren());
    }
    return _buildMultiplePages();
  }
}

class SpeciesCareInfoGridWidget extends InfoGridWidget {
  const SpeciesCareInfoGridWidget(
      {super.key, required super.viewModel, required super.maxNum});

  @override
  List<InfoWidget> getInfoChildren() {
    List<InfoWidget> result = [];
    SpeciesCareData speciesCare = viewModel.care;

    String sunLightValue = "Low";
    if (speciesCare.light != null &&
        speciesCare.light! > 3 &&
        speciesCare.light! < 5) {
      sunLightValue = "Medium";
    } else if (speciesCare.light != null && speciesCare.light! > 5) {
      sunLightValue = "High";
    }
    result.add(InfoWidget(
        title: "Sunlight", value: sunLightValue, icon: LucideIcons.sun));

    if (speciesCare.humidity != null) {
      result.add(InfoWidget(
          title: "Humidity",
          value: "${speciesCare.humidity!}%",
          icon: LucideIcons.spray_can));
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
      result.add(InfoWidget(
          title: "Temperature",
          value: tempValue,
          icon: LucideIcons.thermometer));
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
      result.add(
          InfoWidget(title: "Ph", value: phValue, icon: LucideIcons.test_tube));
    }

    return result;
  }
}

class PlantEventInfoGridWidget extends InfoGridWidget {
  const PlantEventInfoGridWidget(
      {super.key, required super.viewModel, required super.maxNum});

  @override
  List<InfoWidget> getInfoChildren() {
    List<InfoWidget> result = [];
    List<Event> events = viewModel.events;
    Map<int, EventType> eventTypes = {};
    for (EventType t in viewModel.eventType) {
      eventTypes.putIfAbsent(t.id, () => t);
    }

    result.addAll(events.map((e) {
      return InfoWidget(
          title: eventTypes[e.type]!.name,
          value: timeDiffStr(e.date),
          icon: appIcons[eventTypes[e.type]!.icon]!);
    }));

    return result;
  }
}

class PlantReminderInfoGridWidget extends InfoGridWidget {
  const PlantReminderInfoGridWidget(
      {super.key, required super.viewModel, required super.maxNum});

  @override
  List<InfoWidget> getInfoChildren() {
    Map<int, EventType> eventTypes = {};
    for (EventType t in viewModel.eventType) {
      eventTypes.putIfAbsent(t.id, () => t);
    }

    List<ReminderOccurrence> plantReminders = viewModel.remindersOccurrences;

    return plantReminders
        .map((ro) => InfoWidget(
            title: eventTypes[ro.reminder.type]!.name,
            value: timeDiffStr(ro.nextOccurrence),
            icon: appIcons[eventTypes[ro.reminder.type]!.icon]!))
        .toList();
  }
}
