import 'package:flutter/material.dart';
import 'package:tipl_app/core/utilities/cust_colors.dart';


class NoInternetScreen extends StatelessWidget {
  final VoidCallback onRetry;

  const NoInternetScreen({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 20),
            Text(
              "No Internet Connection",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 20,),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "Please check your connection and try again.",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh,color: Colors.white,),
              label: const Text("Retry"),
              style: ElevatedButton.styleFrom(
                backgroundColor: CustColors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}