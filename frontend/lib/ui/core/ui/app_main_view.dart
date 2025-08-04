import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/routing/routes.dart';

class AppMainView extends StatelessWidget {
  final Widget body;
  final int selectedIndex;

  const AppMainView({
    required this.body,
    required this.selectedIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: selectedIndex == 2
          ? null
          : FloatingActionButton(
              onPressed: () => context.push(Routes.event),
              child: const Icon(Icons.add),
            ),
      body: SafeArea(child: body),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go(Routes.home);
              break;
            case 1:
              context.go('/calendar');
              break;
            case 2:
              context.go('/search');
              break;
            case 3:
              context.go('/settings');
              break;
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.calendar_month), label: 'Calendar'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
