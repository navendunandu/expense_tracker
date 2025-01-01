import 'package:expense_tracker/main.dart';
import 'package:flutter/material.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final TextEditingController _expense = TextEditingController();
  final TextEditingController _amount = TextEditingController();

  Future<void> _expenseAdd() async {
    try {
      String userId = supabase.auth.currentUser!.id;
      await supabase.from("tbl_expense").insert({
        'user_id': userId,
        'expense_name': _expense.text,
        'expense_amount': int.parse(_amount.text),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Expense Added")),
      );
      Navigator.pop(context); // Return to the previous screen after adding
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong. Please try again!")),
      );
      print("Error adding expense: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Expense"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter your expense details",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),

              // Expense Name Input
              TextFormField(
                controller: _expense,
                decoration: InputDecoration(
                  labelText: "Expense",
                  hintText: "Enter expense name",
                  labelStyle: Theme.of(context).textTheme.bodyLarge,
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  fillColor: Theme.of(context).cardColor,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),

              // Expense Amount Input
              TextFormField(
                controller: _amount,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Amount",
                  hintText: "Enter expense amount",
                  labelStyle: Theme.of(context).textTheme.bodyLarge,
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  fillColor: Theme.of(context).cardColor,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 30),

              // Add Expense Button
              ElevatedButton(
                onPressed: _expenseAdd,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Add Expense",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
