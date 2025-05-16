import 'package:flutter/material.dart';

enum UiMode { mobile, desktop }

class UiModeDTO {
  UiMode uimode;

  UiModeDTO ({
    required this.uimode
  });

  static UiMode _stringToMode(String modeString) {
    switch (modeString.toLowerCase()) {
      case 'mobile':
        return UiMode.mobile;
      case 'desktop':
        return UiMode.desktop;
      default:
        throw Exception('Invalid mode string: $modeString');
    }
  }

  factory UiModeDTO.fromString(String unitString) {
    return UiModeDTO(uimode: _stringToMode(unitString));
  }

  factory UiModeDTO.fromJson(Map<String, dynamic> json) {
    return UiModeDTO(
      uimode: _stringToMode(json['uimode']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uimode": uimode.toString().split('.').last.toUpperCase(),
    };
  }

  @override 
  String toString() {
    return uimode.toString().split('.').last.toLowerCase();
  }
}