import 'package:care_sync/src/component/text/bodyText.dart';
import 'package:care_sync/src/component/text/errorText.dart';
import 'package:care_sync/src/component/text/primaryText.dart';
import 'package:care_sync/src/component/text/subText.dart';
import 'package:flutter/material.dart';

class DuplicateWarningBanner extends StatelessWidget {
  final bool isDuplicate;

  const DuplicateWarningBanner({
    super.key,
    required this.isDuplicate,
  });

  @override
  Widget build(BuildContext context) {
    if (!isDuplicate) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFCC80), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.content_copy,
                  color: Color(0xFFE65100), size: 22),
              const SizedBox(width: 8),
              Text(
                'DUPLICATE FOUND',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: const Color(0xFFE65100),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Based on analysis, a nearly identical document exists.',
            textAlign: TextAlign.center,
            style: TextStyle(
              height: 1,
              letterSpacing: 0.5,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
