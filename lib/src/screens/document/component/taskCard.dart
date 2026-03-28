import 'package:care_sync/src/component/badge/simpleBadge.dart';
import 'package:care_sync/src/component/text/primaryText.dart';
import 'package:care_sync/src/component/text/subText.dart';
import 'package:care_sync/src/models/task/uploadTask.dart';
import 'package:care_sync/src/screens/document/taskInfoScreen.dart';
import 'package:care_sync/src/utils/textFormatUtils.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final BuildContext context;
  final UploadTask task;
  final bool selectedMode;
  final bool fullAccess;
  final int? patientId;

  const TaskCard({
    super.key,
    required this.task,
    this.selectedMode = false,
    required this.context,
    required this.fullAccess,
    required this.patientId,
  });

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        return Colors.green;
      case 'PROCESSING':
        return Colors.orange;
      case 'FAILED':
      case 'ERROR':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _handleTap() {
    if (!selectedMode) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TaskInfoScreen(
            fullAccess: fullAccess,
            taskId: task.id,
            patientId: patientId,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.onPrimary,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: _getStatusColor(task.status).withAlpha(50),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: _handleTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              _buildStatusIcon(task.status, context),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryText(
                      text: TextFormatUtils.displayFileName(task.fileName),
                      singleLine: true,
                    ),
                    const SizedBox(height: 6),
                    SubText(text: task.createdBy),
                    const SizedBox(height: 6),
                    SimpleBadge(
                      color: _getStatusColor(task.status),
                      child: Text(
                        TextFormatUtils.formatName(task.status),
                        style: TextStyle(
                          color: _getStatusColor(task.status),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Status Badge
            ],
          ),
        ),
      ),
    );
  }

  Icon _buildStatusIcon(String status, BuildContext context) {
    IconData iconData;
    Color color;

    switch (status.toUpperCase()) {
      case 'COMPLETED':
        iconData = Icons.check_circle;
        color = Colors.green;
        break;
      case 'PROCESSING':
        iconData = Icons.autorenew; // spinning/process icon
        color = Colors.orange;
        break;
      case 'FAILED':
      case 'ERROR':
        iconData = Icons.error;
        color = Colors.red;
        break;
      default:
        iconData = Icons.upload_file;
        color = Theme.of(context).colorScheme.primary;
        break;
    }

    return Icon(iconData, size: 32, color: color);
  }
}
