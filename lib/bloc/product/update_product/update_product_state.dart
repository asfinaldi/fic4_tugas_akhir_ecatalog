part of 'update_product_bloc.dart';

@immutable
abstract class UpdateProductState {}

class UpdateProductInitial extends UpdateProductState {}

class UpdateProductLoading extends UpdateProductState {}

class UpdateProductLoaded extends UpdateProductState {
  final ProductResponseModel productResponseModel;
  UpdateProductLoaded({required this.productResponseModel});
}

class UpdateProductError extends UpdateProductState {
  final String errorMessage;

  UpdateProductError({required this.errorMessage});
}
