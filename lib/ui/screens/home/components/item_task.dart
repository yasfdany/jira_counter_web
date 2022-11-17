import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jira_counter/r.dart';
import 'package:jira_counter/ui/screens/company/provider/company_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:widget_helper/widget_helper.dart';

import '../../../../config/themes.dart';
import '../../../components/buttons/ripple_button.dart';
import '../../../components/commons/flat_card.dart';

class ItemTask extends ConsumerWidget {
  ItemTask({
    Key? key,
    required this.issue,
  }) : super(key: key);

  final Map<String, dynamic> issue;
  final icons = {
    "Lowest": AssetIcons.lowest,
    "Low": AssetIcons.low,
    "Medium": AssetIcons.medium,
    "High": AssetIcons.high,
    "Highest": AssetIcons.highest,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RippleButton(
      onTap: () {
        final selectedCompany = ref.read(companyProvider).selectedCompany;
        launchUrlString(
          "${selectedCompany?.url}/browse/${issue["key"]}",
          mode: LaunchMode.externalApplication,
        );
      },
      border: Border.all(color: Themes.stroke),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${issue["fields"]?["summary"]}",
              style: Themes().blackBold14,
            ),
            Row(
              children: [
                Text(
                  "${issue["key"]}",
                  style: Themes().black12,
                ).addExpanded,
                FlatCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  color: Themes.stroke,
                  child: Text(
                    "${issue["fields"]?["customfield_10016"] ?? 0}",
                    style: Themes().black12,
                  ),
                ),
                Image.asset(
                  icons["${issue["fields"]?["priority"]?["name"]}"] ?? "",
                  width: 14,
                ).addMarginLeft(12),
              ],
            ).addMarginTop(12),
          ],
        ),
      ),
    );
  }
}
