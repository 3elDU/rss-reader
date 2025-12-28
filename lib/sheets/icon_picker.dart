import 'package:flutter/material.dart';
import 'package:rss_reader/sheets/picker.dart';

class IconPickerBottomSheet extends PickerBottomSheet<IconData> {
  final List<IconData> availableIcons = [
    Icons.tag,
    Icons.favorite,
    Icons.check_box,
    Icons.download,
    Icons.bolt,
    Icons.sync,
    Icons.done,
    Icons.terminal,
    Icons.public,
    Icons.mic,
    Icons.music_note,
    Icons.movie,
    Icons.speed,
    Icons.video_library,
    Icons.equalizer,
    Icons.mail,
    Icons.chat,
    Icons.forum,
    Icons.inventory_2,
    Icons.hub,
    Icons.comment,
    Icons.person,
    Icons.group,
    Icons.groups,
    Icons.reviews,
    Icons.lan,
    Icons.sunny,
    Icons.mood,
    Icons.sentiment_neutral,
    Icons.sentiment_dissatisfied,
    Icons.health_and_safety,
    Icons.forest,
    Icons.rocket,
    Icons.sunny,
  ];

  IconPickerBottomSheet({super.key}) : super('Pick an Icon');

  @override
  Widget build(BuildContext context) {
    final diameter = 48.0;
    final radius = BorderRadius.circular(diameter / 2);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: availableIcons
          .map(
            (icon) => SizedBox(
              width: diameter,
              height: diameter,
              child: Material(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: radius,
                child: InkWell(
                  borderRadius: radius,
                  onTap: () {
                    Navigator.pop<IconData>(context, icon);
                  },
                  child: Icon(
                    icon,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
