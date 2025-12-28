import 'package:flutter/material.dart';

/// Simiar to a [ListTile], but the leading widget is in the center of
/// attention, appearing above a [Material].
class ActionItem extends StatelessWidget {
  final Widget icon;
  final String title;
  final String? description;
  final void Function() onTap;

  const ActionItem({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: .center,
          spacing: 16,
          children: [
            SizedBox(
              width: 64,
              height: 64,
              child: Material(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: .circular(16),
                child: InkWell(
                  child: Align(alignment: .center, child: icon),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: .start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                if (description != null) Text(description!),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
