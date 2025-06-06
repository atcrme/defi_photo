import 'package:flutter/material.dart';
import 'package:mon_stage_en_images/common/models/database.dart';
import 'package:mon_stage_en_images/common/models/enum.dart';
import 'package:mon_stage_en_images/common/models/section.dart';
import 'package:mon_stage_en_images/common/providers/all_answers.dart';
import 'package:mon_stage_en_images/common/providers/all_questions.dart';
import 'package:mon_stage_en_images/common/widgets/taking_action_notifier.dart';
import 'package:provider/provider.dart';

class MetierAppBar extends StatelessWidget {
  const MetierAppBar({
    super.key,
    required this.selected,
    required this.onPageChanged,
    this.studentId,
  });

  final int selected;
  final Function(int) onPageChanged;
  final String? studentId;

  @override
  Widget build(BuildContext context) {
    final questions = Provider.of<AllQuestions>(context, listen: false);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withAlpha(90),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(255 ~/ 2),
            spreadRadius: 5,
            blurRadius: 7,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _createMetierButton(context,
              sectionIndex: 0,
              questions: questions,
              isSelected: selected == 0,
              onPressed: () => onPageChanged(0)),
          _createMetierButton(context,
              sectionIndex: 1,
              questions: questions,
              isSelected: selected == 1,
              onPressed: () => onPageChanged(1)),
          _createMetierButton(context,
              sectionIndex: 2,
              questions: questions,
              isSelected: selected == 2,
              onPressed: () => onPageChanged(2)),
          _createMetierButton(context,
              sectionIndex: 3,
              questions: questions,
              isSelected: selected == 3,
              onPressed: () => onPageChanged(3)),
          _createMetierButton(context,
              sectionIndex: 4,
              questions: questions,
              isSelected: selected == 4,
              onPressed: () => onPageChanged(4)),
          _createMetierButton(context,
              sectionIndex: 5,
              questions: questions,
              isSelected: selected == 5,
              onPressed: () => onPageChanged(5)),
        ],
      ),
    );
  }

  Widget _createMetierButton(
    BuildContext context, {
    required AllQuestions questions,
    required int sectionIndex,
    required bool isSelected,
    required Function() onPressed,
  }) {
    final answers = Provider.of<AllAnswers>(context)
        .filter(
            questionIds:
                questions.fromSection(sectionIndex).toList().map((e) => e.id),
            studentIds: studentId == null ? null : [studentId!])
        .toList();

    final userType =
        Provider.of<Database>(context, listen: false).currentUser?.userType ??
            UserType.none;

    return TakingActionNotifier(
      left: 8,
      top: -7,
      number: AllAnswers.numberOfActionsRequiredFrom(answers, context) > 0
          ? 0
          : null,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width / Section.nbSections),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
              backgroundColor: isSelected
                  ? Theme.of(context).colorScheme.primary.withAlpha(100)
                  : null),
          child: Text(
            Section.letter(sectionIndex),
            style: TextStyle(
                fontSize: 16,
                color: userType == UserType.student
                    ? isSelected
                        ? Colors.white
                        : Colors.black
                    : Theme.of(context).colorScheme.onPrimary),
          ),
        ),
      ),
    );
  }
}
