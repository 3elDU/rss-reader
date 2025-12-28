import 'package:flutter/material.dart';
import 'package:rss_reader/sheets/picker.dart';

class ColorPickerBottomSheet extends PickerBottomSheet<Color> {
  final List<Color> availableColors = [
    Colors.white,
    Color.fromRGBO(224, 224, 224, 1.0),
    Color.fromRGBO(189, 189, 189, 1.0),
    Color.fromRGBO(158, 158, 158, 1.0),
    Color.fromRGBO(140, 140, 140, 1.0),
    Color.fromRGBO(117, 117, 117, 1.0),
    Color.fromRGBO(34, 34, 34, 1.0),
    Colors.black,
    ...Colors.primaries,
  ];

  ColorPickerBottomSheet({super.key}) : super('Pick a Color');

  @override
  Widget build(BuildContext context) {
    final diameter = 48.0;
    final radius = BorderRadius.circular(diameter / 2);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: availableColors
          .map(
            (color) => SizedBox(
              width: diameter,
              height: diameter,
              child: Material(
                color: color,
                borderRadius: radius,
                child: InkWell(
                  borderRadius: radius,
                  onTap: () {
                    Navigator.pop<Color>(context, color);
                  },
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
