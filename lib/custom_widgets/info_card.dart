import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final Object value;
  final Color textColor;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.textColor,
  });
  
  @override
  Widget build(BuildContext context) {
    
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value.toString(),
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}