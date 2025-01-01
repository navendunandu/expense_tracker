import 'package:expense_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/add_expense.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name = "Loading...";
  double totalToday = 0.0;

  List<Map<String, dynamic>> expenses = [];

  Future<void> _userdata() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId != null) {
        final response = await supabase
            .from("tbl_userreg")
            .select()
            .eq('id', userId)
            .single();
        setState(() {
          name = response['user_name'];
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> fetchExpense() async {
    try {
      String userId = supabase.auth.currentUser!.id;
      final response =
          await supabase.from('tbl_expense').select().eq('user_id', userId);
      setState(() {
        expenses = List<Map<String, dynamic>>.from(response);
        // Calculate today's expenses
        totalToday = expenses.fold(0.0, (sum, expense) {
          DateTime expenseDate = DateTime.parse(expense['created_at']);
          DateTime today = DateTime.now();
          if (expenseDate.year == today.year &&
              expenseDate.month == today.month &&
              expenseDate.day == today.day) {
            return sum + double.parse(expense['expense_amount'].toString());
          }
          return sum;
        });
      });
    } catch (e) {
      print("Error fetching expense data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _userdata();
    fetchExpense();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddExpense()),
              );
            },
            label: const Text("Add Expense"),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome message
              Text(
                "Welcome, $name!",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              // Today's Expense Summary
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today's Total Expense:",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        "\$${totalToday.toStringAsFixed(2)}",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Expense List
              Text(
                "Expense List",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  DateTime expenseDate =
                      DateTime.parse(expenses[index]['created_at']);
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                expenses[index]['expense_name'],
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                "${expenseDate.month}/${expenseDate.day}/${expenseDate.year}",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          Text(
                            "\$${double.parse(expenses[index]['expense_amount'].toString()).toStringAsFixed(2)}",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
