import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platzi_fake_store_app/bloc/product/create_product/create_product_bloc.dart';
import 'package:platzi_fake_store_app/bloc/product/products/products_bloc.dart';
import 'package:platzi_fake_store_app/bloc/product/update_product/update_product_bloc.dart';
import 'package:platzi_fake_store_app/bloc/profile/profile_bloc.dart';
import 'package:platzi_fake_store_app/data/localsources/auth_local_storage.dart';
import 'package:platzi_fake_store_app/data/models/request/product_model.dart';
import 'package:platzi_fake_store_app/data/models/response/product_response_model.dart';
import 'package:platzi_fake_store_app/presemtation/pages/detail_page.dart';
import 'package:platzi_fake_store_app/presemtation/pages/login_page.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home-page';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController? titleController = TextEditingController();
  TextEditingController? descriptionController = TextEditingController();
  TextEditingController? priceController = TextEditingController();

  TextEditingController titleUpdateController = TextEditingController();
  TextEditingController descriptionUpdateController = TextEditingController();
  TextEditingController priceUpdateController = TextEditingController();
  final formUpdateKey = GlobalKey<FormState>();

  final scrollController = ScrollController();

  @override
  void initState() {
    context.read<ProfileBloc>().add(GetProfileEvent());
    context.read<ProductsBloc>().add(GetProductsEvent());
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        context.read<ProductsBloc>().add(NextProductsEvent());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    formUpdateKey.currentState?.dispose();
    super.dispose();
  }

  String? validateTitle(String title) {
    if (title.isEmpty) {
      return "Title cannot be empty";
    }
    return null;
  }

  String? validatePrice(String price) {
    if (price.isEmpty) {
      return "Price cannot be empty";
    } else if (price == '0') {
      return "Price minimum 1";
    }
    return null;
  }

  String? validateDescription(String desc) {
    if (desc.isEmpty) {
      return "Description cannot be empty";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CircleAvatar(
                radius: 16.0,
                backgroundImage: AssetImage(
                  "assets/icons/bebas.png",
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Column(
                children: [
                  BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      if (state is ProfileLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (state is ProfileLoaded) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.profile.name ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(
                              width: 20.0,
                            ),
                            Text(
                              state.profile.email ?? '',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                            ),
                          ],
                        );
                      }
                      return const Text('No data');
                    },
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: () async {
                  await AuthLocalStorage().removeToken();
                  Navigator.pushNamed(context, LoginPage.routeName);
                },
                icon: const Icon(
                  Icons.logout_outlined,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ProductsBloc, ProductsState>(
                builder: (context, state) {
                  if (state is ProductsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is ProductsLoaded) {
                    debugPrint('Total Data : ${state.data.length}');
                    // ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: state.data.length,
                      itemBuilder: (context, index) {
                        // final product = state.listProduct[index];
                        final product = state.data.reversed.toList()[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailPage(id: product.id.toString()),
                                ));
                          },
                          child: Card(
                            child: ListTile(
                              title: Text(
                                product.title ?? '-',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.description ?? '-',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.black),
                                  ),
                                  Text(
                                    "\$${product.price} ",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Colors.red),
                                  )
                                ],
                              ),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  '${product.images![0]}',
                                ),
                              ),
                              trailing: updateProduct(context, product),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const Text('No Product');
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: addProduct(context),
    );
  }

  FloatingActionButton addProduct(BuildContext context) {
    return FloatingActionButton(
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
                    decoration: InputDecoration(
                      labelText: 'Title',
                      hintText: 'Insert title',
                      hintStyle:
                          TextStyle(color: Colors.black.withOpacity(0.3)),
                    ),
                    controller: titleController,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Price',
                      hintText: 'Insert price',
                      hintStyle:
                          TextStyle(color: Colors.black.withOpacity(0.3)),
                    ),
                    controller: priceController,
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      hintText: 'Insert description',
                      hintStyle:
                          TextStyle(color: Colors.black.withOpacity(0.3)),
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
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.red),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  width: 4.0,
                ),
                BlocListener<CreateProductBloc, CreateProductState>(
                  listener: (context, state) {
                    if (state is CreateProductLoaded) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${state.productResponseModel.id}'),
                        ),
                      );
                      Navigator.pop(context);
                      context.read<ProductsBloc>().add(GetProductsEvent());
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
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          final productModel = ProductModel(
                            title: titleController!.text,
                            price: int.parse(priceController!.text),
                            description: descriptionController!.text,
                          );
                          context.read<CreateProductBloc>().add(
                                DoCreateProductEvent(
                                  productModel: productModel,
                                ),
                              );
                        },
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.green),
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
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
    );
  }

  IconButton updateProduct(BuildContext context, ProductResponseModel product) {
    return IconButton(
      onPressed: () {
        //_editProduct(product);
        showDialog(
          context: context,
          builder: (context) {
            titleUpdateController.text = product.title ?? '';
            priceUpdateController.text = product.price!.toString();
            descriptionUpdateController.text = product.description ?? '';

            return AlertDialog(
              title: const Text('Edit Product'),
              content: Form(
                key: formUpdateKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      validator: (title) => validateTitle(title!),
                      decoration: InputDecoration(
                        hintText: 'Insert title',
                        hintStyle: TextStyle(
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ),
                      controller: titleUpdateController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      validator: (price) => validatePrice(price!),
                      decoration: InputDecoration(
                          hintText: 'Insert price..',
                          hintStyle:
                              TextStyle(color: Colors.black.withOpacity(0.3))),
                      controller: priceUpdateController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      maxLines: 3,
                      validator: (desc) => validateDescription(desc!),
                      decoration: InputDecoration(
                          hintText: 'Insert description..',
                          hintStyle:
                              TextStyle(color: Colors.black.withOpacity(0.3))),
                      controller: descriptionUpdateController,
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                BlocListener<UpdateProductBloc, UpdateProductState>(
                  listener: (context, state) {
                    if (state is UpdateProductLoaded) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Update: ${state.productResponseModel.id}')));
                      Navigator.pop(context);
                      context.read<ProductsBloc>().add(GetProductsEvent());
                    }
                  },
                  child: BlocBuilder<UpdateProductBloc, UpdateProductState>(
                    builder: (context, state) {
                      if (state is UpdateProductLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green)),
                        onPressed: () {
                          if (formUpdateKey.currentState!.validate()) {
                            final productModel = ProductModel(
                              title: titleUpdateController.text,
                              price: int.parse(priceUpdateController.text),
                              description: descriptionUpdateController.text,
                            );

                            context.read<UpdateProductBloc>().add(
                                DoUpdateProductEvent(
                                    productModel: productModel,
                                    id: product.id!));
                          }
                        },
                        child: const Text('Save',
                            style: TextStyle(color: Colors.white)),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
      icon: const Icon(Icons.edit),
    );
  }
}
