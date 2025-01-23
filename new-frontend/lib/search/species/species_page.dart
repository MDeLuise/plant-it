import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:shimmer/shimmer.dart';

class SpeciesPage extends StatefulWidget {
  final Environment env;
  final SpeciesCompanion species;

  const SpeciesPage(this.env, this.species, {super.key});

  @override
  State<SpeciesPage> createState() => _SpeciesPageState();
}

class _SpeciesPageState extends State<SpeciesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.species.avatarUrl.present)
              SizedBox(
                height: MediaQuery.of(context).size.height * .6,
                child: CachedNetworkImage(
                  imageUrl: widget.species.avatarUrl.value!,
                  fit: BoxFit.cover,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.error,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                  child: Text(
                    widget.species.dataSource.value.name,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.surfaceDim,
                        ),
                  ),
                ),
              ),
            ),
            _ScientificClassification(widget.species),
            _Synonyms(widget.species),
            _Care(widget.species),
          ],
        ),
      ),
    );
  }
}

class _ScientificClassification extends StatelessWidget {
  final SpeciesCompanion species;

  const _ScientificClassification(this.species);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(.7),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.secondary.withOpacity(.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Scientific Classification",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Family",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    species.family.value,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Genus",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    species.genus.value,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Species",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    species.species.value,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _Synonyms extends StatefulWidget {
  final SpeciesCompanion species;

  const _Synonyms(this.species);

  @override
  State<_Synonyms> createState() => _SynonymsState();
}

class _SynonymsState extends State<_Synonyms> {
  static const int _maxVisible = 5;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final List<String> synonyms = [
      'Flytrap',
      'Fly trap',
      'Snaptrap',
      'Venus plant',
      'Bug eater',
      'Carnivorous plant'
    ];

    final List<String> visibleSynonyms =
        _isExpanded ? synonyms : synonyms.take(_maxVisible).toList();

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(.7),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.secondary.withOpacity(.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Synonyms",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 10),
              _ListOfChip(
                texts: visibleSynonyms,
                hasToggleOption: synonyms.length > _maxVisible,
                isExpanded: _isExpanded,
                onTogglePressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListOfChip extends StatelessWidget {
  final List<String> texts;
  final bool hasToggleOption;
  final bool isExpanded;
  final VoidCallback? onTogglePressed;

  const _ListOfChip({
    required this.texts,
    this.hasToggleOption = false,
    this.isExpanded = false,
    this.onTogglePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 5,
        runSpacing: 1,
        children: [
          ...texts.map((text) {
            return Chip(
              label: Text(
                text,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
            );
          }),
          if (hasToggleOption)
            GestureDetector(
              onTap: onTogglePressed,
              child: Chip(
                label: Text(
                  isExpanded ? "View Less" : "View More",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
        ],
      ),
    );
  }
}

class _Care extends StatelessWidget {
  final SpeciesCompanion species;

  const _Care(this.species);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(.7),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.secondary.withOpacity(.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Care",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Light",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    "42 out of 10",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Water",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    "21 out of 42",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Ph Max",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    "2.8",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
