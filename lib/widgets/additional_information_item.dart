import 'package:flutter/material.dart';

class AdditionalInfomationItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const AdditionalInfomationItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 6),
        Icon(
          icon,
          size: 40,
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
