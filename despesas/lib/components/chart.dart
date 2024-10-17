import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import 'chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  const Chart(this.recentTransactions, {super.key});

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      double totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        bool sameDay = recentTransactions[i].date.day == weekDay.day;
        bool sameMonth = recentTransactions[i].date.month == weekDay.month;
        bool sameYear = recentTransactions[i].date.year == weekDay.year;

        if (sameDay && sameMonth && sameYear) {
          totalSum += recentTransactions[i].value;
        }
      }

      // Exibe os dias da semana em português
      return {
        'day': capitalize(DateFormat.E('pt_BR').format(weekDay)[0]),
        'value': totalSum
      };
    });
  }

  double get _weekTotalValue {
    return groupedTransactions.fold(0.0, (sum, tr) {
      return sum + (tr['value'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactions.reversed.map((tr) {
            return Expanded(
              child: Column(
                children: [
                  ChartBar(
                    label: tr['day'].toString(),
                    value: tr['value'] as double,
                    percentage: _weekTotalValue == 0.0
                        ? 0.0
                        : (tr['value'] as double) / _weekTotalValue,
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
