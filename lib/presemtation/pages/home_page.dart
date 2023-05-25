import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platzi_fake_store_app/bloc/product/get_all_product/get_all_product_bloc.dart';
import 'package:platzi_fake_store_app/bloc/profile/profile_bloc.dart';
import 'package:platzi_fake_store_app/data/localsources/auth_local_storage.dart';
import 'package:platzi_fake_store_app/presemtation/pages/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<ProfileBloc>().add(GetProfileEvent());
    context.read<GetAllProductBloc>().add(DoGetAllProductEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Profile'),
        actions: [
          IconButton(
            onPressed: () async {
              await AuthLocalStorage().removeToken();
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const LoginPage();
                },
              ));
            },
            icon: const Icon(
              Icons.logout_outlined,
              size: 24.0,
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
      
                if (state is ProfileLoaded) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.profile.name ?? ''),
                      const SizedBox(
                        width: 20.0,
                      ),
                      Text(state.profile.email ?? ''),
                    ],
                  );
                }
                return const Text('No data');
              },
            ),
          ],
        ),
      ),
    );
  }
}
