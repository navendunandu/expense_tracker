import 'package:expense_tracker/login.dart';
import 'package:expense_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _contact = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _cpassword = TextEditingController();

  Future<void> _signup() async {
    if(_password.text==_cpassword.text){  
    try {

        final AuthResponse response = await supabase.auth
            .signUp(password: _password.text, email: _email.text);
          print(response);
        final String userId = response.user!.id;

        await supabase.from("tbl_userreg").insert({
          'id': userId,
          'user_name': _name.text,
          'user_email': _email.text,
          'user_contact': _contact.text   ,
          'user_password': _password.text
        });
        
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Your Account Created Successfully")));
      
    } catch (e) {
      print("Error While Registring :$e");
    }
    }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password Doesn't Match")));
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 43, 41, 41),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome ",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Create Your Account",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: _name,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text(
                    "Name",
                    style: TextStyle(color: Colors.white),
                  ),
                  hintText: "Enter Your Name",
                  hintStyle: TextStyle(color: Colors.white)),
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: _email,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Email", style: TextStyle(color: Colors.white)),
                  hintText: "Enter Your Email",
                  hintStyle: TextStyle(color: Colors.white)),
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: _contact,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Contact", style: TextStyle(color: Colors.white)),
                  hintText: "Enter Your Contact",
                  hintStyle: TextStyle(color: Colors.white)),
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: _password,
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label:
                      Text("Password", style: TextStyle(color: Colors.white)),
                  hintText: "Enter Your Password",
                  hintStyle: TextStyle(color: Colors.white)),
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              obscureText: true,
              controller: _cpassword,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Conform Password",
                      style: TextStyle(color: Colors.white)),
                  hintText: "Re-Enter Your Password",
                  hintStyle: TextStyle(color: Colors.white)),
            ),
            SizedBox(
              height: 15,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _signup();
                },
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text(
                    "Register",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.orange)),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginForm(),
                    ));
              },
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  "Already Have An Account?",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
