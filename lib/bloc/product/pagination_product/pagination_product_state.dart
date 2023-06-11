// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'pagination_product_bloc.dart';

@immutable
abstract class PaginationProductState {}

class PaginationProductInitial extends PaginationProductState {}

class PaginationProductLoading extends PaginationProductState {}

class PaginationProductLoaded extends PaginationProductState {
  final List<ProductResponseModel> listProduct;
  PaginationProductLoaded({
    required this.listProduct,
  });

}
