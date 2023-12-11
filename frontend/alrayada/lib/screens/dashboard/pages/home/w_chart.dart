import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/monthly_total/m_monthly_total.dart';

import '/screens/dashboard/pages/categories/m_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme_data.dart';
import '../../../../providers/p_settings.dart';

class ChartList extends ConsumerWidget {
  const ChartList({Key? key, required this.monthlyTotals}) : super(key: key);

  final List<MonthlyTotal> monthlyTotals;

  double get totalSpending => monthlyTotals.fold(
      0.0, (previousValue, element) => previousValue + element.total);

  double getSpendingPercentageOfTotal(double amount) {
    if (amount == 0) return 0; // to prevent divide by 0 which will crash
    return amount / totalSpending;
  }

  List<ChartItem> getCharts(SettingsData settingsData) {
    final now = DateTime.now();
    return List.generate(
      12,
      (index) {
        // don't use now.month since if the day is 30 it will cause a bug to the month and duplicate it
        final date = DateTime(
          now.year,
          now.month - index,
          1,
        );
        var amount = 0.0;
        try {
          final monthlyTotal = monthlyTotals
              .firstWhere((element) => element.month == date.month);
          amount = monthlyTotal.total;
        } catch (e) {
          // Do nothing
        }
        final text = settingsData.useMonthNumberInChart
            ? date.month.toString()
            : DateFormat.MMMM().format(date).substring(0, 3);
        return ChartItem(
          amount: amount,
          text: text,
          percentage: getSpendingPercentageOfTotal(amount),
        );
      },
    ).reversed.toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsData = ref.watch(SettingsNotifier.settingsProvider);
    final charts = getCharts(settingsData);
    return Card(
      color: isCupertino(context)
          ? CupertinoTheme.of(context).barBackgroundColor
          : null,
      elevation: 6,
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final nonScrollable = Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: charts
                  .map(
                    (item) => Expanded(
                      child: ChartBar(
                        chart: item,
                      ),
                    ),
                  )
                  .toList(),
            );
            final scrollable = ListView(
              scrollDirection: Axis.horizontal,
              children: charts
                  .map((item) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChartBar(
                          chart: item,
                        ),
                      ))
                  .toList(),
            );
            if (settingsData.forceUseScrollableChart) {
              return scrollable;
            }
            if (constraints.maxWidth >= 345) {
              return nonScrollable;
            }
            // TODO("Improve chart")
            // See if the month number in smaller devices are good
            if (settingsData.useMonthNumberInChart) {
              return nonScrollable;
            }
            // scrollable
            return scrollable;
          },
        ),
      ),
    );
  }
}

class ChartBar extends StatelessWidget {
  const ChartBar({Key? key, required this.chart}) : super(key: key);
  final ChartItem chart;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          SizedBox(
            height: constraints.maxHeight * (0.195),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '\$${chart.amount.toStringAsFixed(0)}',
                style: MyAppTheme.getNormalTextStyle(context),
              ),
            ),
          ),
          SizedBox(height: constraints.maxHeight * 0.02),
          SizedBox(
            height: constraints.maxHeight * 0.6,
            width: 10,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: chart.percentage,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isCupertino(context)
                          ? CupertinoTheme.of(context).primaryColor
                          : Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.025,
          ),
          // const SizedBox(height: 4),
          SizedBox(
            height: constraints.maxHeight * 0.16,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                chart.text,
                style: MyAppTheme.getNormalTextStyle(context),
                maxLines: 1,
                semanticsLabel: chart.text,
              ),
            ),
          ),
        ],
      );
    });
  }
}
