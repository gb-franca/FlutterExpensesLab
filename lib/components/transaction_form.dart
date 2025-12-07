import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm(this.onSubmit, {super.key});
  final void Function(String, double, DateTime) onSubmit; // Updated signature

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleControler = TextEditingController();
  final _valueControler = TextEditingController();
  
  DateTime? _selectedDate; 

  void _submitForm() {
    final title = _titleControler.text;
    final value = double.tryParse(_valueControler.text) ?? 0.0;

    // 2. Added check for _selectedDate
    if (title.isEmpty || value <= 0 || _selectedDate == null) { 
      return;
    }
    
    // 3. Passed _selectedDate to onSubmit
    widget.onSubmit(title, value, _selectedDate!); 
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            // ... (Title and Value TextFields remain the same)
            TextField(
              controller: _titleControler,
              onSubmitted: (_) => _submitForm(),
              decoration: InputDecoration(labelText: 'Título'),
            ),
            TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              controller: _valueControler,
              onSubmitted: (_) => _submitForm(),
              decoration: InputDecoration(labelText: 'Valor (R\$)'),
            ),
            Container(
              height: 70,
              child: Row(
                children: <Widget>[
                  // 4. Corrected Text logic to handle null _selectedDate
                  Expanded( // Use Expanded to give the Text widget space
                    child: Text(
                      _selectedDate == null
                          ? 'Nenhuma data selecionada!' // Displays if date is null
                          : 'Data Selecionada: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}', // Uses ! to assert non-null
                    ),
                  ),
                  TextButton(
                    onPressed: _showDatePicker,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.purple,
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    child: Text(
                      'Selecionar Data',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.purple,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text('Nova Transação'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}