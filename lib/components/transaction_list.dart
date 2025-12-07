import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key, required this.transactions, required this.deleteTransaction});

  final List<Transaction> transactions;
  final void Function(String) deleteTransaction;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 430,
      child: transactions.isEmpty
          ? Column(
              children: <Widget>[
                SizedBox(height: 20),
                Text(
                  'Nenhuma transação cadastrada!',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 20),
                Image.asset(
                  'assets/img/waiting.png',
                  fit: BoxFit.cover,
                  height: 200,
                ),
              ],
            )
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (ctx, index) {
                final tr = transactions[index];
                return Card(
                  elevation: 5 ,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 5,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: FittedBox(
                          child: Text(
                            'R\$${tr.value.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      tr.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Text(
                      DateFormat('d MMM y').format(tr.date),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      color: Theme.of(context).colorScheme.error,
                      onPressed: () {
                        deleteTransaction(tr.id);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
