import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:personal_expenses_app/modals/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get recentTransactionsGroupByDate {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalOfDay = recentTransactions.fold(0.0,
          (prev, rtx) => prev += rtx.date.day == weekDay.day ? rtx.amount : 0);

      return {
        'title': DateFormat.E().format(weekDay),
        'totalOfDay': totalOfDay
      };
    }).reversed.toList();
  }

  double get totalOfWeek {
    return recentTransactions.fold(0.0, (prev, rtx) => prev += rtx.amount);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        margin: const EdgeInsets.only(left: 15, top: 10, right: 15),
        child: Card(
          elevation: 6,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: recentTransactionsGroupByDate
                  .map(
                    (day) => Flexible(
                      fit: FlexFit.tight,
                      child: Column(
                        children: [
                          Container(
                            height: constraints.maxHeight * 0.1,
                            child: FittedBox(
                              child: Text('\$' +
                                  (day['totalOfDay'] as double)
                                      .toStringAsFixed(0)),
                            ),
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.03,
                          ),
                          Container(
                            height: constraints.maxHeight * 0.54,
                            width: 10,
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1),
                                    color: const Color.fromARGB(
                                        255, 212, 209, 209),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                                FractionallySizedBox(
                                  heightFactor: totalOfWeek == 0
                                      ? 0
                                      : (day['totalOfDay'] as double) /
                                          totalOfWeek,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: constraints.maxHeight * 0.03),
                            height: constraints.maxHeight * 0.1,
                            child: Text(day['title'] as String),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      );
    });
  }
}
