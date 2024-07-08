import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final username = TextEditingController();
  final password = TextEditingController();

  bool isObscured = true;
  String path_to_logo = "logo.jpg";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255,34, 21, 22),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [

                Image.asset('images/logo.jpg'),
                //Username
                const SizedBox(height: 15,),
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color.fromARGB(255, 244, 242, 235)
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      border: InputBorder.none,
                      label: Text("Username"),
                      
                    )
                  ),
                ),

                //Password
                Container(
                  margin: EdgeInsets.all(10),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color.fromARGB(255, 244, 242, 235)
                  ),
                  child: TextFormField(
                    obscureText: isObscured,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock),
                      border: InputBorder.none,
                      label: Text("Password"),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isObscured = !isObscured;
                          });
                        }, 
                        icon: Icon(isObscured
                            ? Icons.visibility 
                            : Icons.visibility_off),)
                    )
                  ),
                ),

                const SizedBox(height: 15,),
                Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width * .7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color.fromARGB(255, 0, 191, 209)
                  ),
                  child: TextButton(
                    onPressed: () {}, 
                    child: const Text(
                      'LOGIN', 
                      style: TextStyle(color: Colors.white),
                    )
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}