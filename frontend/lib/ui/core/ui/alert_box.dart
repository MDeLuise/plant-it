import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

enum AlertType { error, warning, info }

class AlertBox extends StatelessWidget {
  final IconData icon;
  final IconData btnIcon;
  final Color color;
  final String title;
  final String message;
  final String okText;
  final VoidCallback onConfirm;
  final bool isCancelVisible;

  const AlertBox({super.key, 
    required this.icon,
    required this.btnIcon,
    required this.title,
    required this.message,
    required this.onConfirm,
    required this.color,
    required this.isCancelVisible,
    this.okText = "Ok",
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      backgroundColor: Theme.of(context).colorScheme.surface,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: color.withAlpha(30),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Icon(icon, color: color, size: 48),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              color: const Color.fromARGB(255, 227, 227, 227),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (isCancelVisible)
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * .35,
                        ),
                        child: Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ButtonStyle(
                              // padding: const WidgetStatePropertyAll(
                              //   EdgeInsets.symmetric(
                              //       horizontal: 50, vertical: 10),
                              // ),
                              backgroundColor: WidgetStatePropertyAll(
                                  Theme.of(context).colorScheme.surface),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(LucideIcons.x,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                                const SizedBox(width: 5),
                                Text(
                                  "Cancel",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (isCancelVisible) const SizedBox(width: 10),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * .35,
                      ),
                      child: Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            onConfirm();
                          },
                          style: ButtonStyle(
                            // padding: const WidgetStatePropertyAll(
                            //   EdgeInsets.symmetric(
                            //       horizontal: 50, vertical: 10),
                            // ),
                            backgroundColor:
                                WidgetStatePropertyAll(color.withAlpha(200)),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(btnIcon,
                                  color:
                                      const Color.fromRGBO(245, 245, 247, 1)),
                              const SizedBox(width: 5),
                              Text(
                                okText,
                                style: const TextStyle(
                                  color: Color.fromRGBO(245, 245, 247, 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
