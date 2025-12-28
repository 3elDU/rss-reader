import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/database/database.dart';
import 'package:rss_reader/repositories/tag.dart';
import 'package:rss_reader/sheets/color_picker.dart';
import 'package:rss_reader/sheets/icon_picker.dart';
import 'package:rss_reader/widgets/action_item.dart';
import 'package:rss_reader/widgets/tags/tag.dart';

class TagsPage extends StatefulWidget {
  const TagsPage._();

  static void open(BuildContext context, {Key? key}) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => TagsPage._()));
  }

  @override
  State<TagsPage> createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> {
  late Future<List<Tag>> _tagFuture;

  void refresh() {
    final repo = context.read<TagRepository>();
    final future = repo.all();

    setState(() {
      _tagFuture = future;
    });
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void _addNewTag() async {
    final tagsRepo = context.read<TagRepository>();

    final tag = await _AddOrEditTagPage.open(context);
    if (tag == null) return;

    await tagsRepo.save(tag);
    refresh();
  }

  void _editTag(BuildContext context, Tag tag) async {
    final repo = context.read<TagRepository>();

    final edited = await _AddOrEditTagPage.open(
      context,
      tag: tag,
      onDelete: () async {
        await repo.delete(tag);
        refresh();
      },
    );

    if (edited == null) return;

    await repo.update(edited);
    refresh();
  }

  Widget _buildEmptyList() {
    return Padding(
      padding: const .symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: .center,
        spacing: 24,
        children: [
          Text(
            'No tags yet',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            'Tags can be used to categorize articles. Feeds can be automatically assigned to one or more tags, or you can assign tags to individual articles.',
            textAlign: .center,
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<Tag> tags) {
    return ListView.builder(
      itemBuilder: (_, index) => Material(
        child: InkWell(
          onTap: () => _editTag(context, tags[index]),
          child: SizedBox(
            height: 64,
            child: Padding(
              padding: const .symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                crossAxisAlignment: .center,
                spacing: 16,
                children: [
                  TagChip(tags[index]),

                  if (tags[index].description != null)
                    Expanded(
                      child: Text(
                        tags[index].description!,
                        overflow: .ellipsis,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      itemCount: tags.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tags')),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add new tag',
        onPressed: () => _addNewTag(),
        child: Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: _tagFuture,
        builder: (_, snapshot) => switch (snapshot.connectionState) {
          .done =>
            snapshot.data!.isEmpty
                ? _buildEmptyList()
                : _buildList(snapshot.data!),
          _ => SizedBox.expand(),
        },
      ),
    );
  }
}

class _AddOrEditTagPage extends StatefulWidget {
  final Tag? tag;
  final void Function()? onDelete;

  const _AddOrEditTagPage._({required this.tag, this.onDelete});

  static Future<TagsCompanion?> open(
    BuildContext context, {
    Tag? tag,
    void Function()? onDelete,
  }) {
    return Navigator.of(context).push<TagsCompanion>(
      MaterialPageRoute(
        builder: (_) => _AddOrEditTagPage._(tag: tag, onDelete: onDelete),
      ),
    );
  }

  @override
  State<_AddOrEditTagPage> createState() => _AddOrEditTagPageState();
}

class _AddOrEditTagPageState extends State<_AddOrEditTagPage> {
  late Color background;
  late Color foreground;
  late IconData? icon;

  late TextEditingController titleController;
  late TextEditingController descriptionController;

  (Color, Color) _randomBackgroundForeground() {
    final pairs = [
      (Colors.black, Colors.white),
      (Colors.white, Colors.black),
      (Colors.red, Colors.white),
      (Colors.purple, Colors.white),
      (Colors.indigo, Colors.white),
      (Colors.blue, Colors.white),
      (Colors.lightBlue, Colors.white),
      (Colors.cyan, Colors.white),
      (Colors.teal, Colors.white),
      (Colors.green, Colors.white),
      (Colors.lightGreen, Colors.white),
      (Colors.lime, Colors.black),
      (Colors.yellow, Colors.black),
      (Colors.amber, Colors.black),
      (Colors.orange, Colors.white),
    ];

    pairs.shuffle();

    return pairs.first;
  }

  @override
  void initState() {
    super.initState();

    // Pick initial random background+foreground pair
    final (randBackground, randForeground) = _randomBackgroundForeground();

    // Take values from existing tag if in edit mode
    titleController = TextEditingController(text: widget.tag?.title);
    descriptionController = TextEditingController(
      text: widget.tag?.description,
    );
    background = widget.tag != null
        ? Color(widget.tag!.background)
        : randBackground;
    foreground = widget.tag != null
        ? Color(widget.tag!.foreground)
        : randForeground;
    icon = widget.tag?.icon != null ? IconData(widget.tag!.icon!) : null;
  }

  void _onSave(BuildContext context) {
    Navigator.pop<TagsCompanion>(
      context,
      TagsCompanion.insert(
        id: widget.tag != null ? Value(widget.tag!.id) : Value.absent(),
        title: titleController.text,
        description: descriptionController.text.isNotEmpty
            ? Value(descriptionController.text)
            : Value.absent(),
        background: background.toARGB32(),
        foreground: foreground.toARGB32(),
      ),
    );
  }

  // Prompt the user first if they really want to delete
  void _onDelete() async {
    final count = await context.read<TagRepository>().countArticles(
      widget.tag!,
    );

    if (!mounted) return;

    final deleted = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete ${widget.tag!.title}?'),
        content: Text(
          Intl.plural(
            count,
            zero: 'This tag is assigned to one article',
            two: 'This tag is assigned to two articles',
            other: 'This tag is assigned to $count articles',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Close the dialog and do nothing
              Navigator.of(context).pop(false);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              widget.onDelete!();
              Navigator.of(context).pop(true);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (deleted == true && mounted) {
      // Also show the tag page if tag was deleted
      Navigator.of(context).pop();
    }
  }

  Widget _buildColorInput(
    Color color, {
    required bool foreground,
    required void Function(Color) onSelectColor,
  }) {
    return ActionItem(
      icon: SizedBox(
        width: 32,
        height: 32,
        child: Material(
          elevation: 0.5,
          color: color,
          borderRadius: .circular(16),
          clipBehavior: .hardEdge,
          child: ColoredBox(color: color),
        ),
      ),
      title: foreground ? 'Foreground' : 'Background',
      description:
          '#${(color.toARGB32() & 0xffffff).toRadixString(16).padRight(6, '0')}',
      onTap: () async {
        final color = await ColorPickerBottomSheet().pick(context);

        if (color == null) return;
        onSelectColor(color);
      },
    );
  }

  Widget _buildIconInput(BuildContext context) {
    return ActionItem(
      icon: Icon(icon != null ? icon! : Icons.tag),
      title: 'Icon',
      onTap: () async {
        final icon = await IconPickerBottomSheet().pick(context);

        if (icon == null) return;

        setState(() {
          this.icon = icon;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tag != null ? 'Edit tag' : 'Add new tag'),
        actions: [
          if (widget.tag != null && widget.onDelete != null)
            IconButton(
              icon: Icon(Icons.delete_outline),
              tooltip: 'Delete',
              onPressed: _onDelete,
            ),
          IconButton(
            icon: Icon(Icons.check),
            tooltip: 'Save',
            onPressed: () => _onSave(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: .all(16),
        child: Column(
          spacing: 16,
          children: [
            SizedBox(
              height: 160,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).colorScheme.surfaceContainer,
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: .topLeft,
                      child: Padding(
                        padding: const .fromLTRB(12, 12, 0, 0),
                        child: Text(
                          'Preview',
                          style: Theme.of(context).textTheme.titleSmall!
                              .copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withAlpha(128),
                              ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: TagChip(
                          Tag(
                            id: 0,
                            createdAt: DateTime.now(),
                            title: titleController.text.isNotEmpty
                                ? titleController.text
                                : 'Title',
                            description: descriptionController.text,
                            icon: icon?.codePoint,
                            background: background.toARGB32(),
                            foreground: foreground.toARGB32(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name (required)',
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
              ),
              maxLines: 2,
            ),
            _buildColorInput(
              background,
              foreground: false,
              onSelectColor: (Color color) => setState(() {
                background = color;
              }),
            ),
            _buildColorInput(
              foreground,
              foreground: true,
              onSelectColor: (Color color) => setState(() {
                foreground = color;
              }),
            ),
            _buildIconInput(context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
