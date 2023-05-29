import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platzi_fake_store_app/bloc/login/login_bloc.dart';
import 'package:platzi_fake_store_app/data/localsources/auth_local_storage.dart';
import 'package:platzi_fake_store_app/data/models/request/login_model.dart';
import 'package:platzi_fake_store_app/presemtation/pages/home_page.dart';
import 'package:platzi_fake_store_app/presemtation/pages/register.page.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login-page';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController? emailController;
  TextEditingController? passwordController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    isLogin();
    Future.delayed(const Duration(seconds: 2));
  }

  void isLogin() async {
    final isTokenExist = await AuthLocalStorage().isTokenExist();
    if (isTokenExist) {
      Navigator.pushNamed(context, HomePage.routeName);
    }
  }

  @override
  void dispose() {
    emailController!.dispose();
    passwordController!.dispose();
    super.dispose();
  }

  String? validationInput() {
    if (emailController!.text.isEmpty || passwordController!.text.isEmpty) {
      return 'email or password is empty ';
    }
    if (emailController!.text.length < 4 ||
        passwordController!.text.length < 4) {
      return 'to short, minimum 4 characakter';
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/login.png",
                width: 150.0,
                height: 150.0,
                //fit: BoxFit.fill,
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
              BlocConsumer<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state is LoginLoaded) {
                    emailController!.clear();
                    passwordController!.clear();
                    //navigasi
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.blue,
                        content: Text('succes login')));
                    Navigator.pushNamed(context, HomePage.routeName);
                  } else if (state is LoginError) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          backgroundColor: Colors.blue,
                          content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is LoginLoading) {
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
                          ),
                        );
                        return;
                      }
                      if (formKey.currentState!.validate()) {
                        final requestModel = LoginModel(
                          email: emailController!.text,
                          password: passwordController!.text,
                        );
                        context
                            .read<LoginBloc>()
                            .add(DoLoginEvent(loginModel: requestModel));
                      }
                    },
                    child: const Text('Login'),
                  );
                },
              ),
              const SizedBox(
                height: 16.0,
              ),
              InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RegisterPage.routeName);
                  },
                  child: const Text(
                    'Belum Punya Akun ? Register',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

