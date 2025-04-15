import 'package:flutter/material.dart';
import 'package:rss_reader/models/feed.dart';
import 'package:rss_reader/services/feed.dart';
import 'package:rss_reader/widgets/error.dart';
import 'package:rss_reader/widgets/subscription/thumbnail.dart';

class AddNewFeedDialog extends StatefulWidget {
  final FeedService feedService;

  const AddNewFeedDialog(this.feedService, {super.key});

  @override
  State<AddNewFeedDialog> createState() => _AddNewFeedDialogState();
}

class _AddNewFeedDialogState extends State<AddNewFeedDialog> {
  final PageController _pageController = PageController();
  Feed? _feed;
  // We don't care about the underlying type.
  // Store the future for displaying loading state
  Future<dynamic>? _requestFuture;

  void animateToFirstPage() {
    // Unfocus the possibly active input element to hide the on-screen keyboard
    FocusManager.instance.primaryFocus?.unfocus();
    _pageController.animateToPage(
      0,
      duration: Durations.medium2,
      curve: Curves.easeInOutCubic,
    );
  }

  void animateToSecondPage() {
    FocusManager.instance.primaryFocus?.unfocus();
    _pageController.animateToPage(
      1,
      duration: Durations.medium2,
      curve: Curves.easeInOutCubic,
    );
  }

  Future<void> fetchFeedInfo(String url) async {
    try {
      final future = widget.feedService.fetchRemoteFeedInfo(url);
      setState(() {
        _requestFuture = future;
      });
      final feed = await future;

      // If feed id is not zero in the response, this means that there is an existing feed with the same URL in the database
      if (feed.id != 0 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'A feed with the following URL already exists in the database',
            ),
          ),
        );
        return;
      }

      setState(() {
        _feed = feed;
      });
      animateToSecondPage();
    } catch (e, s) {
      if (mounted) {
        CustomizableErrorScreen(
          heading: 'Request error',
          description:
              'There was an error fetching feed metadata from the server',
          error: e,
          stackTrace: s,
        ).showSnackbar(context);
      }
      return;
    }
  }

  Future<void> subscribe(
    String url, {
    String? title,
    String? description,
  }) async {
    try {
      final future = widget.feedService.subscribeToFeed(
        url,
        title: title,
        description: description,
      );
      setState(() {
        _requestFuture = future;
      });
      final feed = await future;
      if (mounted) {
        Navigator.pop(context, feed);
      }
    } catch (e, s) {
      if (mounted) {
        CustomizableErrorScreen(
          heading: 'Request error',
          description: 'There was an error subscribing to a feed',
          error: e,
          stackTrace: s,
        ).showSnackbar(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a new feed')),
      body: FutureBuilder(
        future: _requestFuture,
        builder: (context, snapshot) {
          final loading =
              _requestFuture != null &&
              snapshot.connectionState != ConnectionState.done;

          return PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _FirstPage(onSubmitUrl: fetchFeedInfo, loading: loading),
              if (_feed != null)
                // Intercept the back button and navigate to first page when it is pressed
                PopScope(
                  canPop: false,
                  onPopInvokedWithResult: (_, __) => animateToFirstPage(),
                  child: _SecondPage(
                    _feed!,
                    onGoBack: animateToFirstPage,
                    onSubmit: subscribe,
                    loading: loading,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _FirstPage extends StatefulWidget {
  final void Function(String url) onSubmitUrl;
  final bool loading;

  const _FirstPage({required this.onSubmitUrl, required this.loading});

  @override
  State<_FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<_FirstPage> {
  final TextEditingController _urlController = TextEditingController();
  String? _urlError;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 12.0),
          TextField(
            controller: _urlController,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              labelText: 'URL',
              border: const OutlineInputBorder(),
              errorText: _urlError,
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.loading) const CircularProgressIndicator(),
              const SizedBox(width: 8.0),
              FilledButton(
                onPressed:
                    widget.loading
                        ? null
                        : () {
                          if (Uri.tryParse(_urlController.text) == null) {
                            setState(() {
                              _urlError = 'Invalid URL';
                            });
                          } else {
                            setState(() {
                              _urlError = null;
                            });
                            widget.onSubmitUrl(_urlController.text);
                          }
                        },
                child: const Text('Continue'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SecondPage extends StatefulWidget {
  final Feed feed;
  final void Function() onGoBack;
  final void Function(String url, {String? title, String? description})
  onSubmit;
  final bool loading;

  const _SecondPage(
    this.feed, {
    required this.loading,
    required this.onGoBack,
    required this.onSubmit,
  });

  @override
  State<_SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<_SecondPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    // Populate text fields with values from the feed
    _titleController = TextEditingController(text: widget.feed.title);
    _descriptionController = TextEditingController(
      text: widget.feed.description,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 16,
            children: [
              SubscriptionThumbnail(widget.feed.thumbnail),
              TextField(
                controller: TextEditingController(text: widget.feed.url),
                enabled: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Feed URL',
                ),
              ),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Title',
                ),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                ),
              ),
              Row(
                children: [
                  FilledButton.tonalIcon(
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Go back'),
                    onPressed: widget.loading ? null : widget.onGoBack,
                  ),
                  const Spacer(),
                  if (widget.loading) ...[
                    const CircularProgressIndicator(),
                    const SizedBox(width: 8.0),
                  ],
                  FilledButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add feed'),
                    onPressed:
                        widget.loading
                            ? null
                            : () => widget.onSubmit(
                              widget.feed.url!,
                              title: _titleController.text,
                              description: _descriptionController.text,
                            ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
