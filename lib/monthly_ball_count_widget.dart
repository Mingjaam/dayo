import 'package:flutter/material.dart';
import 'styles.dart';

class MonthlyBallCountWidget extends StatelessWidget {
  final Map<Color, int> ballCount;

  const MonthlyBallCountWidget({Key? key, required this.ballCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 볼 카운트를 내림차순으로 정렬
    final sortedEntries = ballCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppStyles.primaryColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: sortedEntries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: entry.key,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  '${entry.value}',
                  style: TextStyle(
                    fontFamily: AppStyles.fontFamily,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
