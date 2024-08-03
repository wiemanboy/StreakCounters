import 'package:flutter/material.dart';
import 'package:streak_counters/models/streak.dart';
import 'package:streak_counters/services/objectbox_helper.dart';
import 'package:streak_counters/widgets/popup/form/delete_form.dart';
import 'package:streak_counters/widgets/popup/form/streak_edit_form.dart';
import 'package:streak_counters/widgets/popup/options/edit_delete_options.dart';

class StreakCounter extends StatefulWidget {
  final Streak streak;
  final ObjectBoxHelper objectBox;
  final VoidCallback onUpdate;

  StreakCounter({
    Key? key,
    required this.streak,
    required this.objectBox,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _StreakCounterState createState() => _StreakCounterState();
}

class _StreakCounterState extends State<StreakCounter> {
  late int streakValue;

  @override
  void initState() {
    super.initState();
    streakValue = widget.streak.getStreakLength();
  }

  void completeCounter() {
    setState(() {
      widget.streak.completeToday();
      widget.objectBox.updateStreak(widget.streak);
      updateStreakValue();
    });
    widget.onUpdate();
  }

  void showEditForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StreakEditForm(
          streak: widget.streak,
          onSave: updateStreakName,
        );
      },
    );
  }

  void showDeleteForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteForm(
          itemName: widget.streak.name,
          onConfirm: deleteStreak,
        );
      },
    );
  }

  void updateStreakValue() {
    setState(() {
      streakValue = widget.streak.getStreakLength();
    });
  }

  void updateStreakName(String name) {
    setState(() {
      widget.streak.name = name;
      widget.objectBox.updateStreak(widget.streak);
    });
  }

  void deleteStreak() {
    widget.objectBox.removeStreak(widget.streak.id);
    widget.onUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => showModalBottomSheet(
        context: context,
        builder: (context) {
          return EditDeleteOptions(
            onEdit: showEditForm,
            onDelete: showDeleteForm,
          );
        },
      ),
      child: Card(
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.streak.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      widget.objectBox.updateStreak(widget.streak);
                      setState(() {
                        streakValue = widget.streak.getStreakLength();
                      });
                      widget.onUpdate();
                    },
                    tooltip: 'See calendar',
                    icon: Icon(Icons.calendar_month),
                  ),
                  Spacer(),
                  Text(
                    '$streakValue',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: completeCounter,
                    tooltip: 'Complete today',
                    icon: Icon(Icons.check),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
