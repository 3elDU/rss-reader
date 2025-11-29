import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/database/dataclasses.dart';
import 'package:rss_reader/providers/article.dart';
import 'package:rss_reader/widgets/article/card.dart';
import 'package:rss_reader/widgets/article/search.dart';
import 'package:rss_reader/widgets/article/skeleton.dart';
import 'package:rss_reader/widgets/filtering/chips.dart';
import 'package:rss_reader/widgets/info.dart';

/// Shows a configurable, scrollable list of articles with optional filters,
/// search bar, statistics, loading state, refresh gesture.
///
/// Articles are read from the nearest [ArticleListModel] ancestor, or the provided one
class ArticleListView extends StatelessWidget {
  final ArticleListModel? model;

  /// Whether to show the search bar
  final bool showSearchBar;

  /// Whether to show the scrollable strip with filtering chips
  final bool showFilterChips;

  /// Whether to show the informational line with article count and last refresh date
  final bool showInfoStrip;

  const ArticleListView({
    super.key,
    this.model,
    this.showSearchBar = true,
    this.showFilterChips = true,
    this.showInfoStrip = true,
  });

  Widget _buildScrollView(ArticleListModel model) {
    final items = model.items;

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        if (showSearchBar)
          SliverPadding(
            padding: const .all(16),
            sliver: SliverToBoxAdapter(
              child: ArticleSearchBar(enabled: !model.loading),
            ),
          ),

        // Padding around the filtering strip is not applied,
        // because the widget applies it on it's own.
        // This is to allow proper edge-to-edge scrolling.
        if (showFilterChips) SliverToBoxAdapter(child: FilteringStrip()),

        // Spacing between filters and info strip
        if (showFilterChips && showInfoStrip)
          const SliverToBoxAdapter(child: SizedBox(height: 8)),

        if (showInfoStrip)
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(child: InfoStrip()),
          ),

        // Spacing between info strip and article list
        if (showFilterChips && showInfoStrip)
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

        SliverArticleList(loading: model.loading, items: items),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = this.model ?? context.watch<ArticleListModel>();

    return RefreshIndicator(
      onRefresh: model.refresh,
      child: _buildScrollView(model),
    );
  }
}

/// A sliver showing the list of articles.
///
/// Handles loading state automatically
class SliverArticleList extends StatelessWidget {
  final List<ArticleWithFeed> items;
  final EdgeInsets? padding;
  final bool loading;

  final ArticleCard Function(ArticleWithFeed model)? cardBuilder;

  const SliverArticleList({
    super.key,
    required this.items,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.loading = false,
    this.cardBuilder,
  });

  Widget _buildLoadingList() {
    return SliverList.separated(
      itemCount: 10,
      itemBuilder: (_, index) => ArticleCardSkeleton(high: index % 3 == 0),
      separatorBuilder: (_, _) => const SizedBox(height: 12),
    );
  }

  Widget _buildList() {
    return SliverList.separated(
      itemCount: items.length,
      itemBuilder: (_, index) => cardBuilder != null
          ? cardBuilder!(items[index])
          : ArticleCard(items[index]),
      separatorBuilder: (_, _) => const SizedBox(height: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = loading ? _buildLoadingList() : _buildList();

    if (padding != null) {
      return SliverPadding(padding: padding!, sliver: list);
    } else {
      return list;
    }
  }
}
