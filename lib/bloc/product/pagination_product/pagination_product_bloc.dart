// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:platzi_fake_store_app/data/datasources/product_datasources.dart';
import 'package:platzi_fake_store_app/data/models/response/product_response_model.dart';

part 'pagination_product_event.dart';
part 'pagination_product_state.dart';

class PaginationProductBloc
    extends Bloc<PaginationProductEvent, PaginationProductState> {
  final ProductDatasources productDatasources;
  PaginationProductBloc(
    this.productDatasources,
  ) : super(PaginationProductInitial()) {
    on<GetPaginationProductEvent>((event, emit) async {
      emit(PaginationProductLoading());
      final result = await productDatasources.getPaginationProduct();
      emit(PaginationProductLoaded(listProduct: result));
    });
  }
}