// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'create_product_bloc.dart';

@immutable
abstract class CreateProductEvent {}

class DoCreateProductEvent extends CreateProductEvent {
  final ProductModel productModel;
  DoCreateProductEvent({
    required this.productModel,
  });
}
