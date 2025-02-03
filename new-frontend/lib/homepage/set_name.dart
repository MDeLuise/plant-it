import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/loading_button.dart';

class SetNamePanel extends StatefulWidget {
  final Environment env;
  final String currentUsername;
  final Function(String newUsername) callback;

  const SetNamePanel(this.env, this.callback, this.currentUsername,
      {super.key});

  @override
  State<SetNamePanel> createState() => _SetNamePanelState();
}

class _SetNamePanelState extends State<SetNamePanel> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.currentUsername;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * .2,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Form(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _controller,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: "Username",
                          icon: const Icon(LucideIcons.user),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      LoadingButton("Set Username", () {
                        widget.callback(_controller.text);
                        Navigator.of(context).pop();
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
