import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platzi_fake_store_app/bloc/product/get_product_detail/get_product_detail_bloc.dart';

class DetailPage extends StatefulWidget {
  final String id;

  const DetailPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    context
        .read<GetProductDetailBloc>()
        .add(DoGetProductDetailEvent(id: int.parse(widget.id)));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Product',
          style: TextStyle(color: Colors.white),
        ),
        actions: const [],
      ),
      body: BlocBuilder<GetProductDetailBloc, GetProductDetailState>(
        builder: (context, state) {
          if (state is GetProductDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GetProductDetailLoaded) {
            final products = state.productResponseModel;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      products.title.toString(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: NetworkImage(products.images![0]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    products.description.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Price',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "\$ ${products.price.toString()}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: Text(
              'No Data',
              style: const TextStyle(color: Colors.black),
            ),
          );
        },
      ),
    );
  }
}
