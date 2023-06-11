// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_product_detail_bloc.dart';

@immutable
abstract class GetProductDetailEvent {}

class DoGetProductDetailEvent extends GetProductDetailEvent {
  final int id;
  DoGetProductDetailEvent({
    required this.id,
  });
  
}
