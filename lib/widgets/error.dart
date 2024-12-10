import 'package:flutter/material.dart';

class RetriableErrorInfo extends StatelessWidget {
  // Description of what failed
  final String description;
  // The error object itself
  final Object error;
  // Optionally the callback to be executed when the user presses the "Retry" button
  final VoidCallback? onPressRetry;
  final String? retryText;

  const RetriableErrorInfo({
    required this.description,
    required this.error,
    this.onPressRetry,
    this.retryText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              description,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onPressRetry,
              child: Text(retryText ?? 'Retry'),
            )
          ],
        ),
      ),
    );
  }
}
