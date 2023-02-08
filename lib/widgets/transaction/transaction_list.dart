import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:personal_expenses_app/modals/transaction.dart';

class TransactionList extends StatelessWidget {
  List<Transaction> transactionList;
  Function removeTransaction;

  TransactionList(
      {required this.transactionList, required this.removeTransaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
        itemBuilder: ((context, index) {
          final tx = transactionList[index];
          return Card(
            elevation: 5,
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      '\$${tx.amount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                ),
              ),
              title: Text(
                tx.title,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              subtitle: Text(
                DateFormat.yMMMEd().format(tx.date),
                style: Theme.of(context).textTheme.labelSmall,
              ),
              trailing: IconButton(
                onPressed: () => removeTransaction(tx.id),
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          );
        }),
        itemCount: transactionList.length,
      ),
    );
  }
}
