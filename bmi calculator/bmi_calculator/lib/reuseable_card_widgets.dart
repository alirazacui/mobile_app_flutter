import 'package:flutter/material.dart';

class ReuseableContainer extends StatelessWidget {
  const ReuseableContainer({
    super.key,
    required this.colorr,
    required this.cardWidget,
    this.onPress,
  });

  final Color colorr;
  final Widget cardWidget;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: colorr,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: cardWidget,
      ),
    );
  }
}
