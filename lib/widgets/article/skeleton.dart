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

/// A wrapper around [ArticleCardSkeleton], showing a [SliverList] with a
/// couple of skeleton elements.
class ArticleSkeletonSliverList extends StatelessWidget {
  /// Whether to apply padding around the SliverList.
  /// False by default, because often there's already a padding
  /// applied to the page.
  final EdgeInsets? padding;

  const ArticleSkeletonSliverList({
    super.key,
    this.padding = const EdgeInsets.all(16.0),
  });

  @override
  Widget build(BuildContext context) {
    final list = SliverList.separated(
      itemCount: 10,
      itemBuilder: (_, index) => ArticleCardSkeleton(high: index.isEven),
      separatorBuilder: (_, _) => const SizedBox(height: 10),
    );

    if (padding != null) {
      return SliverPadding(padding: padding!, sliver: list);
    } else {
      return list;
    }
  }
}
