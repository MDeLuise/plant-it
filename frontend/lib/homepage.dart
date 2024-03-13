import 'package:flutter/material.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/environment.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';

class HomePage extends StatelessWidget {
  final Environment env;
  const HomePage({super.key, required this.env});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    //return const Center(child: Text("Home"));
    return SizedBox(
      height: height * (isSmallScreen(context) ? .7 : .5),
      child: Swiper(
        itemBuilder: (context, index) {
          // return Image.network(
          //   "https://via.placeholder.com/350x150",
          //   fit: BoxFit.fill,
          // );
          return PlantCard(
            name: "Plant $index",
            species: "Species $index",
            imageUrl: "https://picsum.photos/${600 + index}",
          );
        },
        loop: false,
        itemCount: 10,
        //pagination: const SwiperPagination(),
        scale: isSmallScreen(context) ? .7 : .4,
        viewportFraction: isSmallScreen(context) ? .5 : .2,
        containerWidth: 200,
        containerHeight: 400,
        //control: const SwiperControl(),
      ),
    );
  }
}

class PlantCard extends StatelessWidget {
  final String name;
  final String species;
  final String? imageUrl;

  const PlantCard(
      {super.key,
      required this.name,
      required this.species,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
              decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: imageUrl != null
                ? DecorationImage(
                    image: NetworkImage(imageUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          )),
        ),
        Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                ),
                Text(
                  species,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ))
      ],
    );
  }
}
