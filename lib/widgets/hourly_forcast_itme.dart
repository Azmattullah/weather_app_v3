import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final String time;
  final String temperature;
  final IconData icon;
  const HourlyForecastItem(
      {super.key,
      required this.time,
      required this.temperature,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              time,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.visible,
            ),
            SizedBox(height: 6),
            Icon(
              icon,
              size: 40,
            ),
            SizedBox(height: 4),
            Text(
              '${temperature} K',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
