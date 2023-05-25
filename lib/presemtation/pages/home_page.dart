import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platzi_fake_store_app/bloc/product/create_product/create_product_bloc.dart';
import 'package:platzi_fake_store_app/bloc/product/get_all_product/get_all_product_bloc.dart';
import 'package:platzi_fake_store_app/bloc/profile/profile_bloc.dart';
import 'package:platzi_fake_store_app/data/localsources/auth_local_storage.dart';
import 'package:platzi_fake_store_app/data/models/request/product_model.dart';
import 'package:platzi_fake_store_app/presemtation/pages/login_page.dart';

class HomePage extends StatefulWidget {
    static const String routeName = '/home-page';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController? titleontroller = TextEditingController();
  TextEditingController? descriptionController = TextEditingController();
  TextEditingController? priceController = TextEditingController();
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
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () async {
              await AuthLocalStorage().removeToken();
              Navigator.pushNamed(context, LoginPage.routeName);
            },
            icon: const Icon(
              Icons.logout_outlined,
              size: 30.0,
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
            Expanded(child: BlocBuilder<GetAllProductBloc, GetAllProductState>(
              builder: (context, state) {
                if (state is GetAllProductLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is GetAllProductLoaded) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final product =
                          state.listProduct.reversed.toList()[index];
                      // final product = state
                      //     .listProduct[state.listProduct.length - 1 - index];


                      return Card(
                        child: ListTile(
                          leading:
                              CircleAvatar(child: Text('${product.price}')),
                          title: Text(product.title ?? '-'),
                          subtitle:
                              Text(product.description ?? '-'),
                        ),
                      );
                    },
                  );
                }
                return const Text('No Product');
              },
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Add Product'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Title',
                      ),
                      controller: titleontroller,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Price',
                      ),
                      controller: priceController,
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Decription',
                      ),
                      controller: descriptionController,
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(
                    width: 4.0,
                  ),
                  BlocListener<CreateProductBloc, CreateProductState>(
                    listener: (context, state) {
                      if (state is CreateProductLoaded) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('${state.productResponseModel.id}')));
                        Navigator.pop(context);
                        context
                            .read<GetAllProductBloc>()
                            .add(DoGetAllProductEvent());
                      }
                    },
                    child: BlocBuilder<CreateProductBloc, CreateProductState>(
                      builder: (context, state) {
                        if (state is CreateProductLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ElevatedButton(
                          onPressed: () {
                            final productModel = ProductModel(
                                title: titleontroller!.text,
                                price: int.parse(priceController!.text),
                                description: descriptionController!.text);
                            context.read<CreateProductBloc>().add(
                                DoCreateProductEvent(
                                    productModel: productModel));
                          },
                          child: const Text('Save'),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(
          Icons.add,
          size: 24.0,
        ),
      ),
    );
  }
}

