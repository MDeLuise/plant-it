import 'package:flutter/material.dart';

class CustomLoadingDialog extends StatefulWidget {
  final String title;
  final String text;
  final GlobalKey<CustomLoadingDialogState>? dialogKey;

  const CustomLoadingDialog({
    Key? key,
    required this.title,
    required this.text,
    this.dialogKey,
  }) : super(key: dialogKey);

  static void show({
    required BuildContext context,
    required String title,
    required String text,
    GlobalKey<CustomLoadingDialogState>? dialogKey,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CustomLoadingDialog(
        title: title,
        text: text,
        dialogKey: dialogKey,
      ),
    );
  }

  static void dismiss(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  CustomLoadingDialogState createState() => CustomLoadingDialogState();
}

class CustomLoadingDialogState extends State<CustomLoadingDialog> {
  double? _percentage;

  void updatePercentage(double? percentage) {
    setState(() {
      _percentage = percentage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 200,
            width: 400,
            child: Image.asset(
              'packages/quickalert/assets/loading.gif',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  widget.text,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                if (_percentage != null && _percentage! >= 0)
                  LinearProgressIndicator(
                    value: _percentage! / 100,
                    backgroundColor: Colors.grey.shade200,
                    color: Theme.of(context).primaryColor,
                  ),
                const SizedBox(height: 10),
                if (_percentage != null && _percentage! >= 0)
                  Text(
                    '${_percentage!.toStringAsFixed(1)}%',
                    style: const TextStyle(fontSize: 14),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
