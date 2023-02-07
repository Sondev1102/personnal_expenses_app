import 'package:flutter/material.dart';
import 'package:personal_expenses_app/widgets/Chart/chart.dart';
import 'package:personal_expenses_app/widgets/transaction/transaction_list.dart';

import './modals/transaction.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Transaction> _userTransactions = [
    Transaction(
        id: '1', title: 'Macbook', amount: 1229.9999, date: DateTime.now()),
    Transaction(
        id: '2', title: 'New iphone', amount: 10.11, date: DateTime.now())
  ];

  void _showBottomModal(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return Container(
            height: 200,
            color: Colors.black,
            child: const Card(
              elevation: 5,
              child: Text("data"),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Personal Expenses"),
          actions: [
            IconButton(
              onPressed: () {
                showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 200,
                        color: Colors.amber,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Text('Modal BottomSheet'),
                              ElevatedButton(
                                child: const Text('Close BottomSheet'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
              icon: Icon(Icons.add),
            )
          ],
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            children: [
              IconButton(
                  onPressed: () {
                    showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 200,
                            color: Colors.amber,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Text('Modal BottomSheet'),
                                  ElevatedButton(
                                    child: const Text('Close BottomSheet'),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  icon: Icon(Icons.add)),
              Chart(),
              TransactionList(
                transactionList: _userTransactions,
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showBottomModal(context),
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
