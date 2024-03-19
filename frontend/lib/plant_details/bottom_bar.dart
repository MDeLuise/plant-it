import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class BottomActionBar extends StatelessWidget {
  const BottomActionBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        color: const Color.fromRGBO(24, 44, 37, 1),
        child: Row(children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add_a_photo_outlined),
            color: Color.fromARGB(255, 156, 192, 172),
            tooltip: AppLocalizations.of(context).addPhotos,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.calendar_month_outlined),
            color: Color.fromARGB(255, 156, 192, 172),
            tooltip: AppLocalizations.of(context).addEvents,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined),
            color: Color.fromARGB(255, 156, 192, 172),
            tooltip: AppLocalizations.of(context).modifyPlant,
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete_forever_outlined),
            color: Color.fromARGB(255, 156, 192, 172),
            tooltip: AppLocalizations.of(context).removePlant,
          ),
        ]));
  }
}
