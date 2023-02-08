import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function _addTx;

  NewTransaction(this._addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  var _showDateValidation = false;

  var _selectedDate;

  void _handleShowDatePicker(context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now(),
    ).then((value) => setState(
          () {
            _selectedDate = value;
          },
        ));
  }

  void _handleAddTransaction(context) {
    if (_selectedDate == null) {
      setState(() {
        _showDateValidation = true;
      });
    }
    if (_formKey.currentState!.validate()) {
      final titleTx = _titleController.text;
      final amountTx = _amountController.text;
      final dateTx = _selectedDate;

      if (titleTx == null || amountTx == null || dateTx == null) {
        return;
      }
      widget._addTx(
          _titleController.text,
          double.parse(
            _amountController.text,
          ),
          _selectedDate);
      Navigator.pop(context);
      setState(() {
        _showDateValidation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                ),
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your amount';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                onFieldSubmitted: (_) => _handleAddTransaction(context),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 6, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDate != null
                          ? DateFormat.yMMMMEEEEd().format(_selectedDate)
                          : 'No Date Chosen!',
                      style: TextStyle(
                          color: _showDateValidation && _selectedDate == null
                              ? Colors.redAccent
                              : Colors.grey),
                    ),
                    TextButton(
                      onPressed: () => _handleShowDatePicker(context),
                      child: const Text('Choose Date'),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => _handleAddTransaction(context),
                child: const Text('Add Transaction'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
