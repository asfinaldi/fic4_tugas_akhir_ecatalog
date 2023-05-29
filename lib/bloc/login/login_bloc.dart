import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:platzi_fake_store_app/data/datasources/auth_datasources.dart';
import 'package:platzi_fake_store_app/data/localsources/auth_local_storage.dart';
import 'package:platzi_fake_store_app/data/models/request/login_model.dart';
import 'package:platzi_fake_store_app/data/models/response/login_response_model.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthDatasource authDatasource;
  LoginBloc(
    this.authDatasource,
  ) : super(LoginInitial()) {
    on<DoLoginEvent>((event, emit) async {
      emit(LoginLoading());
      final result = await authDatasource.login(event.loginModel);

      result.fold(
        (error) {
          emit(LoginError(message: error));
        },
        (data) {
          AuthLocalStorage().saveToken(data.accessToken);
          emit(LoginLoaded(loginResponseModel: data));
        },
      );

      // try {
      //   emit(LoginLoading());
      //   final result = await authDatasource.login(event.loginModel);
      //   await AuthLocalStorage().saveToken(result.accessToken);
      //   emit(LoginLoaded(loginResponseModel: result));
      // } catch (e) {
      //   emit(LoginError(message: 'Network problem'));
      // }
    });
  }
}


// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
// import 'package:platzi_fake_store_app/data/datasources/auth_datasources.dart';
// import 'package:platzi_fake_store_app/data/localsources/auth_local_storage.dart';
// import 'package:platzi_fake_store_app/data/models/request/login_model.dart';
// import 'package:platzi_fake_store_app/data/models/response/login_response_model.dart';
// import 'package:dartz/dartz.dart';

// part 'login_event.dart';
// part 'login_state.dart';

// class LoginBloc extends Bloc<LoginEvent, LoginState> {
//   final AuthDatasource authDatasource;
//   LoginBloc(
//     this.authDatasource,
//   ) : super(LoginInitial()) {
//     on<DoLoginEvent>((event, emit) async {
//       try {
//         emit(LoginLoading());
//         final result = await authDatasource.login(event.loginModel);
//         result.fold(
//           (error) {
//             emit(LoginError(message: error));
//           },
//           (success) async {
//             await AuthLocalStorage().saveToken(success.accessToken);
//             emit(LoginLoaded(loginResponseModel: success));
//           },
//         );
//       } catch (e) {
//         emit(LoginError(message: 'Network problem'));
//       }
//     });
//   }
// }
