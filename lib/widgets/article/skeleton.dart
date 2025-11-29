import 'package:flutter/material.dart';
import 'package:rss_reader/widgets/article/card.dart';
import 'package:shimmer/shimmer.dart';

class ArticleCardSkeleton extends StatelessWidget {
  /// There are two heights of the [ArticleCard] - 136 and 184 pixels.
  final bool high;

  const ArticleCardSkeleton({super.key, this.high = false});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.surfaceContainerLow,
      highlightColor: Theme.of(context).colorScheme.surfaceBright,
      child: Container(
        width: double.infinity,
        height: high ? 184 : 136,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
      ),
    );
  }
}
