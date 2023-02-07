import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses_app/modals/transaction.dart';

class TransactionList extends StatelessWidget {
  List<Transaction> transactionList;

  TransactionList({required this.transactionList});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
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
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text('\$${tx.amount.toStringAsFixed(2)}'),
                  ),
                ),
              ),
              title: Text(tx.title),
              subtitle: Text(DateFormat.yMMMd().format(tx.date)),
              trailing: IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
            ),
          );
        }),
        itemCount: transactionList.length,
      ),
    );
  }
}
