import 'package:flutter/material.dart';
import 'package:platzi_fake_store_app/bloc/login/login_bloc.dart';
import 'package:platzi_fake_store_app/bloc/product/create_product/create_product_bloc.dart';
import 'package:platzi_fake_store_app/bloc/product/get_all_product/get_all_product_bloc.dart';
import 'package:platzi_fake_store_app/bloc/product/update_product/update_product_bloc.dart';
import 'package:platzi_fake_store_app/bloc/profile/profile_bloc.dart';
import 'package:platzi_fake_store_app/data/datasources/auth_datasources.dart';
import 'package:platzi_fake_store_app/data/datasources/product_datasources.dart';
import 'package:platzi_fake_store_app/presemtation/pages/home_page.dart';
import 'package:platzi_fake_store_app/presemtation/pages/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platzi_fake_store_app/presemtation/pages/register.page.dart';
import 'package:platzi_fake_store_app/presemtation/pages/splash_page.dart';
import 'bloc/register/register_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RegisterBloc(AuthDatasource()),
        ),
        BlocProvider(
          create: (context) => LoginBloc(AuthDatasource()),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(AuthDatasource()),
        ),
        BlocProvider(
          create: (context) => CreateProductBloc(ProductDatasources()),
        ),
        BlocProvider(
          create: (context) => GetAllProductBloc(ProductDatasources()),
        ),
        BlocProvider<UpdateProductBloc>(
          create: (context) => UpdateProductBloc(ProductDatasources()),
        ),
      ],
      child: MaterialApp(
        title: 'Platzi Catalog',
        debugShowCheckedModeBanner: false,
        initialRoute: SplashPage.routeName,
        routes: {
          LoginPage.routeName: (context) => const LoginPage(),
          RegisterPage.routeName: (context) => const RegisterPage(),
          HomePage.routeName: (context) => const HomePage(),
          SplashPage.routeName: (context) => const SplashPage(),
        },
        theme: ThemeData(
          appBarTheme: const AppBarTheme(color: Color(0xff13131E)),
          scaffoldBackgroundColor: Color(0xff13131E),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        //home: const SplashPage(),
      ),
    );
  }
}



