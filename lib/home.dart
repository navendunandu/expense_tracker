import 'package:expense_tracker/add_expense.dart';
import 'package:expense_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String name = "Loading...";

  Future<void> _userdata() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId != null) {
        final response =
           await supabase.from("tbl_userreg").select().eq('id', userId).single();
        setState(() {
          name = response['user_name'];
        });
      }
    } catch (e) {
      print("Error feching data:$e");
    }
  }

  @override
  void initState() {
   
    super.initState();
    _userdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense Tracker"),
        actions: [
          TextButton.icon(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddExpense(),));
          }, label: Text("Add Expense"), icon: Icon(Icons.add),)
        ],
      ),
      body: Center(
        child: Text("Welcome $name "),
      ),
    );
  }
}
