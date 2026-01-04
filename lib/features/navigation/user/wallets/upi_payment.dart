import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_upi_india/flutter_upi_india.dart';
import 'package:url_launcher/url_launcher.dart';

class UPIPayment {
  /// 🔹 Call this function from anywhere
  static Future<void> show(BuildContext context) async {
    if (!Platform.isAndroid) {
      _showMessage(context, "UPI apps are supported only on Android");
      return;
    }

    final apps = await UpiPay.getInstalledUpiApplications(
      statusType: UpiApplicationDiscoveryAppStatusType.all,
    );

    if (apps.isEmpty) {
      _showMessage(context, "No UPI apps found");
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _UPIAppGrid(apps: apps),
    );
  }

  static void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _UPIAppGrid extends StatelessWidget {
  final List<ApplicationMeta> apps;

  const _UPIAppGrid({required this.apps});

  Future<void> _openUpiApp(BuildContext context, ApplicationMeta app) async {
    final uri = Uri.parse(
      "android-app://${app.upiApplication.androidPackageName}",
    );

    Navigator.pop(context); // close bottom sheet

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Choose Payment App",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: apps.map((app) {
              return InkWell(
                onTap: () => _openUpiApp(context, app),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    app.iconImage(48),
                    const SizedBox(height: 6),
                    Text(
                      app.upiApplication.getAppName(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
