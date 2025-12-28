import 'package:flutter/material.dart';

abstract class PickerBottomSheet<T> extends StatelessWidget {
  final String title;

  const PickerBottomSheet(this.title, {super.key});

  /// Show the picker bottom sheet.
  Future<T?> pick(BuildContext context) {
    return Navigator.push(
      context,
      ModalBottomSheetRoute(
        isScrollControlled: true,
        builder: (_) => _PickerBottomSheetWrapper(title: title, child: this),
      ),
    );
  }
}

class _PickerBottomSheetWrapper extends StatelessWidget {
  final String title;
  final Widget child;

  const _PickerBottomSheetWrapper({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const .fromLTRB(16, 24, 16, 16),
        child: Column(
          spacing: 24,
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            child,
          ],
        ),
      ),
    );
  }
}
