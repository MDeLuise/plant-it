import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

List<Skeletonizer> generateSkeleton(int num, bool enabled) {
  final List<Skeletonizer> result = [];
  for (var i = 0; i < num; i++) {
    result.add(Skeletonizer(
      effect: const PulseEffect(
        from: Colors.grey,
        to: Color.fromARGB(255, 207, 207, 207),
      ),
      enabled: enabled,
      child: SimpleInfoEntry(title: "foo" * (i + 1), value: "bar" * (num - i)),
    ));
  }
  return result;
}

class InfoGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const InfoGroup({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    bool allNull = true;
    for (var child in children) {
      if (child is! InfoEntry) {
        allNull = false;
        break;
      }
      if (child is SimpleInfoEntry &&
          child.value != null &&
          child.value != "null") {
        allNull = false;
      } else if (child is FullWidthInfoEntry &&
          child.value != null &&
          child.value != "null") {
        allNull = false;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          if (allNull)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context).noInfoAvailable,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ...children,
        ],
      ),
    );
  }
}

abstract class InfoEntry extends StatelessWidget {
  const InfoEntry({super.key});
}

class SwitchInfoEntry extends StatelessWidget implements InfoEntry {
  final String title;
  final bool value;

  const SwitchInfoEntry({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Row(
        children: [
          Text(title),
          const Spacer(),
          Switch(
            value: value,
            onChanged: (_) {},
          ),
        ],
      ),
    );
  }
}

class SimpleInfoEntry extends StatelessWidget implements InfoEntry {
  final String title;
  final String? value;

  const SimpleInfoEntry({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Row(
        children: value == null || value == "null"
            ? []
            : [
                Text(title),
                const Spacer(),
                Text(value!),
              ],
      ),
    );
  }
}

class FullWidthInfoEntry extends StatelessWidget implements InfoEntry {
  final String title;
  final String? value;

  const FullWidthInfoEntry({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: value == null
            ? []
            : [
                Text(title),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(24, 44, 37, 1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Text(value!)),
                ),
              ],
      ),
    );
  }
}
