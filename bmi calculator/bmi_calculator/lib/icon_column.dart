import 'package:flutter/material.dart';
import 'constant_file.dart';

class IconColumn extends StatelessWidget {
  const IconColumn({
    super.key,
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 50.0),
        const SizedBox(height: 10.0),
        Text(label, style: kLabelStyle),
      ],
    );
  }
}
