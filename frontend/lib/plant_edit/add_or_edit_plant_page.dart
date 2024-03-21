import 'package:flutter/material.dart';
import 'package:nested_scroll_view_plus/nested_scroll_view_plus.dart';
import 'package:plant_it/dto/plant_dto.dart';
import 'package:plant_it/plant_edit/add_or_edit_plant_body.dart';

class AddOrEditPlantPage extends StatefulWidget {
  final PlantDTO plantDTO;
  const AddOrEditPlantPage({super.key, required this.plantDTO});

  @override
  State<StatefulWidget> createState() => _AddOrEditPlantPage();
}

class _AddOrEditPlantPage extends State<AddOrEditPlantPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          shape: const CircleBorder(),
          backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
          child: Icon(widget.plantDTO.id == null
              ? Icons.add_outlined
              : Icons.save_outlined),
        ),
        body: DefaultTabController(
          length: 2,
          child: NestedScrollViewPlus(
            overscrollBehavior: OverscrollBehavior.outer,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                // SliverAppBar(
                //   pinned: true,
                //   stretch: true,
                //   expandedHeight: MediaQuery.of(context).size.height * .5,
                //   flexibleSpace: FlexibleSpaceBar(
                //     stretchModes: const <StretchMode>[
                //       StretchMode.zoomBackground,
                //       StretchMode.blurBackground,
                //     ],
                //     background: SpeciesImageHeader(
                //         species: widget.species, env: widget.env),
                //   ),
                //   //collapsedHeight: 100,
                // ),
              ];
            },
            body: AddOrEditPlantBody(
              plant: widget.plantDTO,
            ),
          ),
        ));
  }
}
