import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jira_counter/data/network/entity/sprint_response.dart';
import 'package:jira_counter/utils/extensions.dart';
import 'package:widget_helper/widget_helper.dart';

import '../../../../config/themes.dart';
import '../../../components/buttons/ripple_button.dart';
import '../../../components/commons/flat_card.dart';
import '../provider/task_provider.dart';

class SprintSelectorDialog extends ConsumerWidget {
  const SprintSelectorDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigator = Navigator.of(context);
    final sprints = ref.watch(taskProvider).sprints;
    final selectedSprint = ref.watch(taskProvider).selectedSprint;
    final isWideScreen = context.isWideScreen;

    return Material(
      color: Themes.transparent,
      child: Center(
        child: FlatCard(
          border: Border.all(color: Themes.stroke),
          width: isWideScreen ? 300 : 80.wp,
          height: 70.hp,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Project",
                    style: Themes().blackBold16,
                  ),
                  RippleButton(
                    padding: EdgeInsets.zero,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.close_rounded,
                    ),
                  ),
                ],
              ).addAllMargin(18),
              Container(
                width: double.infinity,
                height: 1,
                color: Themes.stroke,
              ),
              ListView.builder(
                padding: const EdgeInsets.all(18),
                itemCount: sprints.length,
                itemBuilder: (context, index) {
                  Sprint sprint = sprints[index];

                  return RippleButton(
                    border: Border.all(
                        color: selectedSprint?.id == sprint.id
                            ? Themes.primary
                            : Colors.transparent),
                    onTap: () async {
                      ref.read(taskProvider).selectSprint(sprint);
                      navigator.pop();
                    },
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        sprint.name ?? "",
                        style: Themes().blackBold16,
                      ),
                    ),
                  );
                },
              ).addExpanded,
            ],
          ),
        ),
      ),
    );
  }
}
