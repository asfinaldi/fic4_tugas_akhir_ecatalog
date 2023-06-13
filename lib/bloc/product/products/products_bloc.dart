import 'package:bloc/bloc.dart';
import 'package:platzi_fake_store_app/data/datasources/product_datasources.dart';
import 'package:platzi_fake_store_app/data/models/response/product_response_model.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductDatasources dataSource;
  ProductsBloc(
    this.dataSource,
  ) : super(ProductsInitial()) {
    on<GetProductsEvent>((event, emit) async {
      emit(ProductsLoading());
      final result =
          await dataSource.getPaginationProduct(offset: 0, limit: 10);
      result.fold(
        (error) => emit(ProductsError(message: error)),
        (result) => emit(ProductsLoaded(data: result)),
      );
    });

    on<NextProductsEvent>((event, emit) async {
      final currentState = state as ProductsLoaded;
      emit(ProductsLoading());
      final result = await dataSource.getPaginationProduct(
          offset: currentState.offset + 10, limit: 10);
      result.fold(
        (error) => emit(ProductsError(message: error)),
        (result) {
          emit(ProductsLoaded(
              data: [...currentState.data, ...result],
              offset: currentState.offset + 10));
        },
      );
    });
  }
}
