import 'package:flutter/material.dart';
import 'package:personal_expenses_app/widgets/Chart/chart.dart';
import 'package:personal_expenses_app/widgets/transaction/new_transaction.dart';
import 'package:personal_expenses_app/widgets/transaction/transaction_list.dart';

import './modals/transaction.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Expenses',
      home: const Home(),
      theme: ThemeData(
        // brightness: Brightness.dark,
        primarySwatch: Colors.purple,
        fontFamily: 'Quicksand',
        textTheme: const TextTheme(
          labelLarge: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          displayMedium: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          displaySmall: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          labelMedium: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          labelSmall: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: Color.fromARGB(255, 90, 88, 88)),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Transaction> _userTransactions = [
    Transaction(
        id: '1', title: 'Macbook', amount: 1229.9999, date: DateTime.now()),
    Transaction(
        id: '2', title: 'New iphone', amount: 10.11, date: DateTime.now())
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions
        .where(
          (tx) => tx.date.isAfter(
            DateTime.now().subtract(
              const Duration(days: 7),
            ),
          ),
        )
        .toList();
  }

  void _addTransaction(String title, double amount, DateTime date) {
    setState(() {
      _userTransactions.add(
        Transaction(
            id: DateTime.now().toString(),
            title: title,
            amount: amount,
            date: date),
      );
    });
  }

  void _showBottomModal(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(_addTransaction);
        });
  }

  void _handleRemoveTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Personal Expenses"),
        actions: [
          IconButton(
            onPressed: () => _showBottomModal(context),
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Chart(_recentTransactions),
            TransactionList(
              transactionList: _userTransactions,
              removeTransaction: _handleRemoveTransaction,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBottomModal(context),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
