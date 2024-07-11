import 'package:flutter/material.dart';
import 'package:game_tracker/authentication/login.dart';
import 'package:game_tracker/jsonmodels/user_model.dart';
import 'package:game_tracker/services/sqlite.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  bool isObscured = true;
  bool isObscured2 = true;
  bool successfullyRegistered = true;

  final db = DatabaseHelper();

  signup() async {
    var response = await db.signUp(Users(name:name.text, email:email.text, password: password.text));
    if(response != 0){
      if(!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const Login()));
    }else{
      setState(() {
        successfullyRegistered = !successfullyRegistered;
      });
    }
  }

  final formKey = GlobalKey<FormState>();

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
              
                  Image.asset('images/registro.jpg'),
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
                      controller: name,
                      validator: (value) {
                        if(value!.isEmpty){
                          return "Nome em branco";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        border: InputBorder.none,
                        label: Text("Nome"),
                        
                      )
                    ),
                  ),

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

                  //Confirmar Senha
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color.fromARGB(255, 244, 242, 235)
                    ),
                    child: TextFormField(
                      controller: confirmPassword,
                      obscureText: isObscured2,
                      validator: (value) {
                        if(value!.isEmpty){
                          return "Senha em branco";
                        }else if(password.text != confirmPassword.text){
                          return "As senhas não são iguais";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        icon: const Icon(Icons.lock),
                        border: InputBorder.none,
                        label: const Text("Confirme a senha"),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isObscured2 = !isObscured2;
                            });
                          }, 
                          icon: Icon(isObscured2
                              ? Icons.visibility 
                              : Icons.visibility_off),)
                      )
                    ),
                  ),
              
                  //Cadastrar
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
                          //método de cadastro
                          signup();

                        }
                      }, 
                      child: const Text(
                        'CADASTRAR', 
                        style: TextStyle(color: Colors.white),
                      )
                    ),
                  ),

                  //Already have account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Já possui uma conta?",
                        style: TextStyle(color: Colors.white),
                        ),
                      TextButton(onPressed: () {
                        //Navegar para Login page
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => const Login()));
                      }, 
                      child: const Text(
                        "ENTRAR",
                        style: TextStyle(color: Color.fromARGB(255, 0, 191, 209)),
                        )
                      )
                    ],
                  ),
                  
                  //Registration error
                  !successfullyRegistered
                    ? const Text(
                      'Usuário já cadastrado. Realize o login.',
                      style: TextStyle(color: Colors.red),
                    ): const SizedBox()
                ]
              )
            )
          )
        )
      )
    );
  }
}