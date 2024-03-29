import 'package:flutter/material.dart';
import 'package:try2/tasks/task.dart';
import 'package:try2/theme.dart';

// ignore: must_be_immutable
class TaskTile extends StatelessWidget {
  TaskTile(this.task, {Key? key}) : super(key: key);

  Task task;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        width: 600,
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: _getBGClr(task.color)),
          child: Row(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title ?? '',
                      style: titleStyle.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey[200],
                          size: 18,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${task.startTime} - ${task.endTime}',
                          style: titleStyle.copyWith(
                            color: Colors.grey[100],
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      task.note ?? '',
                      style: titleStyle.copyWith(
                        color: Colors.grey[100],
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              )),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                height: 60,
                width: 0.5,
                color: Colors.grey[200]!.withOpacity(0.7),
              ),
              RotatedBox(
                quarterTurns: 1,
                child: Text(
                  task.isCompleted == 1 ? 'COMPLETED' : 'TODO',
                  style: titleStyle.copyWith(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBGClr(int? color) {
    switch (color) {
      case 1:
        return pinkClr;
      case 2:
        return orangeClr;
      case 3:
        return darkHeaderClr;

      default:
        return bluishClr;
    }
  }
}
