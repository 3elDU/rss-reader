import 'package:flutter/material.dart';

class CustomizableErrorScreen extends StatefulWidget {
  // Title of the error screen
  final String heading;
  // Optional description
  final String? description;
  // The error object itself
  final Object error;
  final StackTrace? stackTrace;
  // The callback to be executed when the user presses the "Retry" button
  // In case of null, the retry button will be hidden.
  final VoidCallback? onPressRetry;
  // Optional secondary action (e.g: Log out)
  final Widget? secondaryAction;
  final String? retryText;

  const CustomizableErrorScreen({
    required this.heading,
    required this.error,
    this.stackTrace,
    this.description,
    this.onPressRetry,
    this.retryText,
    this.secondaryAction,
    super.key,
  });

  /// Shows a snackbar with [heading] as text and 'Details' button
  /// that opens up a detailed error screen
  void showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(heading),
      action: SnackBarAction(
        label: 'Details',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Scaffold(
                appBar: AppBar(title: const Text('Error details')),
                body: this,
              ),
              fullscreenDialog: true,
            ),
          );
        },
      ),
    ));
  }

  @override
  State<CustomizableErrorScreen> createState() =>
      _CustomizableErrorScreenState();
}

class _CustomizableErrorScreenState extends State<CustomizableErrorScreen> {
  bool _showException = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          _showException = !_showException;
        });
      },
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
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
                  '${widget.error.runtimeType}: ${widget.error.toString()}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                ),
                const SizedBox(height: 16),
                if (widget.stackTrace != null) ...[
                  Text(
                    widget.stackTrace.toString(),
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.error,
                          fontFamily: 'monospace',
                        ),
                  ),
                  const SizedBox(height: 16),
                ],
              ],
              // Retry button
              if (widget.onPressRetry != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                      onPressed: widget.onPressRetry,
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
      ),
    );
  }
}
