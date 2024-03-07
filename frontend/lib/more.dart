import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/rendering.dart';
import 'package:plant_it/environment.dart';

class MorePage extends StatelessWidget {
  final Environment env;
  const MorePage({super.key, required this.env});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('More'),
    );
  }
}
