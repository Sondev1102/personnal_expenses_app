import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal_expenses_app/widgets/Chart/chart.dart';
import 'package:personal_expenses_app/widgets/transaction/new_transaction.dart';
import 'package:personal_expenses_app/widgets/transaction/transaction_list.dart';

import './modals/transaction.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
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

  bool _isShowChart = false;

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
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text("Personal Expenses"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: const Icon(CupertinoIcons.add),
                  onTap: () => _showBottomModal(context),
                )
              ],
            ),
          )
        : AppBar(
            title: const Text("Personal Expenses"),
            actions: [
              IconButton(
                onPressed: () => _showBottomModal(context),
                icon: Icon(Icons.add),
              )
            ],
          );

    final containerHeight = mediaQuery.size.height -
        (appBar as PreferredSizeWidget).preferredSize.height -
        mediaQuery.viewPadding.top;

    final chart = SizedBox(
      height: isLandscape ? containerHeight * 0.7 : containerHeight * 0.3,
      child: Chart(_recentTransactions),
    );

    final transactionList = SizedBox(
      height: containerHeight * 0.7,
      child: TransactionList(
        transactionList: _userTransactions,
        removeTransaction: _handleRemoveTransaction,
      ),
    );

    final switchAdapter = Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(children: [
        Text(
          'Show Chart:',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        Platform.isIOS
            ? CupertinoSwitch(
                activeColor: Theme.of(context).primaryColor,
                value: _isShowChart,
                onChanged: (value) {
                  setState(() {
                    _isShowChart = value;
                  });
                },
              )
            : Switch.adaptive(
                value: _isShowChart,
                onChanged: (value) {
                  setState(() {
                    _isShowChart = value;
                  });
                })
      ]),
    );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandscape) switchAdapter,
            if (!isLandscape) chart,
            if (isLandscape && _isShowChart) chart,
            transactionList
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar as ObstructingPreferredSizeWidget,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showBottomModal(context),
              child: Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
