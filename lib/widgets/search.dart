import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/pages/subscription.dart';
import 'package:rss_reader/repositories/article.dart';

class ArticleSearchBar extends StatefulWidget {
  const ArticleSearchBar({super.key});

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
      searchController: _searchController,
      barElevation: WidgetStatePropertyAll(0),
      barLeading: const Icon(Icons.search),
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
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SubscriptionPage(results[index].feed),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
