import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/dto/species_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/search/search_result.dart';

class SeachPage extends StatefulWidget {
  final Environment env;
  const SeachPage({super.key, required this.env});

  @override
  State<SeachPage> createState() => _SeachPageState();
}

class _SeachPageState extends State<SeachPage> {
  final TextEditingController _searchController = TextEditingController();
  final controller = PageController(viewportFraction: .8, keepPage: true);
  List<SpeciesDTO> _result = [];
  Timer? _debounce;

  void _fetchAndSetResult(String seatchTerm) async {
    final String url = seatchTerm.isEmpty
        ? "botanical-info"
        : "botanical-info/partial/$seatchTerm";
    try {
      final response = await widget.env.http.get(url);
      if (!mounted) return;
      if (response.statusCode != 200) {
        showSnackbar(
            context, SnackBarType.fail, json.decode(response.body)["message"]);
        return;
      }
      final List<dynamic> responseBody = json.decode(response.body);
      setState(() {
        _result = responseBody.map((p) => SpeciesDTO.fromJson(p)).toList();
      });
    } catch (e) {
      showSnackbar(context, SnackBarType.fail, e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAndSetResult("");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).searchNewGreenFriends,
                prefixIcon: const Icon(Icons.search_outlined),
                suffixIcon: _searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            _searchController.clear();
                            _fetchAndSetResult("");
                          });
                        },
                        child: const Icon(Icons.close_outlined),
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (_debounce?.isActive ?? false) _debounce!.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  setState(() {
                    _fetchAndSetResult(value);
                  });
                });
              },
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              // Calculate the number of items per row based on screen width
              int crossAxisCount =
                  constraints.maxWidth < 600 ? 1 : constraints.maxWidth ~/ 200;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  //crossAxisSpacing: 10,
                  //mainAxisSpacing: 10,
                  childAspectRatio: 2 / 1.3,
                ),
                itemCount: _result.length,
                itemBuilder: (context, index) {
                  return SearchResultCard(
                    species: _result[index],
                    env: widget.env,
                    result: _result,
                  );
                },
              );
            },
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}
