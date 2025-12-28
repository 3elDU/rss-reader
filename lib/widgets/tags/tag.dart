import 'package:flutter/material.dart';
import 'package:rss_reader/database/database.dart';

class TagChip extends StatelessWidget {
  final Tag tag;

  const TagChip(this.tag, {super.key});

  @override
  Widget build(BuildContext context) {
    final chip = Chip(
      avatar: Icon(
        tag.icon != null
            ? IconData(tag.icon!, fontFamily: 'MaterialIcons')
            : Icons.tag,
        color: Color(tag.foreground),
      ),
      label: Text(
        tag.title,
        style: TextStyle(color: Color(tag.foreground)),
        overflow: .ellipsis,
      ),
      side: BorderSide(color: Colors.transparent),
      color: WidgetStatePropertyAll(Color(tag.background)),
      visualDensity: VisualDensity.compact,
    );

    if (tag.description != null) {
      return Tooltip(
        message: tag.description!,
        constraints: BoxConstraints(maxWidth: 120),
        child: chip,
      );
    } else {
      return chip;
    }
  }
}
