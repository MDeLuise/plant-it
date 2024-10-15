import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:plant_it/app_exception.dart';
import 'package:plant_it/dto/species_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/search/add_custom.dart';
import 'package:plant_it/search/search_result.dart';

class SeachPage extends StatefulWidget {
  final Environment env;
  const SeachPage({
    super.key,
    required this.env,
  });

  @override
  State<SeachPage> createState() => _SeachPageState();
}

class _SeachPageState extends State<SeachPage> {
  final TextEditingController _searchController = TextEditingController();
  final controller = PageController(viewportFraction: .8, keepPage: true);
  List<SpeciesDTO> _result = [];
  Timer? _debounce;
  bool _loading = true;

  void _fetchAndSetResult(String seatchTerm) async {
    setState(() {
      _loading = true;
    });
    final String url = seatchTerm.isEmpty
        ? "botanical-info"
        : "botanical-info/partial/$seatchTerm";
    try {
      final response = await widget.env.http.get(url);
      final List<dynamic> responseBody =
          json.decode(utf8.decode(response.bodyBytes));
      if (!mounted) return;
      if (response.statusCode != 200) {
        widget.env.logger.error(json.decode(response.body)["message"]);
        throw AppException(json.decode(response.body)["message"]);
      }
      setState(() {
        _result = responseBody.map((p) => SpeciesDTO.fromJson(p)).toList();
      });
    } catch (e, st) {
      widget.env.logger.error(e, st);
      throw AppException.withInnerException(e as Exception);
    } finally {
      setState(() {
        _loading = false;
      });
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
      physics: ClampingScrollPhysics(),
      child: Center(
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
            if (_loading)
              const CircularProgressIndicator()
            else
              Padding(
                padding: const EdgeInsets.all(35),
                child: Column(
                  children: [
                    ..._result.map(
                      (r) => Column(
                        children: [
                          SearchResultCard(
                            species: r,
                            env: widget.env,
                            result: _result,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    AddCustomCard(
                      env: widget.env,
                      species: _searchController.text,
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
