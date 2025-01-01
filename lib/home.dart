import 'package:expense_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic>? userData;
  Future<void> _userdata() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId != null) {
        final response =
           await supabase.from("tbl_userreg").select().eq('id', userId).single();
        setState(() {
          userData = response;
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
      body: Center(
        child: Text("Welcome $userData['user_name']"),
      ),
    );
  }
}
