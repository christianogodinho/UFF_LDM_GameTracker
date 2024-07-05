import 'package:flutter/material.dart';
import 'package:game_tracker/services/database_services.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});
  
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State(LoginPage) {

  final DatabaseService _databaseService = DatabaseService.instance;

  @override
  Widget build(Object context) {
    return Scaffold();
  }
}