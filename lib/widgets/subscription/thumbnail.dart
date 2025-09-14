import 'package:flutter/material.dart';

/// Shows a placeholder image if the subscription has no thumbnail.
class SubscriptionThumbnail extends StatelessWidget {
  final String? thumbnailUrl;
  final double height;

  const SubscriptionThumbnail(
    this.thumbnailUrl, {
    super.key,
    this.height = 240,
  });

  Widget _buildImageLoadingError(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;

    return Container(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Column(
        spacing: 12,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image_outlined, color: errorColor),
          Text('Loading image failed', style: TextStyle(color: errorColor)),
        ],
      ),
    );
  }

  Widget _buildNoImage(BuildContext context) => Container(
    color: Theme.of(context).colorScheme.primaryContainer,
    child: Icon(
      Icons.hide_image_outlined,
      color: Theme.of(context).colorScheme.primary,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: const Size.fromHeight(240),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child:
            thumbnailUrl != null
                ? Image.network(
                  thumbnailUrl!,
                  fit: BoxFit.cover,
                  semanticLabel: 'Feed cover image',
                  errorBuilder:
                      (context, error, stackTrace) =>
                          _buildImageLoadingError(context),
                )
                : _buildNoImage(context),
      ),
    );
  }
}
