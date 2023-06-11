import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:platzi_fake_store_app/data/datasources/product_datasources.dart';
import 'package:platzi_fake_store_app/data/models/request/product_model.dart';
import 'package:platzi_fake_store_app/data/models/response/product_response_model.dart';

part 'get_product_detail_event.dart';
part 'get_product_detail_state.dart';

class GetProductDetailBloc
    extends Bloc<GetProductDetailEvent, GetProductDetailState> {
  final ProductDatasources productDatasources;
  GetProductDetailBloc(this.productDatasources)
      : super(GetProductDetailInitial()) {
    on<DoGetProductDetailEvent>((event, emit) async {
      emit(GetProductDetailLoading());
      final result = await productDatasources.getProductById(event.id);
      emit(GetProductDetailLoaded(productResponseModel: result));
    });
  }
}
