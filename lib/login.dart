import 'package:expense_tracker/registration.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 43, 41, 41),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Form(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Welcome",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
            Text(
              "Sign in to Continue",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: _email,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text(
                    "Email",
                    style: TextStyle(color: Colors.white),
                  )),
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
                      Text("Password", style: TextStyle(color: Colors.white))),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  "Login",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.orange)),
            ),
            SizedBox(
              height: 15,
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Registration(),
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    "Create An Account?",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ))
          ],
        )),
      ),
    );
  }
}
