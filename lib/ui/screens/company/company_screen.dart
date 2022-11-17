import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jira_counter/router/router.dart';
import 'package:jira_counter/ui/components/commons/flat_card.dart';
import 'package:jira_counter/ui/screens/home/home_screen.dart';
import 'package:jira_counter/utils/extensions.dart';
import 'package:widget_helper/widget_helper.dart';

import '../../../config/themes.dart';
import '../../../main.dart';
import '../../components/buttons/ripple_button.dart';
import 'provider/company_provider.dart';

class CompanyScreen extends ConsumerWidget {
  static String get routeName => '/companies';
  const CompanyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    widthScreen = MediaQuery.of(context).size.width;
    heightScreen = MediaQuery.of(context).size.height;

    final companies = ref.watch(companyProvider).companies;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FlatCard(
          border: Border.all(color: Themes.stroke),
          width: context.isWideScreen ? 500 : 80.wp,
          height: 80.hp,
          child: Column(
            children: [
              Text(
                "Choose Company",
                style: Themes().blackBold16,
              ).addMarginTop(24),
              ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: companies.length,
                itemBuilder: (context, index) {
                  final company = companies[index];

                  return RippleButton(
                    border: Border.all(color: Themes.stroke),
                    onTap: () async {
                      await ref.read(companyProvider).selectCompany(company);
                      ref.read(routerProvider).replace(HomeScreen.routeName);
                    },
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            company.name ?? "",
                            style: Themes().blackBold18,
                          ),
                          Text(
                            company.url ?? "",
                            style: Themes().black14,
                          ),
                        ],
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
