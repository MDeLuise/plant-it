import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:plant_it/ui/core/ui/error_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoScreen extends StatelessWidget {
  final String sourceCodeUrl = "https://github.com/MDeLuise/plant-it";
  final String supportUrl = "https://www.buymeacoffee.com/mdeluise";

  const InfoScreen({super.key});

  Future<void> _goToSourceCode() async {
    if (!await launchUrl(Uri.parse(sourceCodeUrl))) {
      throw Exception('Could not launch $sourceCodeUrl');
    }
  }

  Future<void> _goToSupport() async {
    if (!await launchUrl(Uri.parse(supportUrl))) {
      throw Exception('Could not launch $supportUrl');
    }
  }

  Future<String> _loadAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return "${packageInfo.version}+${packageInfo.buildNumber}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App Info')),
      body: SafeArea(
          child: FutureBuilder<String>(
              future: _loadAppVersion(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: const CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return ErrorIndicator(
                    title:
                        "Error", // AppLocalization.of(context).errorWhileLoadingHome,
                    label: "Try again", //AppLocalization.of(context).tryAgain,
                    onPressed: _loadAppVersion,
                  );
                }

                return Column(
                  children: [
                    ListTile(
                      title: Text("App version"),
                      subtitle: Text(snapshot.data!),
                    ),
                    GestureDetector(
                      onTap: _goToSourceCode,
                      child: ListTile(
                        title: Text("Source code"),
                        trailing: Icon(LucideIcons.external_link),
                      ),
                    ),
                    GestureDetector(
                      onTap: _goToSupport,
                      child: ListTile(
                        title: Text("Support ♥️"),
                        trailing: Icon(LucideIcons.external_link),
                      ),
                    ),
                  ],
                );
              })),
    );
  }
}
