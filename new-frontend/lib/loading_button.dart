import 'package:easy_loading_button/easy_loading_button.dart';
import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  final Function callback;
  final String text;
  final double? width;
  final TextStyle? textStyle;
  final Color? buttonColor;

  const LoadingButton(this.text, this.callback,
      {super.key, this.width, this.textStyle, this.buttonColor});

  @override
  Widget build(BuildContext context) {
    return EasyButton(
      idleStateWidget: Text(
        text,
        style: textStyle ?? TextStyle(
          color: Theme.of(context).colorScheme.surfaceDim,
        ),
      ),
      loadingStateWidget: CircularProgressIndicator(
        strokeWidth: 3.0,
        valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).colorScheme.surfaceDim,
        ),
      ),
      useEqualLoadingStateWidgetDimension: true,
      useWidthAnimation: false,
      borderRadius: 100,
      elevation: 2.0,
      contentGap: 6.0,
      buttonColor: buttonColor ?? Theme.of(context).colorScheme.primary,
      onPressed: callback,
      width: width ?? double.infinity,
    );
  }
}
