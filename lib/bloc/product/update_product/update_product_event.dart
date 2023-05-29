part of 'update_product_bloc.dart';

@immutable
abstract class UpdateProductEvent {}

class DoUpdateProductEvent extends UpdateProductEvent {
  final ProductModel productModel;
  final int id;

  DoUpdateProductEvent({required this.productModel, required this.id});
}
