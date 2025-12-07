import 'package:flutter/material.dart';

import './components/transaction_list.dart';
import './components/transaction_form.dart';
import './components/chart.dart';
import './models/transaction.dart';
import 'dart:math';

void main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  const ExpensesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData tema = ThemeData();

    return MaterialApp(
      theme: tema.copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          secondary: Colors.amber,
        ),

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.amber, // Cor de fundo do botão (Amarelo)
          foregroundColor:
              Colors.black, // Cor do ícone (Preto para dar contraste)
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [];

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addTransaction(String title, double value, DateTime date) { // <-- Added DateTime date
  final newTransaction = Transaction(
    id: Random().nextDouble().toString(),
    title: title,
    value: value,
    date: date, 
  );

  setState(() {
    _transactions.add(newTransaction);
  });
  Navigator.of(context).pop();
}

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }



  void _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(_addTransaction);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Despesas Pessoais'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _openTransactionFormModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Chart(recentTransactions: _recentTransactions),
            TransactionList(transactions: _transactions, deleteTransaction: _deleteTransaction),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _openTransactionFormModal(context),
      ),
    );
  }
}
