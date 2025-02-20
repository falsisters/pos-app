import 'package:flutter/material.dart';

class NavigationItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;

  const NavigationItem({
    super.key,
    required this.icon,
    required this.label,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected:
          index == 0, // You might want to pass the selected state as a prop
      onTap: () {
        // Handle navigation here or pass a callback
      },
    );
  }
}
