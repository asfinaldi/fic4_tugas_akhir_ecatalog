import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:platzi_fake_store_app/data/datasources/product_datasources.dart';
import 'package:platzi_fake_store_app/data/models/request/product_model.dart';
import 'package:platzi_fake_store_app/data/models/response/product_response_model.dart';


part 'update_product_event.dart';
part 'update_product_state.dart';

class UpdateProductBloc extends Bloc<UpdateProductEvent, UpdateProductState> {
  final ProductDatasources productDatasources;

  UpdateProductBloc(this.productDatasources)
      : super(UpdateProductInitial()) {
    on<DoUpdateProductEvent>((event, emit) async {
      emit(UpdateProductLoading());
      final result =
          await productDatasources.updateProduct(event.productModel, event.id);
      emit(UpdateProductLoaded(productResponseModel: result));
    });
  }
}
