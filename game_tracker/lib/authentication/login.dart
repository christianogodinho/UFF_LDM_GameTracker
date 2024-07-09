import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:game_tracker/authentication/sign_up.dart';
import 'package:game_tracker/jsonmodels/login_user_model.dart';
import 'package:game_tracker/jsonmodels/user_model.dart';
import 'package:game_tracker/services/sqlite.dart';
import 'package:game_tracker/views/home.dart';

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

  final formKey = GlobalKey<FormState>();

  final db = DatabaseHelper();

  login() async {
    var response = await db.login(LoginUser(email: email.text, password: password.text));
    if(response == true){
      if(!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const Home()));
    }else{
      setState(() {
        successfullyLoged = !successfullyLoged;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255,34, 21, 22),
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
                  const SizedBox(height: 15,),
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color.fromARGB(255, 244, 242, 235)
                    ),
                    child: TextFormField(
                      controller: email,
                      validator: (value) {
                        if(value!.isEmpty){
                          return "E-mail em branco";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.alternate_email),
                        border: InputBorder.none,
                        label: Text("E-mail"),
                        
                      )
                    ),
                  ),
              
                  //Password
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color.fromARGB(255, 244, 242, 235)
                    ),
                    child: TextFormField(
                      controller: password,
                      obscureText: isObscured,
                      validator: (value) {
                        if(value!.isEmpty){
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
                              : Icons.visibility_off),)
                      )
                    ),
                  ),
              
                  //Login
                  const SizedBox(height: 15,),
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width * .7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color.fromARGB(255, 0, 191, 209)
                    ),
                    child: TextButton(
                      onPressed: () {
                        if(formKey.currentState!.validate()){
                          //método de login
                          login();
                        }
                      }, 
                      child: const Text(
                        'ENTRAR', 
                        style: TextStyle(color: Colors.white),
                      )
                    ),
                  ),
              
                  //Registre-se
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Não possui uma conta?",
                        style: TextStyle(color: Colors.white),
                        ),
                      TextButton(onPressed: () {
                        //Navegar para SignUp page
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => const SignUp()));
                      }, 
                      child: const Text(
                        "REGISTRE-SE",
                        style: TextStyle(color: Color.fromARGB(255, 0, 191, 209)),
                        )
                      )
                    ],
                  ),

                  //Login error
                  !successfullyLoged
                    ? const Text(
                      'Nome de usuário ou senha incorreto, ou inexistente.',
                      style: TextStyle(color: Colors.red),
                    ): const SizedBox()
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}