import 'package:flutter/material.dart';

class RetriableErrorScreen extends StatefulWidget {
  // Title of the error screen
  final String heading;
  // Optional description
  final String? description;
  // The error object itself
  final Object error;
  // The callback to be executed when the user presses the "Retry" button
  // In case of null, the retry button will be hidden.
  final VoidCallback? onPressRetry;
  // Optional secondary action (e.g: Log out)
  final Widget? secondaryAction;
  final String? retryText;

  const RetriableErrorScreen({
    required this.heading,
    required this.error,
    this.description,
    this.onPressRetry,
    this.retryText,
    this.secondaryAction,
    super.key,
  });

  @override
  State<RetriableErrorScreen> createState() => _RetriableErrorScreenState();
}

class _RetriableErrorScreenState extends State<RetriableErrorScreen> {
  bool _showException = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Heading
            Text(
              widget.heading,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12.0),
            // Description
            if (widget.description != null) ...[
              Text(
                widget.description!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12.0),
            ],
            // Error itself
            if (_showException) ...[
              Text(
                widget.error.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
              const SizedBox(height: 16),
            ],
            // Retry button
            if (widget.onPressRetry != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: widget.onPressRetry,
                    onLongPress: () {
                      setState(() {
                        _showException = !_showException;
                      });
                    },
                    child: Text(widget.retryText ?? 'Retry'),
                  ),
                  if (widget.secondaryAction != null) ...[
                    const SizedBox(width: 12.0),
                    widget.secondaryAction!,
                  ],
                ],
              )
          ],
        ),
      ),
    );
  }
}
