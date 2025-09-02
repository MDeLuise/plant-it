import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/domain/models/reminder_occurrence.dart';
import 'package:plant_it/l10n/app_localizations.dart';
import 'package:plant_it/ui/plant/view_models/plant_view_model.dart';
import 'package:plant_it/ui/plant/widgets/info_widget.dart';
import 'package:plant_it/utils/common.dart';
import 'package:plant_it/utils/icons.dart';

abstract class InfoGridWidget extends StatefulWidget {
  final SpeciesCareCompanion care;
  final int maxNum;

  const InfoGridWidget({
    super.key,
    required this.care,
    required this.maxNum,
  });

  List<InfoWidget> getInfoChildren(BuildContext context);

  @override
  State<InfoGridWidget> createState() => _InfoGridWidgetState();
}

class _InfoGridWidgetState extends State<InfoGridWidget> {
  int _pages = 0;

  @override
  void initState() {
    super.initState();
    _pages = (widget.getInfoChildren(context).length / widget.maxNum).ceil();
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
    List<Widget> widgets = widget.getInfoChildren(context);
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
    if (_pages == 0) {
      return SizedBox();
    }
    if (_pages == 1) {
      return _buildSinglePage(widget.getInfoChildren(context));
    }
    return _buildMultiplePages();
  }
}

class SpeciesCareInfoGridWidget extends InfoGridWidget {
  const SpeciesCareInfoGridWidget({
    super.key,
    required super.care,
    required super.maxNum,
  });

  @override
  List<InfoWidget> getInfoChildren(BuildContext context) {
    List<InfoWidget> result = [];
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    if (care.light.value != null) {
      String sunLightValue = appLocalizations.low;
      if (care.light.value! > 3 && care.light.value! < 5) {
        sunLightValue = appLocalizations.medium;
      } else if (care.light.value != null && care.light.value! > 5) {
        sunLightValue = appLocalizations.high;
      }
      result.add(InfoWidget(
          title: appLocalizations.sunlight,
          value: sunLightValue,
          icon: LucideIcons.sun));
    }

    if (care.humidity.value != null) {
      result.add(InfoWidget(
          title: appLocalizations.humidity,
          value: "${care.humidity.value!}0%",
          icon: LucideIcons.spray_can));
    }

    String? tempValue;
    if (care.tempMax.value != null && care.tempMin.value != null) {
      tempValue = "${care.tempMin.value} - ${care.tempMax.value} °C";
    } else if (care.tempMax.value == null && care.tempMin.value != null) {
      tempValue = "${appLocalizations.min} ${care.tempMin.value} °C";
    } else if (care.tempMax.value != null && care.tempMin.value == null) {
      tempValue = "${appLocalizations.max} ${care.tempMax.value} °C";
    }
    if (tempValue != null) {
      result.add(InfoWidget(
        title: appLocalizations.temperature,
        value: tempValue,
        icon: LucideIcons.thermometer,
      ));
    }

    String? phValue;
    if (care.phMax.value != null && care.tempMin.value != null) {
      phValue = "${care.phMin.value} - ${care.phMax.value}";
    } else if (care.phMax.value == null && care.phMin.value != null) {
      phValue = "${appLocalizations.min} ${care.tempMin.value}";
    } else if (care.phMax.value != null && care.phMin.value == null) {
      phValue = "${appLocalizations.max} ${care.phMax.value}";
    }
    if (phValue != null) {
      result.add(InfoWidget(
        title: appLocalizations.ph,
        value: phValue,
        icon: LucideIcons.test_tube,
      ));
    }

    return result;
  }
}

class PlantEventInfoGridWidget extends InfoGridWidget {
  final PlantViewModel viewModel;

  const PlantEventInfoGridWidget({
    super.key,
    required this.viewModel,
    required super.maxNum,
    required super.care,
  });

  @override
  List<InfoWidget> getInfoChildren(BuildContext context) {
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
  final PlantViewModel viewModel;

  const PlantReminderInfoGridWidget({
    super.key,
    required this.viewModel,
    required super.maxNum,
    required super.care,
  });

  @override
  List<InfoWidget> getInfoChildren(BuildContext context) {
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
