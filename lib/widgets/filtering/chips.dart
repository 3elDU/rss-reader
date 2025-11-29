import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/database/database.dart';
import 'package:rss_reader/providers/article.dart';
import 'package:rss_reader/providers/feed.dart';
import 'package:rss_reader/repositories/article.dart';

/// A horizontally scrollable widget with chips for common filtering and sorting actions
/// Uses the [ArticleListModel] for applying changes.
class FilteringStrip extends StatelessWidget {
  const FilteringStrip({super.key});

  Widget? _buildCheckmarkIf(bool condition) {
    if (!condition) return null;

    return Icon(Icons.check);
  }

  void _setOrdering(ArticleListModel model, Sort sort) {
    model.applyFilters(model.filters.copy()..order(sort));
  }

  Widget _buildOrderingChip(ArticleListModel model) {
    final filters = model.filters;

    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
          leadingIcon: _buildCheckmarkIf(
            filters.sorting == Sort.newestToOldest,
          ),
          child: const Text('Newest first'),
          onPressed: () => _setOrdering(model, .newestToOldest),
        ),
        MenuItemButton(
          leadingIcon: _buildCheckmarkIf(
            filters.sorting == Sort.oldestToNewest,
          ),
          child: const Text('Oldest first'),
          onPressed: () => _setOrdering(model, .oldestToNewest),
        ),
        MenuItemButton(
          leadingIcon: _buildCheckmarkIf(
            filters.sorting == Sort.alphabeticAtoZ,
          ),
          child: const Text('Alphabetic (A to Z)'),
          onPressed: () => _setOrdering(model, .alphabeticAtoZ),
        ),
        MenuItemButton(
          leadingIcon: _buildCheckmarkIf(
            filters.sorting == Sort.alphabetricZtoA,
          ),
          child: const Text('Alphabetic (Z to A)'),
          onPressed: () => _setOrdering(model, .alphabetricZtoA),
        ),
      ],
      child: _CustomFilterChip(
        leadingIcon: Icon(Icons.sort),
        tooltip: 'Sort by',
        label: switch (filters.sorting) {
          Sort.newestToOldest => 'Newest',
          Sort.oldestToNewest => 'Oldest',
          Sort.alphabeticAtoZ => 'A to Z',
          Sort.alphabetricZtoA => 'Z to A',
        },
      ),
    );
  }

  void _toggleStatus(ArticleListModel model, ArticleStatus status) {
    model.applyFilters(model.filters.copy()..toggleStatus(status));
  }

  Widget _buildStatusFilterChip(ArticleListModel model) {
    final filters = model.filters;

    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
          leadingIcon: _buildCheckmarkIf(
            filters.statuses.contains(ArticleStatus.unread),
          ),
          closeOnActivate: false,
          onPressed: () => _toggleStatus(model, .unread),
          child: const Text('New'),
        ),
        MenuItemButton(
          leadingIcon: _buildCheckmarkIf(
            filters.statuses.contains(ArticleStatus.read),
          ),
          closeOnActivate: false,
          onPressed: () => _toggleStatus(model, .read),
          child: const Text('Read'),
        ),
        MenuItemButton(
          leadingIcon: _buildCheckmarkIf(
            filters.statuses.contains(ArticleStatus.snoozed),
          ),
          closeOnActivate: false,
          onPressed: () => _toggleStatus(model, .snoozed),
          child: const Text('Snoozed'),
        ),
      ],
      child: _CustomFilterChip(
        leadingIcon: const Icon(Icons.filter_list),
        label: filters.statuses.isEmpty
            ? 'Status'
            : filters.statuses
                  .map(
                    (status) => switch (status) {
                      .unread => 'New',
                      .read => 'Read',
                      .snoozed => 'Snoozed',
                    },
                  )
                  .join(', '),
        tooltip: 'Filter by status',
        selected: filters.statuses.isNotEmpty,
      ),
    );
  }

  Widget _buildFeedFilterChip(ArticleListModel model, List<Feed> feeds) {
    return MenuAnchor(
      menuChildren: feeds
          .map(
            (feed) => MenuItemButton(
              leadingIcon: _buildCheckmarkIf(
                model.filters.feeds.contains(feed),
              ),
              onPressed: () {
                model.applyFilters(model.filters.copy()..toggleFeed(feed));
              },
              closeOnActivate: false,
              child: Text(feed.title),
            ),
          )
          .toList(),
      child: _CustomFilterChip(
        label: 'Feed',
        tooltip: 'Filter by parent feed',
        selected: model.filters.feeds.isNotEmpty,
        onDeleted: () => model.applyFilters(model.filters.copy()..inAnyFeed()),
      ),
    );
  }

  String _formatDateLabel(DateFilter filter) {
    final differentYears = DateTime.now().year != filter.date.year;

    final date = differentYears
        ? DateFormat.yMMMd().format(filter.date)
        : DateFormat.MMMd().format(filter.date);

    return switch (filter.kind) {
      .newerThan => 'Newer than $date',
      .olderThan => 'Older than $date',
    };
  }

  Widget _buildDateFilterChip(BuildContext context, ArticleListModel model) {
    return _CustomFilterChip(
      leadingIcon: const Icon(Icons.calendar_today),
      label: model.filters.dateFilter == null
          ? 'Date'
          : _formatDateLabel(model.filters.dateFilter!),
      tooltip: 'Filter by date',
      selected: model.filters.dateFilter != null,
      onPressed: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => DateFilterModalSheet(model),
      ),
      onDeleted: () =>
          model.applyFilters(model.filters.copy()..clearDateFilter()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ArticleListModel>();
    final feeds = context.watch<FeedListModel>().feeds;

    return SingleChildScrollView(
      scrollDirection: .horizontal,
      child: Row(
        spacing: 8.0,
        children: [
          // Padding around the sides of the list
          const SizedBox(width: 8),
          _buildOrderingChip(model),
          _buildStatusFilterChip(model),
          _buildFeedFilterChip(model, feeds),
          _buildDateFilterChip(context, model),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class DateFilterModalSheet extends StatefulWidget {
  /// Article list model to which the filters will be applied
  final ArticleListModel model;

  const DateFilterModalSheet(this.model, {super.key});

  @override
  State<DateFilterModalSheet> createState() => DateFilterModalSheetState();
}

class DateFilterModalSheetState extends State<DateFilterModalSheet> {
  late DateFilter filter;

  @override
  void initState() {
    super.initState();

    filter = widget.model.filters.dateFilter ?? DateFilter.olderThanNow();
  }

  void _applyFilters() {
    widget.model.applyFilters(widget.model.filters.copy()..filterDate(filter));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            const SizedBox(height: 24),

            Padding(
              padding: const .symmetric(horizontal: 24.0),
              child: Text(
                'Filter by Date',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),

            const SizedBox(height: 24),

            CalendarDatePicker(
              calendarDelegate: const GregorianCalendarDelegate(),
              initialDate: filter.date,
              firstDate: DateTime.fromMillisecondsSinceEpoch(0),
              lastDate: DateTime.now(),
              onDateChanged: (date) => setState(() {
                filter.date = date;
                _applyFilters();
              }),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const .fromLTRB(24, 0, 24, 16),
              child: SegmentedButton<DateFilterKind>(
                segments: [
                  ButtonSegment(
                    value: .newerThan,
                    icon: const Icon(Icons.arrow_upward),
                    label: const Text('Newer than'),
                  ),
                  ButtonSegment(
                    value: .olderThan,
                    icon: const Icon(Icons.arrow_downward),
                    label: const Text('Older than'),
                  ),
                ],
                selected: {filter.kind},
                onSelectionChanged: (newFilterKind) => setState(() {
                  filter.kind = newFilterKind.first;
                  _applyFilters();
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomFilterChip extends StatelessWidget {
  final Widget? leadingIcon;
  final String label;
  final String tooltip;
  final bool selected;
  final void Function()? onPressed;
  final void Function()? onDeleted;

  const _CustomFilterChip({
    required this.label,
    required this.tooltip,
    this.leadingIcon,
    this.onPressed,
    this.onDeleted,
    this.selected = false,
  });

  void _openMenu(BuildContext context) {
    final menu = MenuController.maybeOf(context)!;

    if (menu.isOpen) {
      menu.close();
    } else {
      menu.open();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      tooltip: tooltip,
      avatar: leadingIcon,
      showCheckmark: leadingIcon == null,
      deleteIcon: selected && onDeleted != null
          ? null
          : const Icon(Icons.arrow_drop_down),
      deleteButtonTooltipMessage: selected && onDeleted != null
          ? null
          : "Open Menu",
      onSelected: (_) => onPressed != null ? onPressed!() : _openMenu(context),
      onDeleted: () {
        if (selected && onDeleted != null) {
          onDeleted!();
        } else if (onPressed != null) {
          onPressed!();
        } else {
          _openMenu(context);
        }
      },
      selected: selected,
    );
  }
}
