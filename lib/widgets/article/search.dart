import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/pages/article_details.dart';
import 'package:rss_reader/repositories/article.dart';

class ArticleSearchBar extends StatefulWidget {
  final bool enabled;

  const ArticleSearchBar({super.key, this.enabled = true});

  @override
  State<ArticleSearchBar> createState() => _ArticleSearchBarState();
}

class _ArticleSearchBarState extends State<ArticleSearchBar> {
  late SearchController _searchController;

  @override
  void initState() {
    super.initState();

    _searchController = SearchController();
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor.bar(
      enabled: widget.enabled,
      searchController: _searchController,
      barElevation: WidgetStatePropertyAll(0),
      barPadding: WidgetStatePropertyAll(EdgeInsets.fromLTRB(4, 0, 16, 0)),
      barLeading: IconButton(
        padding: .zero,
        icon: const Icon(Icons.menu),
        tooltip: "Open sidebar",
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      barTrailing: const [Icon(Icons.search)],
      barHintText: 'Search',
      suggestionsBuilder: (context, controller) async {
        if (controller.text.isEmpty) return [];

        final results = await context.read<ArticleRepository>().search(
          controller.text,
        );

        return List<ListTile>.generate(
          results.length,
          (index) => ListTile(
            title: Text(
              results[index].article.title,
              maxLines: 1,
              overflow: .ellipsis,
            ),
            subtitle: Text(results[index].feed.title),
            onTap: () => ArticleDetailsPage.open(context, results[index]),
          ),
        );
      },
    );
  }
}
