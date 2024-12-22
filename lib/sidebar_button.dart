import 'package:flutter/material.dart';

class SidebarButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const SidebarButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        color: isSelected ? Colors.grey[800] : Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
