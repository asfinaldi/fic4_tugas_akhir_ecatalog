import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platzi_fake_store_app/bloc/register/register_bloc.dart';
import 'package:platzi_fake_store_app/data/models/request/register_model.dart';

class RegisterPage extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
              controller: nameController,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              controller: emailController,
            ),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              controller: passwordController,
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
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text('succes register with id : ${state.model.id}')));
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
                    final requestModel = RegisterModel(
                      name: nameController!.text,
                      email: emailController!.text,
                      password: passwordController!.text,
                    );
                    context
                        .read<RegisterBloc>()
                        .add(SaveRegisterEvent(request: requestModel));
                  },
                  child: const Text('Register'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
