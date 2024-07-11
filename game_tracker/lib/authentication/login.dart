import 'package:flutter/material.dart';
import 'package:game_tracker/authentication/sign_up.dart';
import 'package:game_tracker/jsonmodels/login_user_model.dart';
import 'package:game_tracker/jsonmodels/user_model.dart';
import 'package:game_tracker/services/sqlite.dart';

import '../pages/dashboard.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final email = TextEditingController();
  final password = TextEditingController();

  bool isObscured = true;
  bool successfullyLoged = true;
  bool isUser = false;

  final formKey = GlobalKey<FormState>();

  final db = DatabaseHelper();

  login() async {
    var response =
        await db.login(LoginUser(email: email.text, password: password.text));
    if (response.isNotEmpty) {
      if (!mounted) return;
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Dashboard(
                  user: response.isNotEmpty
                      ? Users.fromMap(response.first as Map<String, dynamic>)
                      : null)));
    } else {
      setState(() {
        successfullyLoged = false;
      });
    }
  }

  guestLogin() async {
    Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context)=> Dashboard( user: null)));    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 34, 21, 22),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Image.asset('images/logo.jpg'),
                    //E-mail
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color.fromARGB(255, 244, 242, 235)),
                      child: TextFormField(
                          controller: email,
                          validator: (value) {
                            if (value!.isEmpty && isUser) {
                              return "E-mail em branco";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            icon: Icon(Icons.alternate_email),
                            border: InputBorder.none,
                            label: Text("E-mail"),
                          )),
                    ),

                    //Password
                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color.fromARGB(255, 244, 242, 235)),
                      child: TextFormField(
                          controller: password,
                          obscureText: isObscured,
                          validator: (value) {
                            if (value!.isEmpty && isUser) {
                              return "Senha em branco";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              icon: const Icon(Icons.lock),
                              border: InputBorder.none,
                              label: const Text("Senha"),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isObscured = !isObscured;
                                  });
                                },
                                icon: Icon(isObscured
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ))),
                    ),

                    //Login
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width * .7,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color.fromARGB(255, 0, 191, 209)),
                      child: TextButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              //método de login
                              setState(() {
                                isUser = true;
                              });

                              login();
                            }
                          },
                          child: const Text(
                            'ENTRAR',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),

                    //Convidado
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width * .5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color.fromARGB(255, 0, 191, 209)),
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              isUser = false;
                            });
                            guestLogin();
                          },
                          child: const Text(
                            'ENTRAR COMO CONVIDADO',
                            style: TextStyle(color: Colors.white)
                            ,
                          )),
                    ),

                    //Registre-se
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Não possui uma conta?",
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                            onPressed: () {
                              //Navegar para SignUp page
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignUp()));
                            },
                            child: const Text(
                              "REGISTRE-SE",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 191, 209)),
                            ))
                      ],
                    ),

                    //Login error
                    !successfullyLoged
                        ? const Text(
                            'Nome de usuário ou senha incorreto, ou inexistente.',
                            style: TextStyle(color: Colors.red),
                          )
                        : const SizedBox()
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
