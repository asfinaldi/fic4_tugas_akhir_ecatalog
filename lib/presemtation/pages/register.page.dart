import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platzi_fake_store_app/bloc/register/register_bloc.dart';
import 'package:platzi_fake_store_app/data/models/request/register_model.dart';
import 'package:platzi_fake_store_app/presemtation/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  static const String routeName = '/register-page';
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController? nameController;
  TextEditingController? emailController;
  TextEditingController? passwordController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    nameController!.dispose();
    emailController!.dispose();
    passwordController!.dispose();
    super.dispose();
  }

  String? validationInput() {
    if (nameController!.text.isEmpty ||
        emailController!.text.isEmpty ||
        passwordController!.text.isEmpty) {
      return 'name or email or password is empty';
    }
    if (emailController!.text.length < 4 ||
        passwordController!.text.length < 4) {
      return 'to short, minimum 4 charackter';
    }
    if (!emailController!.text.contains('@')) {
      return 'email no valid';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Catalog Platzi Store',
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
              height: 100.0,
              ),
              Image.asset(
                "assets/images/register.png",
                width: 150.0,
                height: 150.0,
                //fit: BoxFit.fill,
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                controller: nameController,
                style: const TextStyle(color: Colors.white),
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                controller: emailController,
                style: const TextStyle(color: Colors.white),
              ),
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                controller: passwordController,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(
                height: 15.0,
              ),
              BlocConsumer<RegisterBloc, RegisterState>(
                listener: (context, state) {
                  if (state is RegisterLoaded) {
                    nameController!.clear();
                    emailController!.clear();
                    passwordController!.clear();
                    //navigasi
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.blue,
                        content:
                            Text('succes register with id : ${state.model.id}')));
                    Navigator.pushNamed(context,LoginPage.routeName);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  }
                },
                builder: (context, state) {
                  if (state is RegisterLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ElevatedButton(
                    onPressed: () {
                      final message = validationInput();
                      if (message != null) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.blue,
                            content: Text(message),
                          )
                          ,
                        );
                        return;
                      }
                      final requestModel = RegisterModel(
                        name: nameController!.text,
                        email: emailController!.text,
                        password: passwordController!.text,
                      );
                      context
                          .read<RegisterBloc>()
                          .add(SaveRegisterEvent(request: requestModel));
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 16.0,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, LoginPage.routeName);
                },
                child: const Text(
                  'Sudah Punya akun ?',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
