import 'package:flutter/material.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final TextEditingController _expense=TextEditingController();
  final TextEditingController _amount=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Form(
            child: Column(
          children: [
            TextFormField(
              controller: _expense,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Expense"),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _amount,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Expense Amount"),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: () {}, child: Text("Add Expense"))
          ],
        )),
      ),
    );
  }
}
