// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_product_detail_bloc.dart';

@immutable
abstract class GetProductDetailState {}

class GetProductDetailInitial extends GetProductDetailState {}

class GetProductDetailLoading extends GetProductDetailState {}

class GetProductDetailLoaded extends GetProductDetailState {
  final ProductResponseModel productResponseModel;
  GetProductDetailLoaded({
    required this.productResponseModel,
  });
}

class GetProductDetailError extends GetProductDetailState {
  final String errorMessage;
  GetProductDetailError({
    required this.errorMessage,
  });
}
