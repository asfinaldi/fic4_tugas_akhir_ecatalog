part of 'products_bloc.dart';

abstract class ProductsState {
  const ProductsState();
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<ProductResponseModel> data;
  final int offset;
  final int limit;
  ProductsLoaded({
    required this.data,
    this.offset = 0,
     this.limit = 10,
  });
}

class ProductsError extends ProductsState {
  final String message;
  ProductsError({
    required this.message,
  });
}
