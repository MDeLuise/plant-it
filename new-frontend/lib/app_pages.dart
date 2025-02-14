import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class AppPage extends StatelessWidget {
  final String title;
  final bool closeOnBack;
  final Widget child;
  final bool noPadding;
  final Widget? mainActionBtn;
  final List<Widget>? actions;

  const AppPage({
    super.key,
    required this.title,
    required this.child,
    this.closeOnBack = true,
    this.mainActionBtn,
    this.actions,
    this.noPadding = false,
  });

  @override
  Widget build(BuildContext context) {
    final double childPadding = noPadding ? 0 : 20;
    return Scaffold(
      bottomNavigationBar: mainActionBtn == null
          ? null
          : Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: BorderDirectional(
                  top: BorderSide(
                    color: Theme.of(context).colorScheme.onSurface,
                    width: .1,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow,
                    blurRadius: 10,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: mainActionBtn,
              ),
            ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Theme.of(context).colorScheme.surfaceBright,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.shadow,
                              blurRadius: 10,
                              offset: const Offset(0, 0),
                            ),
                          ]),
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: closeOnBack
                            ? Icon(
                                LucideIcons.x,
                                color: Theme.of(context).colorScheme.onSurface,
                                size: 18,
                              )
                            : Icon(
                                LucideIcons.chevron_left,
                                color: Theme.of(context).colorScheme.onSurface,
                                size: 18,
                              ),
                        tooltip: closeOnBack ? "Close" : "Back",
                      ),
                    ),
                    if (actions != null) ...actions!,
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(title,
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    childPadding, 0, childPadding, childPadding),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListPage extends StatelessWidget {
  final String title;
  final bool closeOnBack;
  final Widget child;
  final Function()? addEntityCallback;

  const ListPage({
    super.key,
    required this.title,
    required this.child,
    this.closeOnBack = true,
    this.addEntityCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Sticky AppBar
            SliverAppBar(
              pinned: true,
              floating: false,
              collapsedHeight: 75,
              expandedHeight: 75,
              elevation: 5,
              backgroundColor: Theme.of(context).colorScheme.surface,
              surfaceTintColor: Theme.of(context).colorScheme.surface,
              automaticallyImplyLeading: false,
              flexibleSpace: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        // Back/Close Button
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Theme.of(context).colorScheme.surfaceBright,
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.shadow,
                                blurRadius: 10,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: closeOnBack
                                ? Icon(LucideIcons.x,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    size: 18)
                                : Icon(LucideIcons.chevron_left,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    size: 18),
                            tooltip: closeOnBack ? "Close" : "Back",
                          ),
                        ),
                        const SizedBox(width: 20),

                        // Title
                        Text(
                          title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),

                    // Add New Button
                    TextButton(
                      onPressed: addEntityCallback,
                      style: const ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(Colors.transparent),
                      ),
                      child: Text(
                        "Add New".toUpperCase(),
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Main Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListPageWithActions extends StatelessWidget {
  final String title;
  final bool closeOnBack;
  final Widget child;
  final List<Widget> actions;

  const ListPageWithActions({
    super.key,
    required this.title,
    required this.child,
    this.closeOnBack = true,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Sticky AppBar
            SliverAppBar(
              pinned: true,
              floating: false,
              collapsedHeight: 75,
              expandedHeight: 75,
              elevation: 5,
              backgroundColor: Theme.of(context).colorScheme.surface,
              surfaceTintColor: Theme.of(context).colorScheme.surface,
              automaticallyImplyLeading: false,
              flexibleSpace: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        // Back/Close Button
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Theme.of(context).colorScheme.surfaceBright,
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.shadow,
                                blurRadius: 10,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: closeOnBack
                                ? Icon(LucideIcons.x,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    size: 18)
                                : Icon(LucideIcons.chevron_left,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    size: 18),
                            tooltip: closeOnBack ? "Close" : "Back",
                          ),
                        ),
                        const SizedBox(width: 20),

                        // Title
                        Text(
                          title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    ...actions,
                  ],
                ),
              ),
            ),

            // Main Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
