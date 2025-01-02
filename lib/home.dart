import 'package:flutter/material.dart';
import 'package:expense_tracker/add_expense.dart';
import 'package:expense_tracker/main.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name = "Loading...";

  Future<void> _fetchUserData() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId != null) {
        final response = await supabase
            .from("tbl_userreg")
            .select("user_name")
            .eq('id', userId)
            .single();
        setState(() {
          name = response['user_name'];
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Stream<List<Map<String, dynamic>>> _expenseStream() {
    final userId = supabase.auth.currentUser?.id;
    if (userId != null) {
      return supabase
          .from('tbl_expense')
          .stream(primaryKey: ['id'])
          .eq('user_id', userId)
          .map((data) => List<Map<String, dynamic>>.from(data));
    }
    return const Stream.empty();
  }

  double _calculateTotalToday(List<Map<String, dynamic>> expenses) {
    final today = DateTime.now();
    return expenses.fold(0.0, (sum, expense) {
      final DateTime expenseDate = DateTime.parse(expense['created_at']);
      if (expenseDate.year == today.year &&
          expenseDate.month == today.month &&
          expenseDate.day == today.day) {
        return sum + double.parse(expense['expense_amount'].toString());
      }
      return sum;
    });
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
                MaterialPageRoute(builder: (context) => const AddExpense()),
              );
            },
            label: const Text("Add Expense"),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            Text(
              "Welcome, $name!",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Expense Stream Builder
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: _expenseStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("Error loading expenses."));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No expenses found."));
                }

                final expenses = snapshot.data!;
                final totalToday = _calculateTotalToday(expenses);

                return Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
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
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  "\$${totalToday.toStringAsFixed(2)}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                          color:
                                              Theme.of(context).primaryColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Expense List
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: expenses.length,
                          itemBuilder: (context, index) {
                            final expense = expenses[index];
                            final DateTime expenseDate =
                                DateTime.parse(expense['created_at']);
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          expense['expense_name'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        Text(
                                          "${expenseDate.month}/${expenseDate.day}/${expenseDate.year}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "\$${double.parse(expense['expense_amount'].toString()).toStringAsFixed(2)}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor),
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
